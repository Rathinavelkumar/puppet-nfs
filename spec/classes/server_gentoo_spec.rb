require 'spec_helper'
describe 'olnfs::server::gentoo' do

  it do
    should contain_class('olnfs::client::gentoo')
    should contain_class('olnfs::server::gentoo::service')
    should contain_service('olnfs').with( 'ensure' => 'running'  )
  end
  context ":olnfs_v4 => true" do
    let(:params) {{ :olnfs_v4 => true , :olnfs_v4_idmap_domain => 'teststring' }}
    it do
      should contain_augeas('/etc/idmapd.conf').with_changes(/set Domain teststring/)
    end

  end
end