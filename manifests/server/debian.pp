# Debian specifix stuff
class olnfs::server::debian(
  $olnfs_v4              = false,
  $olnfs_v4_idmap_domain = undef,
  $mountd_port         = undef,
  $mountd_threads      = 8,
  $service_manage      = true,
) {

  if !defined(Class['olnfs::client::debian']) {
    class{ 'olnfs::client::debian':
      olnfs_v4              => $olnfs_v4,
      olnfs_v4_idmap_domain => $olnfs_v4_idmap_domain,
    }
  }

  if ($mountd_port != undef){
    file_line { 'rpc-mount-options':
      ensure  => present,
      path    => '/etc/default/olnfs-kernel-server',
      line    => "RPCMOUNTDOPTS=\"--manage-gids --port ${mountd_port} --num-threads ${mountd_threads}\"",
      match   => '^#?RPCMOUNTDOPTS',
      require => Package['olnfs-kernel-server'];
    }

    if $service_manage {
      File_line['rpc-mount-options'] ~> Service['olnfs-kernel-server']
    }
  }

  include olnfs::server::debian::install, olnfs::server::debian::service
}
