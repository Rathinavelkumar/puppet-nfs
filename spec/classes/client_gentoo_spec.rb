require 'spec_helper'
describe 'ol8nfs::client::gentoo' do

  let(:params) {{ :package_ensure => 'installed' }}

  it do
    should contain_class('ol8nfs::client::gentoo')
    should contain_class('ol8nfs::client::gentoo::install')
    should contain_class('ol8nfs::client::gentoo::configure')
    should contain_class('ol8nfs::client::gentoo::service')

    should contain_package('net-nds/rpcbind')
    should contain_package('net-fs/ol8nfs-utils')
    should contain_package('net-libs/libol8nfsidmap')


  end

  context ":ol8nfs_v4 => true" do
    let(:params) {{ :ol8nfs_v4 => true }}
    it do
      should contain_augeas('/etc/conf.d/ol8nfs')
      should contain_augeas('/etc/idmapd.conf')
    end
  end

end
