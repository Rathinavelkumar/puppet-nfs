# Shamefully stolen from https://github.com/frimik/puppet-nfs
# refactored a bit

class nfs::client::redhat::service {

# lint:ignore:selector_inside_resource  would not add much to readability

 # Ensure rpcbind is managed
  service { 'rpcbind':
    ensure => running,
    enable => true,
    require  => Package['nfs-utils'],  # Ensure rpcbind starts after nfs-utils
    provider => 'systemd',             # Use systemd provider (required for OL8)
  }

  service {'nfslock':
    ensure    => running,
    name      => $::nfs::client::redhat::params::osmajor ? {
      7       => 'rpc-statd',
      8       => 'rpc-statd',  # Use rpc-statd for OL8 instead of nfs-lock
      default => 'nfslock'
    },
    enable    => $::nfs::client::redhat::params::osmajor ? {
      7       => undef,
      8       => true,         # OL8 typically enables the service by default
      default => true
    },
    hasstatus => true,
    require   => $::nfs::client::redhat::params::osmajor ? {
      8 => Service['rpcbind'], # OL8 still requires rpcbind
      7 => Service['rpcbind'],
      6 => Service['rpcbind'],
      5 => [Package['portmap'], Package['nfs-utils']]
    },
    provider => 'systemd', 
  }

  if $::nfs::client::redhat::params::osmajor == 5 or $::nfs::client::redhat::params::osmajor == 6 {
    service { 'netfs':
      enable  => true,
      require => $::nfs::client::redhat::params::osmajor ? {
        6 => Service['nfslock'],
        5 => [Service['portmap'], Service['nfslock']],
      },
    }
  }

  if $::nfs::client::redhat::params::osmajor == 6 or $::nfs::client::redhat::params::osmajor == 7 {
    service {'rpcbind':
      ensure    => running,
      enable    => $::nfs::client::redhat::params::osmajor ? {
        7       => undef,
        default => true
      },
      hasstatus => true,
      require   => [Package['rpcbind'], Package['nfs-utils']],
    }
  } elsif $::nfs::client::redhat::params::osmajor == 5 {
    service { 'portmap':
      ensure    => running,
      enable    => true,
      hasstatus => true,
      require   => [Package['portmap'], Package['nfs-utils']],
    }
  }

# lint:endignore

}
