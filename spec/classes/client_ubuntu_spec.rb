require 'spec_helper'
describe 'olnfs::client::ubuntu' do

  let(:params) {{ :package_ensure => 'installed' }}

  it do
    should contain_class('olnfs::client::ubuntu::install')
    should contain_class('olnfs::client::ubuntu::configure')
    should contain_class('olnfs::client::ubuntu::service')

    should contain_service('rpcbind').with(
      'ensure' => 'running'
    )

    should contain_service('idmapd').with(
      'ensure' => 'stopped'
    )
    should contain_package('olnfs-common')
    should contain_package('rpcbind')
    
    should contain_package('olnfs4-acl-tools')
  end
  context ":olnfs_v4 => true" do
    let(:params) {{ :olnfs_v4 => true }}
    it do
      should contain_augeas('/etc/idmapd.conf') 
      should contain_service('idmapd').with(
        'ensure' => 'running'
      )
    end
  end

end
