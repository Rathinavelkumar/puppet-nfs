class ol8nfs::server::redhat::install {

  package { 'ol8nfs4-acl-tools':
    ensure => $::ol8nfs::server::package_ensure,
  }

}
