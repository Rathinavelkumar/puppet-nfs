require 'spec_helper'
describe 'olnfs::server::redhat' do
  context "operatingsystemrelease => 6.4" do
    let(:facts) { {:operatingsystemrelease => '6.4', :operatingsystemmajrelease => '6'} }
    it do
      should contain_class('olnfs::client::redhat')
      should contain_service('olnfs').with( 'ensure' => 'running'  )
    end
  end

  context "operatingsystemrelease => 7.1" do
    let(:facts) { {:operatingsystemrelease => '7.1', :operatingsystemmajrelease => '7'} }
    it do
      should contain_class('olnfs::client::redhat')
      should contain_class('olnfs::server::redhat::service')
      should contain_service('olnfs-server').with( 'ensure' => 'running'  )
    end

    context ":olnfs_v4 => true" do
      let(:params) {{ :olnfs_v4 => true , :olnfs_v4_idmap_domain => 'teststring' }}
      it do
        should contain_augeas('/etc/idmapd.conf').with_changes(/set Domain teststring/)
      end
    end

    context "mountd params set port" do
      let(:params) {{ :mountd_port => '4711' }}
      it do
        should contain_file_line('rpc-mount-options-port') #.with( 'ensure' => 'present' )
      end
    end

    context "mountd params set threads" do
      let(:params) {{ :mountd_threads => '11' }}
      it do
        should contain_file_line('rpc-mount-options-threads') #.with( 'ensure' => 'present' )
      end
    end
  end
end
