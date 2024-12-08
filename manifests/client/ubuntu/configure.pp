class olnfs::client::ubuntu::configure {

  if $olnfs::client::ubuntu::olnfs_v4 {
      augeas {
        '/etc/default/olnfs-common':
          context => '/files/etc/default/olnfs-common',
          changes => [ 'set NEED_IDMAPD yes', ];
        '/etc/idmapd.conf':
          context => '/files/etc/idmapd.conf/General',
          lens    => 'Puppet.lns',
          incl    => '/etc/idmapd.conf',
          changes => ["set Domain ${olnfs::client::ubuntu::olnfs_v4_idmap_domain}"],
      }
  }

}
