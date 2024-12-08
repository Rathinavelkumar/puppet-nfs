class olnfs::client::debian::service {

  service { 'rpcbind':
    ensure    => running,
    enable    => true,
    hasstatus => false,
  }

  if $olnfs::client::debian::olnfs_v4 {
    service { 'idmapd':
      ensure    => running,
      enable    => true,
      name      => 'olnfs-common',
      subscribe => Augeas['/etc/idmapd.conf', '/etc/default/olnfs-common'],
    }
  }
}
