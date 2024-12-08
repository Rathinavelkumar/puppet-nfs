class olnfs::client::gentoo::configure {
  Augeas{
    require => Class['olnfs::client::gentoo::install']
  }

  if $olnfs::client::gentoo::olnfs_v4 {
      augeas {
        '/etc/conf.d/olnfs':
          context => '/files/etc/conf.d/olnfs',
          changes => [ 'set olnfs_NEEDED_SERVICES rpc.idmapd' ];
        '/etc/idmapd.conf':
          context => '/files/etc/idmapd.conf/General',
          lens    => 'Puppet.lns',
          incl    => '/etc/idmapd.conf',
          changes => ["set Domain ${olnfs::client::gentoo::olnfs_v4_idmap_domain}"];
      }
  }

}
