class olnfs::params (
  $client_package_ensure      = 'installed',
  $server_package_ensure      = 'installed',
  $olnfs_v4                     = false,
  $olnfs_v4_export_root         = '/export',
  $olnfs_v4_export_root_clients = "*.${::domain}(ro,fsid=root,insecure,no_subtree_check,async,root_squash)",
  $olnfs_v4_mount_root          = '/srv',
  $olnfs_v4_idmap_domain        = $::domain
) {

  # Somehow the ::osfamily fact doesnt exist on some systems

  case $::operatingsystem {
    'CentOS', 'RedHat', 'scientific', 'Fedora', 'SLC', 'OracleLinux', 'Amazon' : { $osfamily = 'redhat' }
    'Debian'  : { $osfamily = 'debian' }
    'Ubuntu'  : { $osfamily = 'ubuntu' }
    'darwin'  : { $osfamily = 'darwin' }
    'gentoo'  : { $osfamily = 'gentoo' }
    default   : { fail("OS: ${::operatingsystem} not supported") }
  }
}
