# == Class: nfs::server
#
# Set up NFS server and exports. NFSv3 and NFSv4 supported.
#
#
# === Parameters
#
# [package_ensure]
#   Allow to update or set to a specific version the nfs server packages
#   Default to installed.
#
# [nfs_v4]
#   NFSv4 support. Will set up automatic bind mounts to export root.
#   Disabled by default.
#
# [nfs_v4_export_root]
#   Export root, where we bind mount shares, default /export
#
# [nfs_v4_idmap_domain]
#   Domain setting for idmapd, must be the same across server
#   and clients.
#   Default is to use $domain fact.
#
# [service_manage]
#   Should this class manage the services behind nfs? Set this to false
#   if you are managing the service in another way (e.g. pacemaker).
#
# === Examples
#
#
#  class { nfs::server:
#    nfs_v4                      => true,
#     nfs_v4_export_root_clients => "*.${::domain}(ro,fsid=root,insecure,no_subtree_check,async,root_squash)",
#    # Generally parameters below have sane defaults.
#    nfs_v4_export_root  => "/export",
#    nfs_v4_idmap_domain => $::domain,
#  }

class ol8nfs::server (
  $package_ensure               = $::nfs::params::server_package_ensure,
  $nfs_v4                       = $nfs::params::nfs_v4,
  $nfs_v4_export_root           = $nfs::params::nfs_v4_export_root,
  $nfs_v4_export_root_clients   = $nfs::params::nfs_v4_export_root_clients,
  $nfs_v4_idmap_domain          = $nfs::params::nfs_v4_idmap_domain,
  #
  $service_manage               = true,
  #
  $nfs_v4_root_export_ensure    = 'mounted',
  $nfs_v4_root_export_mount     = undef,
  $nfs_v4_root_export_remounts  = false,
  $nfs_v4_root_export_atboot    = false,
  $nfs_v4_root_export_options   = '_netdev',
  $nfs_v4_root_export_bindmount = undef,
  $nfs_v4_root_export_tag       = undef,
  #
  $mountd_port                  = undef,
  $mountd_threads               = undef,
  #
  $exports                      = undef,
) inherits ol8nfs::params {

  validate_bool($nfs_v4)
  validate_bool($service_manage)
  validate_bool($nfs_v4_root_export_remounts)
  validate_bool($nfs_v4_root_export_atboot)

  class { "ol8nfs::server::${::ol8nfs::params::osfamily}":
    nfs_v4              => $nfs_v4,
    nfs_v4_idmap_domain => $nfs_v4_idmap_domain,
    mountd_port         => $mountd_port,
    mountd_threads      => $mountd_threads,
    service_manage      => $service_manage,
  }

  include ol8nfs::server::configure

  if $exports {
    create_resources(ol8nfs::server::export, $exports)
  }

}
