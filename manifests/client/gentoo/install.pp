class ol8nfs::client::gentoo::install {

  package { ['net-nds/rpcbind', 'net-fs/ol8nfs-utils', 'net-libs/libol8nfsidmap']:
    ensure => $::ol8nfs::client::package_ensure,
  }
}
