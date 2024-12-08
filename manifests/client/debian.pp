class ol8nfs::client::debian (
  $ol8nfs_v4 = false,
  $ol8nfs_v4_idmap_domain = undef
) {

  include ::ol8nfs::client::debian::install
  include ::ol8nfs::client::debian::configure
  include ::ol8nfs::client::debian::service

  Class['::ol8nfs::client::debian::install']
  -> Class['::ol8nfs::client::debian::configure']
  -> Class['::ol8nfs::client::debian::service']

}
