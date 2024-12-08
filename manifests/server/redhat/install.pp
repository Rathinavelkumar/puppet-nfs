class olnfs::server::redhat::install {

  package { 'nfs4-acl-tools':
    ensure => $::olnfs::server::package_ensure,
  }

}
