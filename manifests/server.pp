# == Class: olnfs::server
#
# Set up olnfs server and exports. olnfsv3 and olnfsv4 supported.
#
#
# === Parameters
#
# [package_ensure]
#   Allow to update or set to a specific version the olnfs server packages
#   Default to installed.
#
# [olnfs_v4]
#   olnfsv4 support. Will set up automatic bind mounts to export root.
#   Disabled by default.
#
# [olnfs_v4_export_root]
#   Export root, where we bind mount shares, default /export
#
# [olnfs_v4_idmap_domain]
#   Domain setting for idmapd, must be the same across server
#   and clients.
#   Default is to use $domain fact.
#
# [service_manage]
#   Should this class manage the services behind olnfs? Set this to false
#   if you are managing the service in another way (e.g. pacemaker).
#
# === Examples
#
#
#  class { olnfs::server:
#    olnfs_v4                      => true,
#     olnfs_v4_export_root_clients => "*.${::domain}(ro,fsid=root,insecure,no_subtree_check,async,root_squash)",
#    # Generally parameters below have sane defaults.
#    olnfs_v4_export_root  => "/export",
#    olnfs_v4_idmap_domain => $::domain,
#  }

class olnfs::server (
  $package_ensure               = $::olnfs::params::server_package_ensure,
  $olnfs_v4                       = $olnfs::params::olnfs_v4,
  $olnfs_v4_export_root           = $olnfs::params::olnfs_v4_export_root,
  $olnfs_v4_export_root_clients   = $olnfs::params::olnfs_v4_export_root_clients,
  $olnfs_v4_idmap_domain          = $olnfs::params::olnfs_v4_idmap_domain,
  #
  $service_manage               = true,
  #
  $olnfs_v4_root_export_ensure    = 'mounted',
  $olnfs_v4_root_export_mount     = undef,
  $olnfs_v4_root_export_remounts  = false,
  $olnfs_v4_root_export_atboot    = false,
  $olnfs_v4_root_export_options   = '_netdev',
  $olnfs_v4_root_export_bindmount = undef,
  $olnfs_v4_root_export_tag       = undef,
  #
  $mountd_port                  = undef,
  $mountd_threads               = undef,
  #
  $exports                      = undef,
) inherits olnfs::params {

  validate_bool($olnfs_v4)
  validate_bool($service_manage)
  validate_bool($olnfs_v4_root_export_remounts)
  validate_bool($olnfs_v4_root_export_atboot)

  class { "olnfs::server::${::olnfs::params::osfamily}":
    olnfs_v4              => $olnfs_v4,
    olnfs_v4_idmap_domain => $olnfs_v4_idmap_domain,
    mountd_port         => $mountd_port,
    mountd_threads      => $mountd_threads,
    service_manage      => $service_manage,
  }

  include olnfs::server::configure

  if $exports {
    create_resources(olnfs::server::export, $exports)
  }

}
