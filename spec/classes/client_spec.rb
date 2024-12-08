require 'spec_helper'

describe 'ol8nfs::client' do
  context "operatingsysten => ubuntu" do
    let(:facts) { {:operatingsystem => 'ubuntu', } }
    it { should contain_class('ol8nfs::client::ubuntu') }
  end
  context "operatingsysten => debian" do
    let(:facts) { {:operatingsystem => 'debian', } }
    it { should contain_class('ol8nfs::client::debian') }
  end
  context "operatingsysten => scientific" do
    let(:facts) { {:operatingsystem => 'scientific', :operatingsystemrelease => '6.4' } }
    it { should contain_class('ol8nfs::client::redhat') }
  end
  context "operatingsysten => SLC" do
    let(:facts) { {:operatingsystem => 'SLC', :operatingsystemrelease => '6.4' } }
    it { should contain_class('ol8nfs::client::redhat') }
  end
  context "operatingsysten => centos v7" do
    let(:facts) { {:operatingsystem => 'centos', :operatingsystemrelease => '7.0' } }
    it { should contain_class('ol8nfs::client::redhat') }
  end
  context "operatingsysten => centos v6" do
    let(:facts) { {:operatingsystem => 'centos', :operatingsystemrelease => '6.4' } }
    it { should contain_class('ol8nfs::client::redhat') }
  end
  context "operatingsysten => centos v5" do
    let(:facts) { {:operatingsystem => 'centos', :operatingsystemrelease => '5.4' } }
    it { should contain_class('ol8nfs::client::redhat') }
  end
  context "operatingsysten => redhat v7" do
    let(:facts) { {:operatingsystem => 'redhat', :operatingsystemrelease => '7.0' } }
    it { should contain_class('ol8nfs::client::redhat') }
  end
  context "operatingsysten => redhat v6" do
    let(:facts) { {:operatingsystem => 'redhat', :operatingsystemrelease => '6.4' } }
    it { should contain_class('ol8nfs::client::redhat') }
  end
  context "operatingsysten => Amazon v3" do
    let(:facts) { {:operatingsystem => 'Amazon', :operatingsystemrelease =>  '3.10.35-43.137.amzn1.x86_64' } }
    it { should contain_class('ol8nfs::client::redhat') }
  end
  context "operatingsysten => Amazon v4" do
    let(:facts) { {:operatingsystem => 'Amazon', :operatingsystemrelease =>  '4.1.7-15.23.amzn1.x86_64' } }
    it { should contain_class('ol8nfs::client::redhat') }
  end
  context "operatingsysten => gentoo" do
    let(:facts) { {:operatingsystem => 'gentoo', } }
    it { should contain_class('ol8nfs::client::gentoo') }
  end
  context "operatingsystem => darwin" do
    let(:facts) { {:operatingsystem => 'darwin', } }
    it do
      expect {
        should contain_class('ol8nfs::server::darwin')
      }.to raise_error(Puppet::Error, /ol8nfs client is not supported on Darwin/)
    end
  end
end
