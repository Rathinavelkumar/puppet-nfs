define ol8nfs::client::mount::ol8nfs_v4::bindmount (
  $mount_name,
  $ensure = 'present',
) {

  ol8nfs::mkdir{ $mount_name: }

  mount {
    $mount_name:
      ensure  => $ensure,
      device  => $name,
      atboot  => true,
      fstype  => 'none',
      options => 'bind',
      require => ol8nfs::Mkdir[$mount_name],
  }

}
