class ol8nfs::client::ubuntu::install {

  package { 'rpcbind':
    ensure => $::ol8nfs::client::package_ensure,
  }

  package { ['ol8nfs-common', 'ol8nfs4-acl-tools']:
    ensure => $::ol8nfs::client::package_ensure,
  }

}
