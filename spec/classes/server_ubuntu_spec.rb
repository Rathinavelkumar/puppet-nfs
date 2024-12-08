
require 'spec_helper'
describe 'olnfs::server::ubuntu', :type => :class do
  it do
    should contain_class('olnfs::client::ubuntu')
    should contain_class('olnfs::server::ubuntu::service')
    should contain_package('olnfs-kernel-server')
    should contain_service('olnfs-kernel-server').with( 'ensure' => 'running'  )
  end
  context ":olnfs_v4 => true" do
    let(:params) {{ :olnfs_v4 => true }}
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
