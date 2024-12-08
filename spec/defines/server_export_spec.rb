
require 'spec_helper'

describe 'ol8nfs::server::export' do
  let(:facts) {{ :concat_basedir => '/dne' }}
  let(:title) { '/srv/test' }
  #let(:params) {{ :server => 'ol8nfs.int.net', :share => '/srv/share' } }
  it do
    should contain_ol8nfs__server__export__configure('/srv/test')
  end
end
