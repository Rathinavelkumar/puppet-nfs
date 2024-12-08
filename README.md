# ol8nfs

#### Table of Contents

1. [Overview - What is the ol8nfs module?](#overview)
2. [Module Description - What does this module do?](#module-description)
3. [Setup - The basics of getting started with ol8nfs](#setup)
    * [Simple mount an ol8nfs share](#simple-mount-ol8nfs-share)
    * [ol8nfsv3 server and client](#ol8nfsv3-server-and-client)
    * [ol8nfsv3 multiple exports, servers and multiple node](#ol8nfsv3-multiple-exports-servers-and-multiple-node)
    * [ol8nfsv4 Simple example](#ol8nfsv4-simple-example)
    * [ol8nfsv4 insanely overcomplicated reference](#ol8nfsv4-insanely-overcomplicated-reference)
    * [A large number of clients](#a-large-number-of-clients)
4. [Usage - The classes and defined types available for configuration](#usage)
    * [Class: ol8nfs::server](#class-ol8nfsserver)
    * [Defined Type: ol8nfs::server::export](#defined-type-ol8nfsserverexport)
    * [Class: ol8nfs::client](#class-ol8nfsclient)
    * [Defined Type: ol8nfs::client::mount](#defined-type-ol8nfsclientmount)
5. [Requirements](#requirements)
6. [Limitations - OS compatibility, etc.](#limitations)
7. [Contributing to the graphite module](#contributing)

## Overview

This module installs, configures and manages everything on ol8nfs clients and servers.

[![Puppet Forge](http://img.shields.io/puppetforge/v/echocat/ol8nfs.svg)](https://forge.puppetlabs.com/echocat/ol8nfs)
[![Build Status](https://secure.travis-ci.org/echocat/puppet-ol8nfs.png?branch=master)](https://travis-ci.org/echocat/puppet-ol8nfs)
[![Puppet Forge Downloads](http://img.shields.io/puppetforge/dt/echocat/ol8nfs.svg)](https://forge.puppetlabs.com/echocat/ol8nfs) 

## Module Description

This module can be used to simply mount ol8nfs shares on a client or to configure your ol8nfs servers.
It can make use of storeconfigs on the puppetmaster to get its resources. 

## Setup

**What ol8nfs affects:**

* packages/services/configuration files for ol8nfs usage
* can be used with puppet storage

### Simple mount ol8nfs share

This example mounts a ol8nfs share on the client, with ol8nfsv3

```puppet
include '::ol8nfs::client'

::ol8nfs::client::mount { '/mnt/mymountpoint':
  server  => 'ol8nfsserver.my.domain',
  share   => '/share/on/server',
  options => 'rw',
}
```

### ol8nfsv3 server and client

This will export /data/folder on the server and automagically mount it on client.
You need storeconfigs/puppetdb for this to work.
  
```puppet
node server {
  include ol8nfs::server

  ::ol8nfs::server::export{ '/data_folder':
    ensure  => 'mounted',
    clients => '10.0.0.0/24(rw,insecure,async,no_root_squash) localhost(rw)'
  }
}
```

By default, mounts are mounted in the same folder on the clients as
they were exported from on the server.

```puppet
node client {
  include '::ol8nfs::client'
  ol8nfs::Client::Mount <<| |>> 
}
```

### ol8nfsv3 multiple exports, servers and multiple node

```puppet
  node server1 {
    include '::ol8nfs::server'
    ::ol8nfs::server::export{ 
      '/data_folder':
        ensure  => 'mounted',
        clients => '10.0.0.0/24(rw,insecure,async,no_root_squash) localhost(rw)'
      # exports /homeexport and mounts them om /srv/home on the clients
      '/homeexport':
        ensure  => 'mounted',
        clients => '10.0.0.0/24(rw,insecure,async,root_squash)',
        mount   => '/srv/home'
    }
  }

  node server2 {
    include '::ol8nfs::server'
    # ensure is passed to mount, which will make the client not mount it
    # the directory automatically, just add it to fstab
    ::ol8nfs::server::export{ 
      '/media_library':
        ensure  => 'present',
        ol8nfstag     => 'media'
        clients => '10.0.0.0/24(rw,insecure,async,no_root_squash) localhost(rw)'
    }
  }

  node client {
    include '::ol8nfs::client'
    ol8nfs::Client::Mount <<| |>>; 
  }

  # Using a storeconfig override, to change ensure option, so we mount
  # all shares
  
  node greedy_client {
    include '::ol8nfs::client'
    ol8nfs::Client::Mount <<| |>> {
      ensure => 'mounted'
    }
  }


  # only the mount tagged as media 
  # also override mount point
  node media_client {
    include '::ol8nfs::client'
    ol8nfs::Client::Mount <<|ol8nfstag == 'media' |>> {
      ensure => 'mounted',
      mount  => '/import/media'
    }
  }

  # All @@ol8nfs::server::mount storeconfigs can be filtered by parameters
  # Also all parameters can be overridden (not that it's smart to do
  # so).
  # Check out the doc on exported resources for more info:
  # http://docs.puppetlabs.com/guides/exported_resources.html
  node single_server_client {
    include '::ol8nfs::client'
    ol8nfs::Client::Mount <<| server == 'server1' |>> {
      ensure => 'absent',
    }
  }
```

### ol8nfsv4 Simple example

We use the `$::domain` fact for the Domain setting in `/etc/idmapd.conf`.
For ol8nfsv4 to work this has to be equal on servers and clients
set it manually if unsure.

All ol8nfsv4 exports are bind mounted into `/export/$mount_name`
and mounted on `/srv/$mount_name` on the client.
Both values can be overridden through parameters both globally
and on individual nodes.

```puppet
  node server {
    class { 'ol8nfs::server':
      ol8nfs_v4 => true,
      ol8nfs_v4_export_root_clients =>
        '10.0.0.0/24(rw,fsid=root,insecure,no_subtree_check,async,no_root_squash)'
    }
    ol8nfs::server::export{ '/data_folder':
      ensure  => 'mounted',
      clients => '10.0.0.0/24(rw,insecure,no_subtree_check,async,no_root_squash) localhost(rw)'
    }
  }
```
Set ownership and permissions on the folder being exported

```puppet
  node server {
    ol8nfs::server::export{ '/data_folder':
      ensure  => 'mounted',
      clients => '10.0.0.0/24(rw,insecure,no_subtree_check,async,no_root_squash) localhost(rw)',
      owner => 'root',
      group => 'root',
      perms => '0755',
    }
  }
```

By default, mounts are mounted in the same folder on the clients as
they were exported from on the server

```puppet
node client {
  class { 'ol8nfs::client':
    ol8nfs_v4 = true,
    ol8nfs_v4_export_root_clients =>
      '10.0.0.0/24(rw,fsid=root,insecure,no_subtree_check,async,no_root_squash)'
  }
  ol8nfs::Client::Mount <<| |>>; 
}
```

We can also mount the ol8nfsv4 Root directly through ol8nfs::client::mount::ol8nfsv4::root.
By default /srv will be used for as mount point, but can be overriden through
the 'mounted' option.

```puppet
node client2 {
  $server = 'server'

  class { '::ol8nfs::client':
    ol8nfs_v4 = true,
  }
  ol8nfs::Client::Mount::ol8nfs_v4::Root <<| server == $server |>> { 
    mount => "/srv/$server",
  }
}
```

### ol8nfsv4 insanely overcomplicated reference

Just to show you, how complex we can make things ;-)

```puppet
  # and on individual nodes.
  node server {
    class { 'ol8nfs::server':
      ol8nfs_v4              => true,
      # Below are defaults
      ol8nfs_v4_idmap_domain => $::domain,
      ol8nfs_v4_export_root  => '/export',
      # Default access settings of /export root
      ol8nfs_v4_export_root_clients =>
        "*.${::domain}(ro,fsid=root,insecure,no_subtree_check,async,root_squash)"
    }
    
    ol8nfs::server::export{ '/data_folder':
      # These are the defaults
      ensure  => 'mounted',
      # rbind or bind mounting of folders bindmounted into /export 
      # google it
      bind    => 'rbind',
      # everything below here is propogated by to storeconfigs
      # to clients
      #
      # Directory where we want export mounted on client 
      mount     => undef, 
      remounts  => false,
      atboot    => false,
      #  Don't remove that option, but feel free to add more.
      options   => '_netdev',
      # If set will mount share inside /srv (or overridden mount_root)
      # and then bindmount to another directory elsewhere in the fs -
      # for fanatics.
      bindmount => undef,    
      # Used to identify a catalog item for filtering by by
      # storeconfigs, kick ass.
      ol8nfstag     => undef,
      # copied directly into /etc/exports as a string, for simplicity
      clients => '10.0.0.0/24(rw,insecure,no_subtree_check,async,no_root_squash)'
  }

  node client {
    class { 'ol8nfs::client':
      ol8nfs_v4              => true,
      ol8nfs_v4_idmap_domain => $::domain
      ol8nfs_v4_mount_root   => '/srv',
    }

    # We can as you by now know, override options set on the server
    # on the client node.
    # Be careful. Don't override mount points unless you are sure
    # that only one export will match your filter!
    
    ol8nfs::Client::Mount <<| # filter goes here # |>> {
      # Directory where we want export mounted on client 
      mount     => undef, 
      remounts  => false,
      atboot    => false,
      #  Don't remove that option, but feel free to add more.
      options   => '_netdev',
      # If set will mount share inside /srv (or overridden mount_root)
      # and then bindmount to another directory elsewhere in the fs -
      # for fanatics.
      bindmount => undef,    
    }
  }
```

#### A large number of clients
If a server has many clients it's a bit of a mess to put them all in a single 'clients' option for `ol8nfs::server::export`. Instead, you can put them in a array or hash and use the `mk_client_list` function to generate the clients string.

```
$ol8nfs_clients = [
    'common-*.loc.dom', 
    'hostb.loc.dom', 
    '10.0.9.0/24']

ol8nfs::server::export { '/data':
    clients => mk_client_list($ol8nfs_clients, {}, "ro"),
    # Which will produce:
    # 'common-*.loc.dom(ro) hostb.loc.dom(ro) 10.0.9.0/24(ro)'
    ...
}
```

In this case mk_client_list generates the string: `

The second option is a hash of client -> options. The third option is the default in case a client doesn't have options specified in the hash. In the above example none of the clients had specific settings, so they were all given the default options of `ro`.
```
$ol8nfs_clients = [
    'common-*.loc.dom', 
    'hostb.loc.dom', 
    '10.0.9.0/24']

$ol8nfs_client_options = {
    'hostb.loc.dom'     => 'rw,no_root_squash'}

ol8nfs::server::export {'/data':
    # Use the stdlib keys function to get the array of keys from our hash.
    clients => mk_client_list($ol8nfs_clients, $ol8nfs_client_options, 'ro'),
    # Which will produce:
    # 'common-*.loc.dom(ro) hostb.loc.dom(rw,no_root_squash) 10.0.9.0/24(ro)'
    ...
}
```

You can also give options to each host in a hash, and then use the stdlib keys() function to extract the client array from the hash: `mk_client_list(keys($client_hash), $client_hash, '')`

## Usage

#### Class: `ol8nfs::server`

Set up ol8nfs server and exports. ol8nfsv3 and ol8nfsv4 supported.

**Parameters within `ol8nfs::server`:**

##### `service_manage` (true)

Should this class manage the services behind ol8nfs? Set this to false
if you are managing the service in another way (e.g. pacemaker).

##### `package_ensure` (installed)

Allow to update or set to a specific version the ol8nfs server packages.

##### `ol8nfs_v4` (optional)

ol8nfsv4 support. Will set up automatic bind mounts to export root.
Disabled by default.

##### `ol8nfs_v4_export_root` (optional)

Export root, where we bind mount shares, default /export

##### `ol8nfs_v4_idmap_domain` (optional)

Domain setting for idmapd, must be the same across server
and clients. Default is to use $domain fact.

##### `exports` (optional)

If set, this attribute will be used to
construct ol8nfs::server::export resources. You can use you ENC or hiera to
provide the hash of ol8nfs::server::export resources definitions:

```hiera
ol8nfs::server::exports:
  /mnt/something:
    ensure: mounted
    clients: '*(fsid=0,ro,insecure,async,all_squash,no_subtree_check,mountpoint=/mnt/something)'
```

##### Examples

```puppet
class { '::ol8nfs::server':
  ol8nfs_v4                      => true,
  ol8nfs_v4_export_root_clients  => "*.${::domain}(ro,fsid=root,insecure,no_subtree_check,async,root_squash)",
  # Generally parameters below have sane defaults.
  ol8nfs_v4_export_root          => "/export",
  ol8nfs_v4_idmap_domain         => $::domain,
}
```

#### Defined Type: `ol8nfs::server::export`

Set up ol8nfs export on the server (and stores data in configstore)

**Parameters within `ol8nfs::server::export`:**

##### `v3_export_name` (optional)

Default is `$name`. Usally you do not set it explicit.

##### `v4_export_name` (optional)

Default results from `$name`. Usally you do not set it explicit.

##### `ensure` (optional)

Default is 'mounted'

##### `bind` (optional)

Default is 'rbind'. 
rbind or bind mounting of folders bindmounted into /export. Google it!

**Following parameteres are propogated by to storeconfigs to clients**

##### `mount` (optional)

Default is undef. This means client mount path is the same as server export path.
Directory where we want export mounted on client 

##### `remounts` (optional)

Default is false.

##### `atboot` (optional)

Default is false.

##### `options` (optional)

Default is '_netdev'. Don't remove that option, but feel free to add more.

##### `bindmount` (optional)

Default is undef. If set will mount share inside /srv (or overridden mount_root)
and then bindmount to another directory elsewhere in the fs - for fanatics.

##### `ol8nfstag` (optional)

Default is undef. Used to identify a catalog item for filtering by storeconfigs on clients.

##### `clients` (optional)

Default is 'localhost(ro)'. Copied directly into /etc/exports as a string, for simplicity.

##### `server` (optional)

Default is `$::clientcert`. Used to specify a other ip/name for the client to connect to. Usefull in machines with multiple ip addresses or network interfaces

##### Example

```puppet
::ol8nfs::server::export { '/media_library':
  ol8nfstag  => 'media'
  clients => '10.0.0.0/24(rw,insecure,async,no_root_squash) localhost(rw)'
}
```

#### Class: `ol8nfs::client`

Set up ol8nfs client and mounts. ol8nfsv3 and ol8nfsv4 supported.

**Parameters within `ol8nfs::client`:**

##### `package_ensure` (installed)

Allow to update or set to a specific version the ol8nfs client packages.

##### `ol8nfs_v4`

ol8nfsv4 support.
Disabled by default.

##### `ol8nfs_v4_mount_root`

Mount root, where we  mount shares, default /srv

##### `ol8nfs_v4_idmap_domain`

Domain setting for idmapd, must be the same across server
and clients. Default is to use $::domain fact.

##### `mounts` (optional)

If set, this attribute will be used to construct ol8nfs::client::mount resources.
You can use you ENC or hiera to provide the hash of ol8nfs::client::mount
resources definitions:

```hiera
ol8nfs::client::mounts:
  /mnt/test:
    ensure: 'mounted'
    server: '192.0.2.100'
    share:  '/export/data'
```

##### Example

```puppet
class { '::ol8nfs::client':
  ol8nfs_v4              => true,
  # Generally parameters below have sane defaults.
  ol8nfs_v4_mount_root   => '/srv',
  ol8nfs_v4_idmap_domain => $::domain,
}
```

#### Defined Type: `ol8nfs::client::mount`

Set up ol8nfs mount on client.

**Parameters within `ol8nfs::client::mount`:**

##### `server`

FQDN or IP of the ol8nfs server.

##### `share`

Name of share to be mounted.

##### `ensure` (optional)

Default is 'mounted'.

##### `mount` (optional)

Default is `$title` of defined type. Defines mountpoint of the share on the client.

##### `remounts` (optional)

Default is false.

##### `atboot` (optional)

Default is false.

##### `options` (optional)

Default is '_netdev'. Don't remove that option, but feel free to add more.

##### `bindmount` (optional)

Default is undef. If set will mount share inside /srv (or overridden mount_root)
and then bindmount to another directory elsewhere in the fs - for fanatics.

##### `ol8nfstag` (optional)

Default is undef. Used to identify a catalog item for filtering by storeconfigs on clients.

##### `owner` (optional)

Default is 'root'. Sets owner of mountpoint directory. This is applied to the directory on every run, which means it is used both on the base mountpoint creation when unmounted, and also once mounted on the target ol8nfs server and thus all servers accessing the same share.

##### `group` (optional)

Default is `root`. Sets group of mountpoint directory. This is applied to the directory on every run, which means it is used both on the base mountpoint creation when unmounted, and also once mounted on the target ol8nfs server and thus all servers accessing the same share.

##### `perm` (optional)

Default is '0755'. Sets mode of mountpoint directory. This has changed from previous versons which used '0777' (world writable). This is applied to the directory on every run, which means it is used both on the base mountpoint creation when unmounted, and also once mounted on the target ol8nfs server and thus all servers accessing the same share.

## Requirements

If you want to have the full potential of this module its recommend to have storeconfigs enabled.

## Limitations

##Contributing

Echocat modules are open projects. So if you want to make this module even better, you can contribute to this module on [Github](https://github.com/echocat/puppet-ol8nfs).

This module is forked/based on Harald Skoglund <haraldsk@redpill-linpro.com> from https://github.com/haraldsk/puppet-module-ol8nfs/

Please read DEVELOP.md on how to contribute to this module.
