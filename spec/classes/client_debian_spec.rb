require 'spec_helper'
describe 'olnfs::client::debian' do

  let(:facts) do
    facts
  end
  let :pre_condition do 
    'include ::olnfs::client'
  end

  it do
    should contain_class('olnfs::client::debian::install')
    should contain_class('olnfs::client::debian::configure')
    should contain_class('olnfs::client::debian::service')

    should contain_service('rpcbind').with(
      'ensure' => 'running'
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
