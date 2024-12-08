class olnfs::server::debian::install {

  package { 'olnfs-kernel-server':
    ensure => $::olnfs::server::package_ensure
  }

}
