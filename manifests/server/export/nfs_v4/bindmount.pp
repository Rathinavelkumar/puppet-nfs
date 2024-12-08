define ol8nfs::server::export::ol8nfs_v4::bindmount (
  $v4_export_name,
  $bind,
  $ensure = 'mounted',
  $owner  = 'root',
  $group  = 'root',
  $perms  = '0755') {
  $expdir = "${ol8nfs::server::ol8nfs_v4_export_root}/${v4_export_name}"

  ol8nfs::mkdir { $expdir:
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
    require => ol8nfs::Mkdir[$expdir],
  }

}
