class olnfs::client::debian::install {

  package { 'rpcbind':
    ensure => $::olnfs::client::package_ensure,
  }

  package { ['olnfs-common', 'olnfs4-acl-tools']:
    ensure => $::olnfs::client::package_ensure,
  }

}
