class olnfs::server::gentoo::service {

  if $olnfs::server::gentoo::service_manage {
    if $::olnfs::client::gentoo::olnfs_v4 == true {
      service { 'olnfs':
        ensure     => running,
        enable     => true,
        hasrestart => true,
        hasstatus  => true,
        require    => Package['net-fs/olnfs-utils'],
        subscribe  => [
          Concat['/etc/exports'],
          Augeas['/etc/idmapd.conf', '/etc/conf.d/olnfs']
          ],
      }
    } else {
      service { 'olnfs':
        ensure     => running,
        enable     => true,
        hasrestart => true,
        hasstatus  => true,
        require    => Package['net-fs/olnfs-utils'],
        subscribe  => Concat['/etc/exports'],
      }
    }
  }
}
