# Debian specifix stuff
class ol8nfs::server::debian(
  $ol8nfs_v4              = false,
  $ol8nfs_v4_idmap_domain = undef,
  $mountd_port         = undef,
  $mountd_threads      = 8,
  $service_manage      = true,
) {

  if !defined(Class['ol8nfs::client::debian']) {
    class{ 'ol8nfs::client::debian':
      ol8nfs_v4              => $ol8nfs_v4,
      ol8nfs_v4_idmap_domain => $ol8nfs_v4_idmap_domain,
    }
  }

  if ($mountd_port != undef){
    file_line { 'rpc-mount-options':
      ensure  => present,
      path    => '/etc/default/ol8nfs-kernel-server',
      line    => "RPCMOUNTDOPTS=\"--manage-gids --port ${mountd_port} --num-threads ${mountd_threads}\"",
      match   => '^#?RPCMOUNTDOPTS',
      require => Package['ol8nfs-kernel-server'];
    }

    if $service_manage {
      File_line['rpc-mount-options'] ~> Service['ol8nfs-kernel-server']
    }
  }

  include ol8nfs::server::debian::install, ol8nfs::server::debian::service
}
