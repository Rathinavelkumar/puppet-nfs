#
#== Define olnfs::client::mount::olnfs_v4::root
#
# Mounts the olnfsv4 server root.
#
# Don't  use this without configuring a different mount path
# if you have several olnfs servers.
#
#

define olnfs::client::mount::olnfs_v4::root (
  $server,
  $ensure    = 'mounted',
  $mount     = undef,
  $remounts  = false,
  $atboot    = false,
  $options   = '_netdev',
  $bindmount = undef,
  $olnfstag    = undef
) {

  include ::olnfs::client

  if $mount == undef {
    $_nfs4_mount = $olnfs::client::olnfs_v4_mount_root
  } else {
    $_nfs4_mount = $mount
  }

  olnfs::mkdir{ $_nfs4_mount: }

  mount {"shared root by ${::clientcert} on ${_olnfs4_mount}":
    ensure   => $ensure,
    device   => "${server}:/",
    fstype   => 'olnfs4',
    name     => $_nfs4_mount,
    options  => $options,
    remounts => $remounts,
    atboot   => $atboot,
    require  => olnfs::Mkdir[$_nfs4_mount],
  }


  if $bindmount != undef {
    olnfs::client::mount::olnfs_v4::bindmount { $_nfs4_mount:
      ensure     => $ensure,
      mount_name => $bindmount,
    }
  }
}
