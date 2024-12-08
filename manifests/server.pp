# == Class: ol8nfs::server
#
# Set up ol8nfs server and exports. ol8nfsv3 and ol8nfsv4 supported.
#
#
# === Parameters
#
# [package_ensure]
#   Allow to update or set to a specific version the ol8nfs server packages
#   Default to installed.
#
# [ol8nfs_v4]
#   ol8nfsv4 support. Will set up automatic bind mounts to export root.
#   Disabled by default.
#
# [ol8nfs_v4_export_root]
#   Export root, where we bind mount shares, default /export
#
# [ol8nfs_v4_idmap_domain]
#   Domain setting for idmapd, must be the same across server
#   and clients.
#   Default is to use $domain fact.
#
# [service_manage]
#   Should this class manage the services behind ol8nfs? Set this to false
#   if you are managing the service in another way (e.g. pacemaker).
#
# === Examples
#
#
#  class { ol8nfs::server:
#    ol8nfs_v4                      => true,
#     ol8nfs_v4_export_root_clients => "*.${::domain}(ro,fsid=root,insecure,no_subtree_check,async,root_squash)",
#    # Generally parameters below have sane defaults.
#    ol8nfs_v4_export_root  => "/export",
#    ol8nfs_v4_idmap_domain => $::domain,
#  }

class ol8nfs::server (
  $package_ensure               = $::ol8nfs::params::server_package_ensure,
  $ol8nfs_v4                       = $ol8nfs::params::ol8nfs_v4,
  $ol8nfs_v4_export_root           = $ol8nfs::params::ol8nfs_v4_export_root,
  $ol8nfs_v4_export_root_clients   = $ol8nfs::params::ol8nfs_v4_export_root_clients,
  $ol8nfs_v4_idmap_domain          = $ol8nfs::params::ol8nfs_v4_idmap_domain,
  #
  $service_manage               = true,
  #
  $ol8nfs_v4_root_export_ensure    = 'mounted',
  $ol8nfs_v4_root_export_mount     = undef,
  $ol8nfs_v4_root_export_remounts  = false,
  $ol8nfs_v4_root_export_atboot    = false,
  $ol8nfs_v4_root_export_options   = '_netdev',
  $ol8nfs_v4_root_export_bindmount = undef,
  $ol8nfs_v4_root_export_tag       = undef,
  #
  $mountd_port                  = undef,
  $mountd_threads               = undef,
  #
  $exports                      = undef,
) inherits ol8nfs::params {

  validate_bool($ol8nfs_v4)
  validate_bool($service_manage)
  validate_bool($ol8nfs_v4_root_export_remounts)
  validate_bool($ol8nfs_v4_root_export_atboot)

  class { "ol8nfs::server::${::ol8nfs::params::osfamily}":
    ol8nfs_v4              => $ol8nfs_v4,
    ol8nfs_v4_idmap_domain => $ol8nfs_v4_idmap_domain,
    mountd_port         => $mountd_port,
    mountd_threads      => $mountd_threads,
    service_manage      => $service_manage,
  }

  include ol8nfs::server::configure

  if $exports {
    create_resources(ol8nfs::server::export, $exports)
  }

}
