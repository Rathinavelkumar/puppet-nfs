class olnfs::server::ubuntu::install {

  package { 'olnfs-kernel-server':
    ensure => $::olnfs::server::package_ensure
  }

}
