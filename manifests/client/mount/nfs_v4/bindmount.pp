define olnfs::client::mount::olnfs_v4::bindmount (
  $mount_name,
  $ensure = 'present',
) {

  olnfs::mkdir{ $mount_name: }

  mount {
    $mount_name:
      ensure  => $ensure,
      device  => $name,
      atboot  => true,
      fstype  => 'none',
      options => 'bind',
      require => olnfs::Mkdir[$mount_name],
  }

}
