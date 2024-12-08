define olnfs::client::mount (
  $server,
  $share,
  $ensure    = 'mounted',
  $mount     = undef,
  $remounts  = false,
  $atboot    = false,
  $options   = '_netdev',
  $bindmount = undef,
  $olnfstag    = undef,
  $owner     = 'root',
  $group     = 'root',
  $perm      = '0755',
) {

  include ::olnfs::client

  if $olnfs::client::olnfs_v4 == true {

    if $mount == undef {
      $_nfs4_mount = "${olnfs::client::olnfs_v4_mount_root}/${share}"
    } else {
      $_nfs4_mount = $mount
    }

    olnfs::mkdir { $_nfs4_mount:
      owner => $owner,
      group => $group,
      perm  => $perm;
    }

    mount {"shared ${server}:${share} by ${::clientcert} on ${_olnfs4_mount}":
      ensure   => $ensure,
      device   => "${server}:/${share}",
      fstype   => 'nfs4',
      name     => $_nfs4_mount,
      options  => $options,
      remounts => $remounts,
      atboot   => $atboot,
      require  => [
        Olnfs::Mkdir[$_nfs4_mount],
        Class['::olnfs::client'],
      ],
    }


    if $bindmount != undef {
      olnfs::client::mount::olnfs_v4::bindmount { $_nfs4_mount:
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

    olnfs::mkdir{ $_mount:
      owner => $owner,
      group => $group,
      perm  => $perm,
    }

    mount {"shared ${server}:${share} by ${::clientcert} ${_mount}":
      ensure   => $ensure,
      device   => "${server}:${share}",
      fstype   => 'olnfs',
      name     => $_mount,
      options  => $options,
      remounts => $remounts,
      atboot   => $atboot,
      require  => [
        Olnfs::Mkdir[$_mount],
        Class['::olnfs::client'],
      ],
    }

  }

}
