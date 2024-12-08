require 'spec_helper'
describe 'ol8nfs::server::gentoo' do

  it do
    should contain_class('ol8nfs::client::gentoo')
    should contain_class('ol8nfs::server::gentoo::service')
    should contain_service('ol8nfs').with( 'ensure' => 'running'  )
  end
  context ":ol8nfs_v4 => true" do
    let(:params) {{ :ol8nfs_v4 => true , :ol8nfs_v4_idmap_domain => 'teststring' }}
    it do
      should contain_augeas('/etc/idmapd.conf').with_changes(/set Domain teststring/)
    end

  end
end