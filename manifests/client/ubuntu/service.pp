class ol8nfs::client::ubuntu::service {

  service { 'rpcbind':
    ensure    => running,
    enable    => true,
    hasstatus => false,
  }

  if $ol8nfs::client::ubuntu::ol8nfs_v4 {
    if versioncmp($::lsbdistrelease, '16.04') < 0 {
      service { 'idmapd':
        ensure    => running,
        enable    => true,
        subscribe => Augeas['/etc/idmapd.conf', '/etc/default/ol8nfs-common'],
      }
    }
  } else {
    service { 'idmapd':
      ensure => stopped,
      enable => false,
    }
  }
}
