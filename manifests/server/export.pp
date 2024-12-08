define olnfs::server::export (
  $v3_export_name = $name,
  # Grab the final directory name in the given path and make it our default olnfsv4 export name.
  $v4_export_name = regsubst($name, '.*/([^/]+)/?$', '\1'),
  $clients        = 'localhost(ro)',
  $bind           = 'rbind',
  $owner          = 'root',
  $group          = 'root',
  $perms          = '0755',
  # globals for this share
  # propogated to storeconfigs
  $ensure         = 'mounted',
  $mount          = undef,
  $remounts       = false,
  $atboot         = false,
  $options        = '_netdev',
  $bindmount      = undef,
  $olnfstag         = undef,
  $server         = $::clientcert) {
  if $olnfs::server::olnfs_v4 {
    olnfs::server::export::olnfs_v4::bindmount { $name:
      ensure         => $ensure,
      v4_export_name => $v4_export_name,
      bind           => $bind,
      owner          => $owner,
      group          => $group,
      perms          => $perms,
    }

    olnfs::server::export::configure { "${olnfs::server::olnfs_v4_export_root}/${v4_export_name}":
      ensure  => $ensure,
      clients => $clients,
      require => olnfs::Server::Export::olnfs_v4::Bindmount[$name]
    }

    @@olnfs::client::mount { "shared ${v4_export_name} by ${::clientcert}":
      ensure    => $ensure,
      mount     => $mount,
      remounts  => $remounts,
      atboot    => $atboot,
      options   => $options,
      bindmount => $bindmount,
      olnfstag    => $olnfstag,
      share     => $v4_export_name,
      server    => $server,
    }

  } else {
    olnfs::server::export::configure { $v3_export_name:
      ensure  => $ensure,
      clients => $clients,
    }

    if $mount == undef {
      $_mount = $v3_export_name
    } else {
      $_mount = $mount
    }

    @@olnfs::client::mount { "shared ${v3_export_name} by ${::clientcert}":
      ensure   => $ensure,
      mount    => $_mount,
      remounts => $remounts,
      atboot   => $atboot,
      options  => $options,
      olnfstag   => $olnfstag,
      share    => $v3_export_name,
      server   => $server,
    }
  }
}
