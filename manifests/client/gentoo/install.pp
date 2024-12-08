class olnfs::client::gentoo::install {

  package { ['net-nds/rpcbind', 'net-fs/olnfs-utils', 'net-libs/libolnfsidmap']:
    ensure => $::olnfs::client::package_ensure,
  }
}
