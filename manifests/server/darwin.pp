class olnfs::server::darwin(
  $olnfs_v4              = false,
  $olnfs_v4_idmap_domain = undef,
  $mountd_port         = undef,
  $mountd_threads      = undef,
  $service_manage      = true,
) {
  fail('olnfs server is not supported on Darwin')
}
