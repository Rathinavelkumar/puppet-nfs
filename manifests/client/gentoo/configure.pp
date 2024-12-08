class ol8nfs::client::gentoo::configure {
  Augeas{
    require => Class['ol8nfs::client::gentoo::install']
  }

  if $ol8nfs::client::gentoo::ol8nfs_v4 {
      augeas {
        '/etc/conf.d/ol8nfs':
          context => '/files/etc/conf.d/ol8nfs',
          changes => [ 'set ol8nfs_NEEDED_SERVICES rpc.idmapd' ];
        '/etc/idmapd.conf':
          context => '/files/etc/idmapd.conf/General',
          lens    => 'Puppet.lns',
          incl    => '/etc/idmapd.conf',
          changes => ["set Domain ${ol8nfs::client::gentoo::ol8nfs_v4_idmap_domain}"];
      }
  }

}
