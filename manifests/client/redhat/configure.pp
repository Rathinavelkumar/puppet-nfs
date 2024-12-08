# Shamefully stolen from https://github.com/frimik/puppet-ol8nfs
# refactored a bit

class ol8nfs::client::redhat::configure {

  if $ol8nfs::client::redhat::ol8nfs_v4 {
    augeas {
      '/etc/idmapd.conf':
        context => '/files/etc/idmapd.conf/General',
        lens    => 'Puppet.lns',
        incl    => '/etc/idmapd.conf',
        changes => ["set Domain ${ol8nfs::client::redhat::ol8nfs_v4_idmap_domain}"],
    }
  }
}
