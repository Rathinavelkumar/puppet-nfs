class olnfs::client::darwin (
  $olnfs_v4              = false,
  $olnfs_v4_idmap_domain = undef
) {
  fail('olnfs client is not supported on Darwin')
}
