class olnfs::client::ubuntu::service {

  service { 'rpcbind':
    ensure    => running,
    enable    => true,
    hasstatus => false,
  }

  if $olnfs::client::ubuntu::olnfs_v4 {
    if versioncmp($::lsbdistrelease, '16.04') < 0 {
      service { 'idmapd':
        ensure    => running,
        enable    => true,
        subscribe => Augeas['/etc/idmapd.conf', '/etc/default/olnfs-common'],
      }
    }
  } else {
    service { 'idmapd':
      ensure => stopped,
      enable => false,
    }
  }
}
