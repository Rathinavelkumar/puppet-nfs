class olnfs::client::gentoo::service {

  Service{
    require => Class['olnfs::client::gentoo::configure']
  }

}
