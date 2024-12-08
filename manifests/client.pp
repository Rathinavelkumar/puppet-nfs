# == Class: olnfs::client
#
# Set up olnfs client and mounts. olnfsv3 and olnfsv4 supported.
#
#
# === Parameters
#
# [package_ensure]
#   Allow to update or set to a specific version the olnfs client packages
#   Default to installed.
#
# [olnfs_v4]
#   olnfsv4 support.
#   Disabled by default.
#
# [olnfs_v4_mount_root]
#   Mount root, where we  mount shares, default /srv
#
# [olnfs_v4_idmap_domain]
#  Domain setting for idmapd, must be the same across server
#  and clients.
#
#  Default is to use $::domain fact.
#
# === Examples
#
#
#  class { 'olnfs::client':
#    olnfs_v4              => true,
#    # Generally parameters below have sane defaults.
#    olnfs_v4_mount_root  => "/srv",
#    olnfs_v4_idmap_domain => $::domain,
#  }

class olnfs::client (
  $package_ensure      = $::olnfs::params::client_package_ensure,
  $olnfs_v4              = $::olnfs::params::olnfs_v4,
  $olnfs_v4_mount_root   = $::olnfs::params::olnfs_v4_mount_root,
  $olnfs_v4_idmap_domain = $::olnfs::params::olnfs_v4_idmap_domain,
  $mounts              = undef
) inherits olnfs::params {

  validate_bool($olnfs_v4)

  # ensure dependencies for mount

  Class["::olnfs::client::${::olnfs::params::osfamily}::install"]
  -> Class["::olnfs::client::${::olnfs::params::osfamily}::configure"]
  -> Class["::olnfs::client::${::olnfs::params::osfamily}::service"]
  -> Class['::olnfs::client']

  if !defined( Class["olnfs::client::${::olnfs::params::osfamily}"]) {
    class{ "olnfs::client::${::olnfs::params::osfamily}":
      olnfs_v4              => $olnfs_v4,
      olnfs_v4_idmap_domain => $olnfs_v4_idmap_domain,
    }
  }

  if $mounts {
    create_resources(olnfs::client::mount, $mounts)
  }

}
