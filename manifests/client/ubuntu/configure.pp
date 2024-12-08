class ol8nfs::client::ubuntu::configure {

  if $ol8nfs::client::ubuntu::ol8nfs_v4 {
      augeas {
        '/etc/default/ol8nfs-common':
          context => '/files/etc/default/ol8nfs-common',
          changes => [ 'set NEED_IDMAPD yes', ];
        '/etc/idmapd.conf':
          context => '/files/etc/idmapd.conf/General',
          lens    => 'Puppet.lns',
          incl    => '/etc/idmapd.conf',
          changes => ["set Domain ${ol8nfs::client::ubuntu::ol8nfs_v4_idmap_domain}"],
      }
  }

}
