class ol8nfs::server::debian::install {

  package { 'ol8nfs-kernel-server':
    ensure => $::ol8nfs::server::package_ensure
  }

}
