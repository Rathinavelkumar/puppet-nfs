# Gentoo specifix stuff
class ol8nfs::server::gentoo(
  $ol8nfs_v4 = false,
  $ol8nfs_v4_idmap_domain = undef,
  $mountd_port         = undef,
  $mountd_threads      = undef,
  $service_manage      = true,
) {

  if !defined(Class['ol8nfs::client::gentoo']) {
    class{ 'ol8nfs::client::gentoo':
      ol8nfs_v4              => $ol8nfs_v4,
      ol8nfs_v4_idmap_domain => $ol8nfs_v4_idmap_domain,
    }
  }

  if ($mountd_port != undef){
    fail('setting the mountd port currently not supported on Gentoo')
  }

  if ($mountd_threads != undef){
    fail('setting the mountd thread number currently not supported on Gentoo')
  }

  include ol8nfs::server::gentoo::install, ol8nfs::server::gentoo::service

}
