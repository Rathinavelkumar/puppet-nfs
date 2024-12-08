class olnfs::server::olnfs_v4::configure {

  concat::fragment{
    'olnfs_exports_root':
      target  => '/etc/exports',
      content => "${olnfs::server::olnfs_v4_export_root} ${olnfs::server::olnfs_v4_export_root_clients}\n",
      order   => '02'
  }
  file {
    $olnfs::server::olnfs_v4_export_root:
      ensure => directory,
  }

  @@olnfs::client::mount::olnfs_v4::root {"shared server root by ${::clientcert}":
    ensure    => $olnfs::server::olnfs_v4_root_export_ensure,
    mount     => $olnfs::server::olnfs_v4_root_export_mount,
    remounts  => $olnfs::server::olnfs_v4_root_export_remounts,
    atboot    => $olnfs::server::olnfs_v4_root_export_atboot,
    options   => $olnfs::server::olnfs_v4_root_export_options,
    bindmount => $olnfs::server::olnfs_v4_root_export_bindmount,
    olnfstag    => $olnfs::server::olnfs_v4_root_export_tag,
    server    => $::clientcert,
  }
}
