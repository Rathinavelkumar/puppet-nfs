class ol8nfs::server::redhat (
  $ol8nfs_v4              = false,
  $ol8nfs_v4_idmap_domain = undef,
  $mountd_port         = undef,
  $mountd_threads      = undef,
  $service_manage      = true,) {

  if !defined(Class['ol8nfs::client::redhat']) {
    class { 'ol8nfs::client::redhat':
      ol8nfs_v4              => $ol8nfs_v4,
      ol8nfs_v4_idmap_domain => $ol8nfs_v4_idmap_domain,
    }
  }

  if $::operatingsystemmajrelease and $::operatingsystemmajrelease =~ /^7/ {
    $service_name = 'ol8nfs-server'

  } else {
    $service_name = 'ol8nfs'

  }

  if ($mountd_port != undef) {
    file_line { 'rpc-mount-options-port':
      ensure  => present,
      path    => '/etc/sysconfig/ol8nfs',
      line    => "MOUNTD_PORT=${mountd_port}",
      match   => '^#?MOUNTD_PORT',
      require => Package['ol8nfs-utils'];
    }

    if $service_manage {
      File_line['rpc-mount-options-port'] ~> Service[$service_name]
    }
  }

  if ($mountd_threads != undef) {
    file_line { 'rpc-mount-options-threads':
      ensure  => present,
      path    => '/etc/sysconfig/ol8nfs',
      line    => "RPCol8nfsDCOUNT=${mountd_threads}",
      match   => '^#?RPCol8nfsDCOUNT=',
      require => Package['ol8nfs-utils'];
    }

    if $service_manage {
      File_line['rpc-mount-options-threads'] ~> Service[$service_name]
    }
  }

  include ol8nfs::server::redhat::install, ol8nfs::server::redhat::service

}
