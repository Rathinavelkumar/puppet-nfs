class nfs::server::redhat::service {

  if $nfs::server::redhat::service_manage {
    if $::operatingsystemmajrelease =~ /^7/ or $::operatingsystemmajrelease =~ /^8/ {
      $service_name = 'nfs-server'
    } else {
      $service_name = 'nfs'
    }

    if $nfs::server::redhat::nfs_v4 == true {
      service {$service_name:
        ensure     => running,
        enable     => true,
        hasrestart => true,
        hasstatus  => true,
        provider   => 'systemd',  # Ensure systemd is used for service management
        require    => Package['nfs-utils'],
        subscribe  => [ Concat['/etc/exports'], Augeas['/etc/idmapd.conf'] ],
      }
    } else {
      service {$service_name:
        ensure     => running,
        enable     => true,
        hasrestart => true,
        hasstatus  => true,
        provider   => 'systemd',  # Ensure systemd is used for service management
        require    => Package['nfs-utils'],
        subscribe  => Concat['/etc/exports'],
      }
    }
  }
}
