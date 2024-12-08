# Gentoo specifix stuff
class olnfs::server::gentoo(
  $olnfs_v4 = false,
  $olnfs_v4_idmap_domain = undef,
  $mountd_port         = undef,
  $mountd_threads      = undef,
  $service_manage      = true,
) {

  if !defined(Class['olnfs::client::gentoo']) {
    class{ 'olnfs::client::gentoo':
      olnfs_v4              => $olnfs_v4,
      olnfs_v4_idmap_domain => $olnfs_v4_idmap_domain,
    }
  }

  if ($mountd_port != undef){
    fail('setting the mountd port currently not supported on Gentoo')
  }

  if ($mountd_threads != undef){
    fail('setting the mountd thread number currently not supported on Gentoo')
  }

  include olnfs::server::gentoo::install, olnfs::server::gentoo::service

}
