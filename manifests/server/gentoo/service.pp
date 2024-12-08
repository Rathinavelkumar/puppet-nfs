class ol8nfs::server::gentoo::service {

  if $ol8nfs::server::gentoo::service_manage {
    if $::ol8nfs::client::gentoo::ol8nfs_v4 == true {
      service { 'ol8nfs':
        ensure     => running,
        enable     => true,
        hasrestart => true,
        hasstatus  => true,
        require    => Package['net-fs/ol8nfs-utils'],
        subscribe  => [
          Concat['/etc/exports'],
          Augeas['/etc/idmapd.conf', '/etc/conf.d/ol8nfs']
          ],
      }
    } else {
      service { 'ol8nfs':
        ensure     => running,
        enable     => true,
        hasrestart => true,
        hasstatus  => true,
        require    => Package['net-fs/ol8nfs-utils'],
        subscribe  => Concat['/etc/exports'],
      }
    }
  }
}
