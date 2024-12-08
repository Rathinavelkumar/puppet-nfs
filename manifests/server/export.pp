define ol8nfs::server::export (
  $v3_export_name = $name,
  # Grab the final directory name in the given path and make it our default ol8nfsv4 export name.
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
  $ol8nfstag         = undef,
  $server         = $::clientcert) {
  if $ol8nfs::server::ol8nfs_v4 {
    ol8nfs::server::export::ol8nfs_v4::bindmount { $name:
      ensure         => $ensure,
      v4_export_name => $v4_export_name,
      bind           => $bind,
      owner          => $owner,
      group          => $group,
      perms          => $perms,
    }

    ol8nfs::server::export::configure { "${ol8nfs::server::ol8nfs_v4_export_root}/${v4_export_name}":
      ensure  => $ensure,
      clients => $clients,
      require => ol8nfs::Server::Export::ol8nfs_v4::Bindmount[$name]
    }

    @@ol8nfs::client::mount { "shared ${v4_export_name} by ${::clientcert}":
      ensure    => $ensure,
      mount     => $mount,
      remounts  => $remounts,
      atboot    => $atboot,
      options   => $options,
      bindmount => $bindmount,
      ol8nfstag    => $ol8nfstag,
      share     => $v4_export_name,
      server    => $server,
    }

  } else {
    ol8nfs::server::export::configure { $v3_export_name:
      ensure  => $ensure,
      clients => $clients,
    }

    if $mount == undef {
      $_mount = $v3_export_name
    } else {
      $_mount = $mount
    }

    @@ol8nfs::client::mount { "shared ${v3_export_name} by ${::clientcert}":
      ensure   => $ensure,
      mount    => $_mount,
      remounts => $remounts,
      atboot   => $atboot,
      options  => $options,
      ol8nfstag   => $ol8nfstag,
      share    => $v3_export_name,
      server   => $server,
    }
  }
}
