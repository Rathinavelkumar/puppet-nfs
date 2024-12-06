# == Class: nfs::client
#
# Set up NFS client and mounts. NFSv3 and NFSv4 supported.
#
#
# === Parameters
#
# [package_ensure]
#   Allow to update or set to a specific version the nfs client packages
#   Default to installed.
#
# [nfs_v4]
#   NFSv4 support.
#   Disabled by default.
#
# [nfs_v4_mount_root]
#   Mount root, where we  mount shares, default /srv
#
# [nfs_v4_idmap_domain]
#  Domain setting for idmapd, must be the same across server
#  and clients.
#
#  Default is to use $::domain fact.
#
# === Examples
#
#
#  class { 'nfs::client':
#    nfs_v4              => true,
#    # Generally parameters below have sane defaults.
#    nfs_v4_mount_root  => "/srv",
#    nfs_v4_idmap_domain => $::domain,
#  }

class ol8nfs::client (
  $package_ensure      = $::nfs::params::client_package_ensure,
  $nfs_v4              = $::nfs::params::nfs_v4,
  $nfs_v4_mount_root   = $::nfs::params::nfs_v4_mount_root,
  $nfs_v4_idmap_domain = $::nfs::params::nfs_v4_idmap_domain,
  $mounts              = undef
) inherits ol8nfs::params {

  validate_bool($nfs_v4)

  # ensure dependencies for mount

  Class["::nfs::client::${::nfs::params::osfamily}::install"]
  -> Class["::nfs::client::${::nfs::params::osfamily}::configure"]
  -> Class["::nfs::client::${::nfs::params::osfamily}::service"]
  -> Class['::nfs::client']

  if !defined( Class["ol8nfs::client::${::nfs::params::osfamily}"]) {
    class{ "nfs::client::${::nfs::params::osfamily}":
      nfs_v4              => $nfs_v4,
      nfs_v4_idmap_domain => $nfs_v4_idmap_domain,
    }
  }

  if $mounts {
    create_resources(ol8nfs::client::mount, $mounts)
  }

}
