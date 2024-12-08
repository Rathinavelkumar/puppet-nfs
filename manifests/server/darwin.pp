class ol8nfs::server::darwin(
  $ol8nfs_v4              = false,
  $ol8nfs_v4_idmap_domain = undef,
  $mountd_port         = undef,
  $mountd_threads      = undef,
  $service_manage      = true,
) {
  fail('ol8nfs server is not supported on Darwin')
}
