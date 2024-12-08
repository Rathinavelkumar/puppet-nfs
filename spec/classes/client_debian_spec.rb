require 'spec_helper'
describe 'ol8nfs::client::debian' do

  let(:facts) do
    facts
  end
  let :pre_condition do 
    'include ::ol8nfs::client'
  end

  it do
    should contain_class('ol8nfs::client::debian::install')
    should contain_class('ol8nfs::client::debian::configure')
    should contain_class('ol8nfs::client::debian::service')

    should contain_service('rpcbind').with(
      'ensure' => 'running'
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
