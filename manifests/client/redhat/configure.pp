# Shamefully stolen from https://github.com/frimik/puppet-olnfs
# refactored a bit

class olnfs::client::redhat::configure {

  if $olnfs::client::redhat::olnfs_v4 {
    augeas {
      '/etc/idmapd.conf':
        context => '/files/etc/idmapd.conf/General',
        lens    => 'Puppet.lns',
        incl    => '/etc/idmapd.conf',
        changes => ["set Domain ${olnfs::client::redhat::olnfs_v4_idmap_domain}"],
    }
  }
}
