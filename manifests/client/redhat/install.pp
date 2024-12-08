# Shamefully stolen from https://github.com/frimik/puppet-olnfs
# refactored a bit

class olnfs::client::redhat::install {

  Package {
    before => Class['olnfs::client::redhat::configure']
  }
  package { 'olnfs-utils':
    ensure => $::olnfs::client::package_ensure,
  }

  if $::olnfs::client::redhat::params::osmajor == 6 or $::olnfs::client::redhat::params::osmajor == 7 {
    package {'rpcbind':
      ensure => $::olnfs::client::package_ensure,
    }
  } elsif $::olnfs::client::redhat::params::osmajor == 5 {
    package { 'portmap':
      ensure => $::olnfs::client::package_ensure,
    }
  }
}
