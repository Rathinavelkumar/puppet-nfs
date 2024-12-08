#
#== Define ol8nfs::client::mount::ol8nfs_v4::root
#
# Mounts the ol8nfsv4 server root.
#
# Don't  use this without configuring a different mount path
# if you have several ol8nfs servers.
#
#

define ol8nfs::client::mount::ol8nfs_v4::root (
  $server,
  $ensure    = 'mounted',
  $mount     = undef,
  $remounts  = false,
  $atboot    = false,
  $options   = '_netdev',
  $bindmount = undef,
  $ol8nfstag    = undef
) {

  include ::ol8nfs::client

  if $mount == undef {
    $_ol8nfs4_mount = $ol8nfs::client::ol8nfs_v4_mount_root
  } else {
    $_ol8nfs4_mount = $mount
  }

  ol8nfs::mkdir{ $_ol8nfs4_mount: }

  mount {"shared root by ${::clientcert} on ${_ol8nfs4_mount}":
    ensure   => $ensure,
    device   => "${server}:/",
    fstype   => 'ol8nfs4',
    name     => $_ol8nfs4_mount,
    options  => $options,
    remounts => $remounts,
    atboot   => $atboot,
    require  => ol8nfs::Mkdir[$_ol8nfs4_mount],
  }


  if $bindmount != undef {
    ol8nfs::client::mount::ol8nfs_v4::bindmount { $_ol8nfs4_mount:
      ensure     => $ensure,
      mount_name => $bindmount,
    }
  }
}
