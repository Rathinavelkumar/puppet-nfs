# Shamefully stolen from https://github.com/frimik/puppet-ol8nfs
# refactored a bit

class ol8nfs::client::redhat::install {

  Package {
    before => Class['ol8nfs::client::redhat::configure']
  }
  package { 'ol8nfs-utils':
    ensure => $::ol8nfs::client::package_ensure,
  }

  if $::ol8nfs::client::redhat::params::osmajor == 6 or $::ol8nfs::client::redhat::params::osmajor == 7 {
    package {'rpcbind':
      ensure => $::ol8nfs::client::package_ensure,
    }
  } elsif $::ol8nfs::client::redhat::params::osmajor == 5 {
    package { 'portmap':
      ensure => $::ol8nfs::client::package_ensure,
    }
  }
}
