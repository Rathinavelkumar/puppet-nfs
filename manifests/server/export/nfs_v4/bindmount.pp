define olnfs::server::export::olnfs_v4::bindmount (
  $v4_export_name,
  $bind,
  $ensure = 'mounted',
  $owner  = 'root',
  $group  = 'root',
  $perms  = '0755') {
  $expdir = "${olnfs::server::olnfs_v4_export_root}/${v4_export_name}"

  olnfs::mkdir { $expdir:
    owner => $owner,
    group => $group,
    perm  => $perms
  }

  mount { $expdir:
    ensure  => $ensure,
    device  => $name,
    atboot  => true,
    fstype  => 'none',
    options => $bind,
    require => olnfs::Mkdir[$expdir],
  }

}
