class olnfs::server::ubuntu::service {

  if $olnfs::server::ubuntu::service_manage {
    if $olnfs::server::ubuntu::olnfs_v4 == true {
      service {'olnfs-kernel-server':
        ensure     => running,
        enable     => true,
        hasrestart => true,
        hasstatus  => true,
        require    => Package['olnfs-kernel-server'],
        subscribe  => [ Concat['/etc/exports'], Augeas['/etc/idmapd.conf','/etc/default/olnfs-common'] ],
      }
    } else {
      service {'olnfs-kernel-server':
        ensure     => running,
        enable     => true,
        hasrestart => true,
        hasstatus  => true,
        require    => Package['olnfs-kernel-server'],
        subscribe  => Concat['/etc/exports'],
      }
    }

    Package['rpcbind'] -> Service['rpcbind']
  }
}
