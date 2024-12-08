class ol8nfs::client::ubuntu (
  $ol8nfs_v4 = false,
  $ol8nfs_v4_idmap_domain = undef
) {

  include ::ol8nfs::client::ubuntu::install
  include ::ol8nfs::client::ubuntu::configure
  include ::ol8nfs::client::ubuntu::service

  Class['::ol8nfs::client::ubuntu::install']
  -> Class['::ol8nfs::client::ubuntu::configure']
  -> Class['::ol8nfs::client::ubuntu::service']

}
