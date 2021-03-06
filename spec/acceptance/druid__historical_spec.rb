require 'spec_helper_acceptance'

historical_pp = <<-EOS
class { 'memcached':
  before => Class['druid::historical'],
}

class { 'druid':
  cache_type  => 'memcached',
  cache_hosts => ['127.0.0.1:11211'],
}

class { 'druid::historical':
  server_max_size              => 268435456,
  processing_buffer_size_bytes => 134217728,
  jvm_opts                     => [
    '-server',
    '-Xmx512m',
    '-Xms512m',
    '-Duser.timezone=UTC',
    '-Dfile.encoding=UTF-8',
    '-Djava.io.tmpdir=/tmp',
    '-Djava.util.logging.manager=org.apache.logging.log4j.jul.LogManager'
  ],
  processing_num_threads       => 1, 
  segment_cache_locations      => [
    {
      'path'    => '/tmp/druid/indexCache',
      'maxSize' => 10000000000,
    },
  ],
}
EOS

describe 'druid::historical' do
  before(:all) do
    hosts.each do |host|
      on host, puppet('module install saz-memcached -v 2.8.1')
    end
  end

  describe 'running puppet code' do
    it 'should run without errors' do
      apply_manifest(historical_pp, :catch_failures => true)
    end

    it 'should be idempotent' do
      apply_manifest(historical_pp, :catch_changes => true)
    end

    it 'should have a working druid CLI' do
      druid_cli('version') do |r|
        expect(r.stdout).to match(/Druid version - \d\.\d\.\d/)
      end
    end

    describe port(8083) do
      it { should be_listening }
    end

    describe service('druid-historical') do
      it { should be_enabled }
      it { should be_running }
    end
  end

  after(:all) do
    shell('systemctl is-active druid-historical.service && systemctl stop druid-historical.service')
  end
end
