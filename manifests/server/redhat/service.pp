class ol8nfs::server::redhat::service {

  if $ol8nfs::server::redhat::service_manage {
    if $::operatingsystemmajrelease =~ /^7/ or $::operatingsystemmajrelease =~ /^8/ {
      $service_name = 'ol8nfs-server'
    } else {
      $service_name = 'ol8nfs'
    }

    if $ol8nfs::server::redhat::ol8nfs_v4 == true {
      service {$service_name:
        ensure     => running,
        enable     => true,
        hasrestart => true,
        hasstatus  => true,
        provider   => 'systemd',  # Ensure systemd is used for service management
        require    => Package['ol8nfs-utils'],
        subscribe  => [ Concat['/etc/exports'], Augeas['/etc/idmapd.conf'] ],
      }
    } else {
      service {$service_name:
        ensure     => running,
        enable     => true,
        hasrestart => true,
        hasstatus  => true,
        provider   => 'systemd',  # Ensure systemd is used for service management
        require    => Package['ol8nfs-utils'],
        subscribe  => Concat['/etc/exports'],
      }
    }
  }
}
