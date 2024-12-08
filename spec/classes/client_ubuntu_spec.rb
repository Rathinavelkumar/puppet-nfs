require 'spec_helper'
describe 'ol8nfs::client::ubuntu' do

  let(:params) {{ :package_ensure => 'installed' }}

  it do
    should contain_class('ol8nfs::client::ubuntu::install')
    should contain_class('ol8nfs::client::ubuntu::configure')
    should contain_class('ol8nfs::client::ubuntu::service')

    should contain_service('rpcbind').with(
      'ensure' => 'running'
    )

    should contain_service('idmapd').with(
      'ensure' => 'stopped'
    )
    should contain_package('ol8nfs-common')
    should contain_package('rpcbind')
    
    should contain_package('ol8nfs4-acl-tools')
  end
  context ":ol8nfs_v4 => true" do
    let(:params) {{ :ol8nfs_v4 => true }}
    it do
      should contain_augeas('/etc/idmapd.conf') 
      should contain_service('idmapd').with(
        'ensure' => 'running'
      )
    end
  end

end
