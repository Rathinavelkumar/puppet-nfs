class olnfs::server::redhat::service {

  if $olnfs::server::redhat::service_manage {
    if $::operatingsystemmajrelease =~ /^7/ or $::operatingsystemmajrelease =~ /^8/ {
      $service_name = 'olnfs-server'
    } else {
      $service_name = 'olnfs'
    }

    if $olnfs::server::redhat::olnfs_v4 == true {
      service {$service_name:
        ensure     => running,
        enable     => true,
        hasrestart => true,
        hasstatus  => true,
        provider   => 'systemd',  # Ensure systemd is used for service management
        require    => Package['olnfs-utils'],
        subscribe  => [ Concat['/etc/exports'], Augeas['/etc/idmapd.conf'] ],
      }
    } else {
      service {$service_name:
        ensure     => running,
        enable     => true,
        hasrestart => true,
        hasstatus  => true,
        provider   => 'systemd',  # Ensure systemd is used for service management
        require    => Package['olnfs-utils'],
        subscribe  => Concat['/etc/exports'],
      }
    }
  }
}
