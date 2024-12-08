class olnfs::server::configure {

  concat {'/etc/exports':
    ensure  => present,
    require => Class["olnfs::server::${::olnfs::params::osfamily}"],
  }


  concat::fragment{
    'olnfs_exports_header':
      target  => '/etc/exports',
      content => "# This file is configured through the olnfs::server puppet module\n",
      order   => '01';
  }

  if $olnfs::server::olnfs_v4 == true {
    include olnfs::server::olnfs_v4::configure
  }
}
