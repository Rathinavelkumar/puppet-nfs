class ol8nfs::client::debian::service {

  service { 'rpcbind':
    ensure    => running,
    enable    => true,
    hasstatus => false,
  }

  if $ol8nfs::client::debian::ol8nfs_v4 {
    service { 'idmapd':
      ensure    => running,
      enable    => true,
      name      => 'ol8nfs-common',
      subscribe => Augeas['/etc/idmapd.conf', '/etc/default/ol8nfs-common'],
    }
  }
}
