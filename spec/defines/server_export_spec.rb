
require 'spec_helper'

describe 'olnfs::server::export' do
  let(:facts) {{ :concat_basedir => '/dne' }}
  let(:title) { '/srv/test' }
  #let(:params) {{ :server => 'olnfs.int.net', :share => '/srv/share' } }
  it do
    should contain_olnfs__server__export__configure('/srv/test')
  end
end
