class olnfs::client::ubuntu (
  $olnfs_v4 = false,
  $olnfs_v4_idmap_domain = undef
) {

  include ::olnfs::client::ubuntu::install
  include ::olnfs::client::ubuntu::configure
  include ::olnfs::client::ubuntu::service

  Class['::olnfs::client::ubuntu::install']
  -> Class['::olnfs::client::ubuntu::configure']
  -> Class['::olnfs::client::ubuntu::service']

}
