class ol8nfs::server::ubuntu::install {

  package { 'ol8nfs-kernel-server':
    ensure => $::ol8nfs::server::package_ensure
  }

}
