class olnfs::client::gentoo (
  $olnfs_v4 = false,
  $olnfs_v4_idmap_domain = undef
) {

  include ::olnfs::client::gentoo::install
  include ::olnfs::client::gentoo::configure
  include ::olnfs::client::gentoo::service

  Class['::olnfs::client::gentoo::install']
  -> Class['::olnfs::client::gentoo::configure']
  -> Class['::olnfs::client::gentoo::service']


}
