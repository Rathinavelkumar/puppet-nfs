# Shamefully stolen from https://github.com/frimik/puppet-ol8nfs
# refactored a bit

class ol8nfs::client::redhat::service {

# lint:ignore:selector_inside_resource  would not add much to readability

 # Ensure rpcbind is managed
  service { 'rpcbind':
    ensure => running,
    enable => true,
    require  => Package['ol8nfs-utils'],  # Ensure rpcbind starts after ol8nfs-utils
    provider => 'systemd',             # Use systemd provider (required for OL8)
  }

  service {'ol8nfslock':
    ensure    => running,
    name      => $::ol8nfs::client::redhat::params::osmajor ? {
      7       => 'rpc-statd',
      8       => 'rpc-statd',  # Use rpc-statd for OL8 instead of ol8nfs-lock
      default => 'ol8nfslock'
    },
    enable    => $::ol8nfs::client::redhat::params::osmajor ? {
      7       => undef,
      8       => true,         # OL8 typically enables the service by default
      default => true
    },
    hasstatus => true,
    require   => $::ol8nfs::client::redhat::params::osmajor ? {
      8 => Service['rpcbind'], # OL8 still requires rpcbind
      7 => Service['rpcbind'],
      6 => Service['rpcbind'],
      5 => [Package['portmap'], Package['ol8nfs-utils']]
    },
    provider => 'systemd', 
  }

  if $::ol8nfs::client::redhat::params::osmajor == 5 or $::ol8nfs::client::redhat::params::osmajor == 6 {
    service { 'netfs':
      enable  => true,
      require => $::ol8nfs::client::redhat::params::osmajor ? {
        6 => Service['ol8nfslock'],
        5 => [Service['portmap'], Service['ol8nfslock']],
      },
    }
  }

  if $::ol8nfs::client::redhat::params::osmajor == 6 or $::ol8nfs::client::redhat::params::osmajor == 7 {
    service {'rpcbind':
      ensure    => running,
      enable    => $::ol8nfs::client::redhat::params::osmajor ? {
        7       => undef,
        default => true
      },
      hasstatus => true,
      require   => [Package['rpcbind'], Package['ol8nfs-utils']],
    }
  } elsif $::ol8nfs::client::redhat::params::osmajor == 5 {
    service { 'portmap':
      ensure    => running,
      enable    => true,
      hasstatus => true,
      require   => [Package['portmap'], Package['ol8nfs-utils']],
    }
  }

# lint:endignore

}
