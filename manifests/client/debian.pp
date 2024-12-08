class olnfs::client::debian (
  $olnfs_v4 = false,
  $olnfs_v4_idmap_domain = undef
) {

  include ::olnfs::client::debian::install
  include ::olnfs::client::debian::configure
  include ::olnfs::client::debian::service

  Class['::olnfs::client::debian::install']
  -> Class['::olnfs::client::debian::configure']
  -> Class['::olnfs::client::debian::service']

}
