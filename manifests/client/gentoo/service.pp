class ol8nfs::client::gentoo::service {

  Service{
    require => Class['ol8nfs::client::gentoo::configure']
  }

}
