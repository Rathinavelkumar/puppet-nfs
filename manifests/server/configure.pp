class ol8nfs::server::configure {

  concat {'/etc/exports':
    ensure  => present,
    require => Class["ol8nfs::server::${::ol8nfs::params::osfamily}"],
  }


  concat::fragment{
    'ol8nfs_exports_header':
      target  => '/etc/exports',
      content => "# This file is configured through the ol8nfs::server puppet module\n",
      order   => '01';
  }

  if $ol8nfs::server::ol8nfs_v4 == true {
    include ol8nfs::server::ol8nfs_v4::configure
  }
}
