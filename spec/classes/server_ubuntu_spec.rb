
require 'spec_helper'
describe 'ol8nfs::server::ubuntu', :type => :class do
  it do
    should contain_class('ol8nfs::client::ubuntu')
    should contain_class('ol8nfs::server::ubuntu::service')
    should contain_package('ol8nfs-kernel-server')
    should contain_service('ol8nfs-kernel-server').with( 'ensure' => 'running'  )
  end
  context ":ol8nfs_v4 => true" do
    let(:params) {{ :ol8nfs_v4 => true }}
    it do
      should contain_service('idmapd').with( 'ensure' => 'running'  )
    end
  end

  context "mountd params set port" do
    let(:params) {{ :mountd_port => '4711' }}
    it do
      should contain_file_line('rpc-mount-options') #.with( 'ensure' => 'present' )
    end
  end

end
