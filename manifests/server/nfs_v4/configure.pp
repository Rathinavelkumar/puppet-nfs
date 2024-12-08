class ol8nfs::server::ol8nfs_v4::configure {

  concat::fragment{
    'ol8nfs_exports_root':
      target  => '/etc/exports',
      content => "${ol8nfs::server::ol8nfs_v4_export_root} ${ol8nfs::server::ol8nfs_v4_export_root_clients}\n",
      order   => '02'
  }
  file {
    $ol8nfs::server::ol8nfs_v4_export_root:
      ensure => directory,
  }

  @@ol8nfs::client::mount::ol8nfs_v4::root {"shared server root by ${::clientcert}":
    ensure    => $ol8nfs::server::ol8nfs_v4_root_export_ensure,
    mount     => $ol8nfs::server::ol8nfs_v4_root_export_mount,
    remounts  => $ol8nfs::server::ol8nfs_v4_root_export_remounts,
    atboot    => $ol8nfs::server::ol8nfs_v4_root_export_atboot,
    options   => $ol8nfs::server::ol8nfs_v4_root_export_options,
    bindmount => $ol8nfs::server::ol8nfs_v4_root_export_bindmount,
    ol8nfstag    => $ol8nfs::server::ol8nfs_v4_root_export_tag,
    server    => $::clientcert,
  }
}
