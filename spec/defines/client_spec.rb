require 'spec_helper'

describe 'olnfs::client::mount', :type => :define do
  context "Mount created by exported resource" do
    let(:title) { 'shared /srv/test by olnfs.int.net' }
    let(:facts) { { :operatingsystem => 'ubuntu', :clientcert => 'test.example.com' } }
    let(:params) {{ 
      :server => 'olnfs.int.net',
      :share  => '/srv/share',
      :mount  => '/srv/share'
    }}
    it do
      should compile
      should contain_class('olnfs::client')
      should contain_mount('shared olnfs.int.net:/srv/share by test.example.com /srv/share')
    end
  end

  context "Mount manually set" do
    let(:title) { '/srv/test' }
    let(:facts) { { :operatingsystem => 'ubuntu', :clientcert => 'test.example.com' } }
    let(:params) {{ :server => 'olnfs.int.net', :share => '/srv/share' } }
    it do
      should compile
      should contain_class('olnfs::client')
#      should contain_mount('shared olnfs.int.net:/srv/share by test.example.com /srv/test')
      #should contain_mount('/srv/test')
    end
  end
end
