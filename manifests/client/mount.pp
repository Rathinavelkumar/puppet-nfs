define ol8nfs::client::mount (
  $server,
  $share,
  $ensure    = 'mounted',
  $mount     = undef,
  $remounts  = false,
  $atboot    = false,
  $options   = '_netdev',
  $bindmount = undef,
  $ol8nfstag    = undef,
  $owner     = 'root',
  $group     = 'root',
  $perm      = '0755',
) {

  include ::ol8nfs::client

  if $ol8nfs::client::ol8nfs_v4 == true {

    if $mount == undef {
      $_ol8nfs4_mount = "${ol8nfs::client::ol8nfs_v4_mount_root}/${share}"
    } else {
      $_ol8nfs4_mount = $mount
    }

    ol8nfs::mkdir { $_ol8nfs4_mount:
      owner => $owner,
      group => $group,
      perm  => $perm;
    }

    mount {"shared ${server}:${share} by ${::clientcert} on ${_ol8nfs4_mount}":
      ensure   => $ensure,
      device   => "${server}:/${share}",
      fstype   => 'ol8nfs4',
      name     => $_ol8nfs4_mount,
      options  => $options,
      remounts => $remounts,
      atboot   => $atboot,
      require  => [
        ol8nfs::Mkdir[$_ol8nfs4_mount],
        Class['::ol8nfs::client'],
      ],
    }


    if $bindmount != undef {
      ol8nfs::client::mount::ol8nfs_v4::bindmount { $_ol8nfs4_mount:
        ensure     => $ensure,
        mount_name => $bindmount,
      }
    }

    # dependencies for mount:

  } else {

    if $mount == undef {
      $_mount = $share
    } else {
      $_mount = $mount
    }

    ol8nfs::mkdir{ $_mount:
      owner => $owner,
      group => $group,
      perm  => $perm,
    }

    mount {"shared ${server}:${share} by ${::clientcert} ${_mount}":
      ensure   => $ensure,
      device   => "${server}:${share}",
      fstype   => 'ol8nfs',
      name     => $_mount,
      options  => $options,
      remounts => $remounts,
      atboot   => $atboot,
      require  => [
        ol8nfs::Mkdir[$_mount],
        Class['::ol8nfs::client'],
      ],
    }

  }

}
