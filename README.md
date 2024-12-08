# olnfs

#### Table of Contents

1. [Overview - What is the olnfs module?](#overview)
2. [Module Description - What does this module do?](#module-description)
3. [Setup - The basics of getting started with olnfs](#setup)
    * [Simple mount an olnfs share](#simple-mount-olnfs-share)
    * [olnfsv3 server and client](#olnfsv3-server-and-client)
    * [olnfsv3 multiple exports, servers and multiple node](#olnfsv3-multiple-exports-servers-and-multiple-node)
    * [olnfsv4 Simple example](#olnfsv4-simple-example)
    * [olnfsv4 insanely overcomplicated reference](#olnfsv4-insanely-overcomplicated-reference)
    * [A large number of clients](#a-large-number-of-clients)
4. [Usage - The classes and defined types available for configuration](#usage)
    * [Class: olnfs::server](#class-olnfsserver)
    * [Defined Type: olnfs::server::export](#defined-type-olnfsserverexport)
    * [Class: olnfs::client](#class-olnfsclient)
    * [Defined Type: olnfs::client::mount](#defined-type-olnfsclientmount)
5. [Requirements](#requirements)
6. [Limitations - OS compatibility, etc.](#limitations)
7. [Contributing to the graphite module](#contributing)

## Overview

This module installs, configures and manages everything on olnfs clients and servers.

[![Puppet Forge](http://img.shields.io/puppetforge/v/echocat/olnfs.svg)](https://forge.puppetlabs.com/echocat/olnfs)
[![Build Status](https://secure.travis-ci.org/echocat/puppet-olnfs.png?branch=master)](https://travis-ci.org/echocat/puppet-olnfs)
[![Puppet Forge Downloads](http://img.shields.io/puppetforge/dt/echocat/olnfs.svg)](https://forge.puppetlabs.com/echocat/olnfs) 

## Module Description

This module can be used to simply mount olnfs shares on a client or to configure your olnfs servers.
It can make use of storeconfigs on the puppetmaster to get its resources. 

## Setup

**What olnfs affects:**

* packages/services/configuration files for olnfs usage
* can be used with puppet storage

### Simple mount olnfs share

This example mounts a olnfs share on the client, with olnfsv3

```puppet
include '::olnfs::client'

::olnfs::client::mount { '/mnt/mymountpoint':
  server  => 'olnfsserver.my.domain',
  share   => '/share/on/server',
  options => 'rw',
}
```

### olnfsv3 server and client

This will export /data/folder on the server and automagically mount it on client.
You need storeconfigs/puppetdb for this to work.
  
```puppet
node server {
  include olnfs::server

  ::olnfs::server::export{ '/data_folder':
    ensure  => 'mounted',
    clients => '10.0.0.0/24(rw,insecure,async,no_root_squash) localhost(rw)'
  }
}
```

By default, mounts are mounted in the same folder on the clients as
they were exported from on the server.

```puppet
node client {
  include '::olnfs::client'
  olnfs::Client::Mount <<| |>> 
}
```

### olnfsv3 multiple exports, servers and multiple node

```puppet
  node server1 {
    include '::olnfs::server'
    ::olnfs::server::export{ 
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
    include '::olnfs::server'
    # ensure is passed to mount, which will make the client not mount it
    # the directory automatically, just add it to fstab
    ::olnfs::server::export{ 
      '/media_library':
        ensure  => 'present',
        olnfstag     => 'media'
        clients => '10.0.0.0/24(rw,insecure,async,no_root_squash) localhost(rw)'
    }
  }

  node client {
    include '::olnfs::client'
    olnfs::Client::Mount <<| |>>; 
  }

  # Using a storeconfig override, to change ensure option, so we mount
  # all shares
  
  node greedy_client {
    include '::olnfs::client'
    olnfs::Client::Mount <<| |>> {
      ensure => 'mounted'
    }
  }


  # only the mount tagged as media 
  # also override mount point
  node media_client {
    include '::olnfs::client'
    olnfs::Client::Mount <<|olnfstag == 'media' |>> {
      ensure => 'mounted',
      mount  => '/import/media'
    }
  }

  # All @@olnfs::server::mount storeconfigs can be filtered by parameters
  # Also all parameters can be overridden (not that it's smart to do
  # so).
  # Check out the doc on exported resources for more info:
  # http://docs.puppetlabs.com/guides/exported_resources.html
  node single_server_client {
    include '::olnfs::client'
    olnfs::Client::Mount <<| server == 'server1' |>> {
      ensure => 'absent',
    }
  }
```

### olnfsv4 Simple example

We use the `$::domain` fact for the Domain setting in `/etc/idmapd.conf`.
For olnfsv4 to work this has to be equal on servers and clients
set it manually if unsure.

All olnfsv4 exports are bind mounted into `/export/$mount_name`
and mounted on `/srv/$mount_name` on the client.
Both values can be overridden through parameters both globally
and on individual nodes.

```puppet
  node server {
    class { 'olnfs::server':
      olnfs_v4 => true,
      olnfs_v4_export_root_clients =>
        '10.0.0.0/24(rw,fsid=root,insecure,no_subtree_check,async,no_root_squash)'
    }
    olnfs::server::export{ '/data_folder':
      ensure  => 'mounted',
      clients => '10.0.0.0/24(rw,insecure,no_subtree_check,async,no_root_squash) localhost(rw)'
    }
  }
```
Set ownership and permissions on the folder being exported

```puppet
  node server {
    olnfs::server::export{ '/data_folder':
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
  class { 'olnfs::client':
    olnfs_v4 = true,
    olnfs_v4_export_root_clients =>
      '10.0.0.0/24(rw,fsid=root,insecure,no_subtree_check,async,no_root_squash)'
  }
  olnfs::Client::Mount <<| |>>; 
}
```

We can also mount the olnfsv4 Root directly through olnfs::client::mount::olnfsv4::root.
By default /srv will be used for as mount point, but can be overriden through
the 'mounted' option.

```puppet
node client2 {
  $server = 'server'

  class { '::olnfs::client':
    olnfs_v4 = true,
  }
  olnfs::Client::Mount::olnfs_v4::Root <<| server == $server |>> { 
    mount => "/srv/$server",
  }
}
```

### olnfsv4 insanely overcomplicated reference

Just to show you, how complex we can make things ;-)

```puppet
  # and on individual nodes.
  node server {
    class { 'olnfs::server':
      olnfs_v4              => true,
      # Below are defaults
      olnfs_v4_idmap_domain => $::domain,
      olnfs_v4_export_root  => '/export',
      # Default access settings of /export root
      olnfs_v4_export_root_clients =>
        "*.${::domain}(ro,fsid=root,insecure,no_subtree_check,async,root_squash)"
    }
    
    olnfs::server::export{ '/data_folder':
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
      olnfstag     => undef,
      # copied directly into /etc/exports as a string, for simplicity
      clients => '10.0.0.0/24(rw,insecure,no_subtree_check,async,no_root_squash)'
  }

  node client {
    class { 'olnfs::client':
      olnfs_v4              => true,
      olnfs_v4_idmap_domain => $::domain
      olnfs_v4_mount_root   => '/srv',
    }

    # We can as you by now know, override options set on the server
    # on the client node.
    # Be careful. Don't override mount points unless you are sure
    # that only one export will match your filter!
    
    olnfs::Client::Mount <<| # filter goes here # |>> {
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
If a server has many clients it's a bit of a mess to put them all in a single 'clients' option for `olnfs::server::export`. Instead, you can put them in a array or hash and use the `mk_client_list` function to generate the clients string.

```
$olnfs_clients = [
    'common-*.loc.dom', 
    'hostb.loc.dom', 
    '10.0.9.0/24']

olnfs::server::export { '/data':
    clients => mk_client_list($olnfs_clients, {}, "ro"),
    # Which will produce:
    # 'common-*.loc.dom(ro) hostb.loc.dom(ro) 10.0.9.0/24(ro)'
    ...
}
```

In this case mk_client_list generates the string: `

The second option is a hash of client -> options. The third option is the default in case a client doesn't have options specified in the hash. In the above example none of the clients had specific settings, so they were all given the default options of `ro`.
```
$olnfs_clients = [
    'common-*.loc.dom', 
    'hostb.loc.dom', 
    '10.0.9.0/24']

$olnfs_client_options = {
    'hostb.loc.dom'     => 'rw,no_root_squash'}

olnfs::server::export {'/data':
    # Use the stdlib keys function to get the array of keys from our hash.
    clients => mk_client_list($olnfs_clients, $olnfs_client_options, 'ro'),
    # Which will produce:
    # 'common-*.loc.dom(ro) hostb.loc.dom(rw,no_root_squash) 10.0.9.0/24(ro)'
    ...
}
```

You can also give options to each host in a hash, and then use the stdlib keys() function to extract the client array from the hash: `mk_client_list(keys($client_hash), $client_hash, '')`

## Usage

#### Class: `olnfs::server`

Set up olnfs server and exports. olnfsv3 and olnfsv4 supported.

**Parameters within `olnfs::server`:**

##### `service_manage` (true)

Should this class manage the services behind olnfs? Set this to false
if you are managing the service in another way (e.g. pacemaker).

##### `package_ensure` (installed)

Allow to update or set to a specific version the olnfs server packages.

##### `olnfs_v4` (optional)

olnfsv4 support. Will set up automatic bind mounts to export root.
Disabled by default.

##### `olnfs_v4_export_root` (optional)

Export root, where we bind mount shares, default /export

##### `olnfs_v4_idmap_domain` (optional)

Domain setting for idmapd, must be the same across server
and clients. Default is to use $domain fact.

##### `exports` (optional)

If set, this attribute will be used to
construct olnfs::server::export resources. You can use you ENC or hiera to
provide the hash of olnfs::server::export resources definitions:

```hiera
olnfs::server::exports:
  /mnt/something:
    ensure: mounted
    clients: '*(fsid=0,ro,insecure,async,all_squash,no_subtree_check,mountpoint=/mnt/something)'
```

##### Examples

```puppet
class { '::olnfs::server':
  olnfs_v4                      => true,
  olnfs_v4_export_root_clients  => "*.${::domain}(ro,fsid=root,insecure,no_subtree_check,async,root_squash)",
  # Generally parameters below have sane defaults.
  olnfs_v4_export_root          => "/export",
  olnfs_v4_idmap_domain         => $::domain,
}
```

#### Defined Type: `olnfs::server::export`

Set up olnfs export on the server (and stores data in configstore)

**Parameters within `olnfs::server::export`:**

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

##### `olnfstag` (optional)

Default is undef. Used to identify a catalog item for filtering by storeconfigs on clients.

##### `clients` (optional)

Default is 'localhost(ro)'. Copied directly into /etc/exports as a string, for simplicity.

##### `server` (optional)

Default is `$::clientcert`. Used to specify a other ip/name for the client to connect to. Usefull in machines with multiple ip addresses or network interfaces

##### Example

```puppet
::olnfs::server::export { '/media_library':
  olnfstag  => 'media'
  clients => '10.0.0.0/24(rw,insecure,async,no_root_squash) localhost(rw)'
}
```

#### Class: `olnfs::client`

Set up olnfs client and mounts. olnfsv3 and olnfsv4 supported.

**Parameters within `olnfs::client`:**

##### `package_ensure` (installed)

Allow to update or set to a specific version the olnfs client packages.

##### `olnfs_v4`

olnfsv4 support.
Disabled by default.

##### `olnfs_v4_mount_root`

Mount root, where we  mount shares, default /srv

##### `olnfs_v4_idmap_domain`

Domain setting for idmapd, must be the same across server
and clients. Default is to use $::domain fact.

##### `mounts` (optional)

If set, this attribute will be used to construct olnfs::client::mount resources.
You can use you ENC or hiera to provide the hash of olnfs::client::mount
resources definitions:

```hiera
olnfs::client::mounts:
  /mnt/test:
    ensure: 'mounted'
    server: '192.0.2.100'
    share:  '/export/data'
```

##### Example

```puppet
class { '::olnfs::client':
  olnfs_v4              => true,
  # Generally parameters below have sane defaults.
  olnfs_v4_mount_root   => '/srv',
  olnfs_v4_idmap_domain => $::domain,
}
```

#### Defined Type: `olnfs::client::mount`

Set up olnfs mount on client.

**Parameters within `olnfs::client::mount`:**

##### `server`

FQDN or IP of the olnfs server.

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

##### `olnfstag` (optional)

Default is undef. Used to identify a catalog item for filtering by storeconfigs on clients.

##### `owner` (optional)

Default is 'root'. Sets owner of mountpoint directory. This is applied to the directory on every run, which means it is used both on the base mountpoint creation when unmounted, and also once mounted on the target olnfs server and thus all servers accessing the same share.

##### `group` (optional)

Default is `root`. Sets group of mountpoint directory. This is applied to the directory on every run, which means it is used both on the base mountpoint creation when unmounted, and also once mounted on the target olnfs server and thus all servers accessing the same share.

##### `perm` (optional)

Default is '0755'. Sets mode of mountpoint directory. This has changed from previous versons which used '0777' (world writable). This is applied to the directory on every run, which means it is used both on the base mountpoint creation when unmounted, and also once mounted on the target olnfs server and thus all servers accessing the same share.

## Requirements

If you want to have the full potential of this module its recommend to have storeconfigs enabled.

## Limitations

##Contributing

Echocat modules are open projects. So if you want to make this module even better, you can contribute to this module on [Github](https://github.com/echocat/puppet-olnfs).

This module is forked/based on Harald Skoglund <haraldsk@redpill-linpro.com> from https://github.com/haraldsk/puppet-module-olnfs/

Please read DEVELOP.md on how to contribute to this module.
