class olnfs::server::redhat (
  $olnfs_v4              = false,
  $olnfs_v4_idmap_domain = undef,
  $mountd_port         = undef,
  $mountd_threads      = undef,
  $service_manage      = true,) {

  if !defined(Class['olnfs::client::redhat']) {
    class { 'olnfs::client::redhat':
      olnfs_v4              => $olnfs_v4,
      olnfs_v4_idmap_domain => $olnfs_v4_idmap_domain,
    }
  }

  if $::operatingsystemmajrelease and $::operatingsystemmajrelease =~ /^7/ {
    $service_name = 'olnfs-server'

  } else {
    $service_name = 'olnfs'

  }

  if ($mountd_port != undef) {
    file_line { 'rpc-mount-options-port':
      ensure  => present,
      path    => '/etc/sysconfig/olnfs',
      line    => "MOUNTD_PORT=${mountd_port}",
      match   => '^#?MOUNTD_PORT',
      require => Package['olnfs-utils'];
    }

    if $service_manage {
      File_line['rpc-mount-options-port'] ~> Service[$service_name]
    }
  }

  if ($mountd_threads != undef) {
    file_line { 'rpc-mount-options-threads':
      ensure  => present,
      path    => '/etc/sysconfig/olnfs',
      line    => "RPColnfsDCOUNT=${mountd_threads}",
      match   => '^#?RPColnfsDCOUNT=',
      require => Package['olnfs-utils'];
    }

    if $service_manage {
      File_line['rpc-mount-options-threads'] ~> Service[$service_name]
    }
  }

  include olnfs::server::redhat::install, olnfs::server::redhat::service

}
