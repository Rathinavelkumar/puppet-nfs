# Shamefully stolen from https://github.com/frimik/puppet-olnfs
# refactored a bit

class olnfs::client::redhat::service {

  # Ensure rpcbind is managed
  service { 'rpcbind':
    ensure => running,
    enable => true,
    require  => Package['olnfs-utils'],  # Ensure rpcbind starts after olnfs-utils
    provider => 'systemd',             # Use systemd provider (required for OL8)
  }

  # lint:ignore:selector_inside_resource  would not add much to readability

  service {'olnfslock':
    ensure    => running,
    name      => $::olnfs::client::redhat::params::osmajor ? {
      7       => 'rpc-statd',
      8       => 'rpc-statd',  # Use rpc-statd for OL8 instead of olnfs-lock
      default => 'olnfslock'
    },
    enable    => $::olnfs::client::redhat::params::osmajor ? {
      7       => undef,
      8       => true,         # OL8 typically enables the service by default
      default => true
    },
    hasstatus => true,
    require   => $::olnfs::client::redhat::params::osmajor ? {
      8 => Service['rpcbind'], # OL8 still requires rpcbind
      7 => Service['rpcbind'],
      6 => Service['rpcbind'],
      5 => [Package['portmap'], Package['olnfs-utils']]
    },
    provider => 'systemd',       # Use systemd for OL8, as it's the default for OL8 and other systemd systems
  }

  if $::olnfs::client::redhat::params::osmajor == 5 or $::olnfs::client::redhat::params::osmajor == 6 {
    service { 'netfs':
      enable  => true,
      require => $::olnfs::client::redhat::params::osmajor ? {
        6 => Service['olnfslock'],
        5 => [Service['portmap'], Service['olnfslock']],
      },
    }
  }

  if $::olnfs::client::redhat::params::osmajor == 6 or $::olnfs::client::redhat::params::osmajor == 7 {
    service {'rpcbind':
      ensure    => running,
      enable    => $::olnfs::client::redhat::params::osmajor ? {
        7       => undef,
        default => true
      },
      hasstatus => true,
      require   => [Package['rpcbind'], Package['olnfs-utils']],
    }
  } elsif $::olnfs::client::redhat::params::osmajor == 5 {
    service { 'portmap':
      ensure    => running,
      enable    => true,
      hasstatus => true,
      require   => [Package['portmap'], Package['olnfs-utils']],
    }
  }

  # lint:endignore

}
