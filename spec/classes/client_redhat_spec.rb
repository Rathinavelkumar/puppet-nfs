require 'spec_helper'
describe 'ol8nfs::client::redhat' do

  let(:params) {{ :package_ensure => 'installed' }}

  context "operatingsystemrelease => 7.0" do
    let(:facts) { {:operatingsystemrelease => '7.0' } }
    it do
      should contain_class('ol8nfs::client::redhat::install')
      should contain_class('ol8nfs::client::redhat::configure')
      should contain_class('ol8nfs::client::redhat::service')
      should contain_service('ol8nfslock').with(
        'ensure' => 'running'
      )
      should contain_package('ol8nfs-utils')
      should contain_class('ol8nfs::client::redhat')
      should contain_package('rpcbind')
      should contain_service('rpcbind').with(
        'ensure' => 'running'
      )
    end
  end

  context "operatingsystemrelease => 6.4" do
    let(:facts) { {:operatingsystemrelease => '6.4' } }
    it do
      should contain_class('ol8nfs::client::redhat::install')
      should contain_class('ol8nfs::client::redhat::configure')
      should contain_class('ol8nfs::client::redhat::service')

      should contain_service('ol8nfslock').with(
        'ensure' => 'running'
      )
      should contain_service('netfs').with(
        'enable' => 'true'
      )
      should contain_package('ol8nfs-utils')
      should contain_class('ol8nfs::client::redhat')
      should contain_package('rpcbind')
      should contain_service('rpcbind').with(
        'ensure' => 'running'
      )
    end
  end

  context "operatingsystemrelease => 3.10.35-43.137.amzn1.x86_64" do
    let(:facts) { {:operatingsystemrelease => "3.10.35-43.137.amzn1.x86_64" } }
    it do
      should contain_class('ol8nfs::client::redhat::install')
      should contain_class('ol8nfs::client::redhat::configure')
      should contain_class('ol8nfs::client::redhat::service')

      should contain_service('ol8nfslock').with(
        'ensure' => 'running'
      )
      should contain_service('netfs').with(
        'enable' => 'true'
      )
      should contain_package('ol8nfs-utils')
      should contain_class('ol8nfs::client::redhat')
      should contain_package('rpcbind')
      should contain_service('rpcbind').with(
        'ensure' => 'running'
      )
    end
  end

  context "operatingsystemrelease => 4.1.7-15.23.amzn1.x86_64" do
    let(:facts) { {:operatingsystemrelease => "4.1.7-15.23.amzn1.x86_64" } }
    it do
      should contain_class('ol8nfs::client::redhat::install')
      should contain_class('ol8nfs::client::redhat::configure')
      should contain_class('ol8nfs::client::redhat::service')

      should contain_service('ol8nfslock').with(
        'ensure' => 'running'
      )
      should contain_service('netfs').with(
        'enable' => 'true'
      )
      should contain_package('ol8nfs-utils')
      should contain_class('ol8nfs::client::redhat')
      should contain_package('rpcbind')
      should contain_service('rpcbind').with(
        'ensure' => 'running'
      )
    end
  end

  context ":ol8nfs_v4 => true" do
    let(:params) {{ :ol8nfs_v4 => true }}
    let(:facts) {{ :operatingsystemrelease => '6.4' }}
    it do
      should contain_augeas('/etc/idmapd.conf')
    end
  end

  context "operatingsystemrelease => 5.3" do
    let(:facts) { {:operatingsystemrelease => '5.3' } }
    it do
      should contain_class('ol8nfs::client::redhat')
      should contain_package('portmap')

      should contain_service('portmap').with(
        'ensure' => 'running'
      )
    end
  end
end
