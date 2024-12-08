require 'spec_helper'
describe 'olnfs::client::gentoo' do

  let(:params) {{ :package_ensure => 'installed' }}

  it do
    should contain_class('olnfs::client::gentoo')
    should contain_class('olnfs::client::gentoo::install')
    should contain_class('olnfs::client::gentoo::configure')
    should contain_class('olnfs::client::gentoo::service')

    should contain_package('net-nds/rpcbind')
    should contain_package('net-fs/olnfs-utils')
    should contain_package('net-libs/libolnfsidmap')


  end

  context ":olnfs_v4 => true" do
    let(:params) {{ :olnfs_v4 => true }}
    it do
      should contain_augeas('/etc/conf.d/olnfs')
      should contain_augeas('/etc/idmapd.conf')
    end
  end

end
