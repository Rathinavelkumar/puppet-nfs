class ol8nfs::client::gentoo (
  $ol8nfs_v4 = false,
  $ol8nfs_v4_idmap_domain = undef
) {

  include ::ol8nfs::client::gentoo::install
  include ::ol8nfs::client::gentoo::configure
  include ::ol8nfs::client::gentoo::service

  Class['::ol8nfs::client::gentoo::install']
  -> Class['::ol8nfs::client::gentoo::configure']
  -> Class['::ol8nfs::client::gentoo::service']


}
