class ol8nfs::client::redhat (
  $ol8nfs_v4              = false,
  $ol8nfs_v4_idmap_domain = undef
) inherits ol8nfs::client::redhat::params {

  include ::ol8nfs::client::redhat::install
  include ::ol8nfs::client::redhat::configure
  include ::ol8nfs::client::redhat::service

  Class['::ol8nfs::client::redhat::install']
  -> Class['::ol8nfs::client::redhat::configure']
  -> Class['::ol8nfs::client::redhat::service']

}
