class olnfs::client::redhat (
  $olnfs_v4              = false,
  $olnfs_v4_idmap_domain = undef
) inherits olnfs::client::redhat::params {

  include ::olnfs::client::redhat::install
  include ::olnfs::client::redhat::configure
  include ::olnfs::client::redhat::service

  Class['::olnfs::client::redhat::install']
  -> Class['::olnfs::client::redhat::configure']
  -> Class['::olnfs::client::redhat::service']

}
