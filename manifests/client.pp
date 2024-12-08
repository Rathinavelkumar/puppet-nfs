# == Class: ol8nfs::client
#
# Set up ol8nfs client and mounts. ol8nfsv3 and ol8nfsv4 supported.
#
#
# === Parameters
#
# [package_ensure]
#   Allow to update or set to a specific version the ol8nfs client packages
#   Default to installed.
#
# [ol8nfs_v4]
#   ol8nfsv4 support.
#   Disabled by default.
#
# [ol8nfs_v4_mount_root]
#   Mount root, where we  mount shares, default /srv
#
# [ol8nfs_v4_idmap_domain]
#  Domain setting for idmapd, must be the same across server
#  and clients.
#
#  Default is to use $::domain fact.
#
# === Examples
#
#
#  class { 'ol8nfs::client':
#    ol8nfs_v4              => true,
#    # Generally parameters below have sane defaults.
#    ol8nfs_v4_mount_root  => "/srv",
#    ol8nfs_v4_idmap_domain => $::domain,
#  }

class ol8nfs::client (
  $package_ensure      = $::ol8nfs::params::client_package_ensure,
  $ol8nfs_v4              = $::ol8nfs::params::ol8nfs_v4,
  $ol8nfs_v4_mount_root   = $::ol8nfs::params::ol8nfs_v4_mount_root,
  $ol8nfs_v4_idmap_domain = $::ol8nfs::params::ol8nfs_v4_idmap_domain,
  $mounts              = undef
) inherits ol8nfs::params {

  validate_bool($ol8nfs_v4)

  # ensure dependencies for mount

  Class["::ol8nfs::client::${::ol8nfs::params::osfamily}::install"]
  -> Class["::ol8nfs::client::${::ol8nfs::params::osfamily}::configure"]
  -> Class["::ol8nfs::client::${::ol8nfs::params::osfamily}::service"]
  -> Class['::ol8nfs::client']

  if !defined( Class["ol8nfs::client::${::ol8nfs::params::osfamily}"]) {
    class{ "ol8nfs::client::${::ol8nfs::params::osfamily}":
      ol8nfs_v4              => $ol8nfs_v4,
      ol8nfs_v4_idmap_domain => $ol8nfs_v4_idmap_domain,
    }
  }

  if $mounts {
    create_resources(ol8nfs::client::mount, $mounts)
  }

}
