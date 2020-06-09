title 'Tests to confirm zeromq library exists'

plan_origin = ENV['HAB_ORIGIN']
plan_name = input('plan_name', value: 'zeromq')

control 'core-plans-zeromq-library-exists' do
  impact 1.0
  title 'Ensure zeromq library exists'
  desc '
  Verify zeromq library by ensuring that (1) its installation directory exists; 
  (2) the library exists; (3) its pkgconfig metadata contains the expected version
  '
  
  plan_installation_directory = command("hab pkg path #{plan_origin}/#{plan_name}")
  describe plan_installation_directory do
    its('exit_status') { should eq 0 }
    its('stdout') { should_not be_empty }
  end

  library_relative_path = input('library_relative_path', value: '/lib/libzmq.so')
  library_full_path = plan_installation_directory.stdout.strip + "#{library_relative_path}"
  describe file(library_full_path) do
    it { should exist }
  end

  plan_pkg_ident = ((plan_installation_directory.stdout.strip).match /(?<=pkgs\/)(.*)/)[1]
  plan_pkg_version = (plan_pkg_ident.match /^#{plan_origin}\/#{plan_name}\/(?<version>.*)\//)[:version]
  pkgconfig_relative_path = input('pkgconfig_relative_path', value: '/lib/pkgconfig/libzmq.pc')
  pkgconfig_full_path = plan_installation_directory.stdout.strip + "#{pkgconfig_relative_path}"
  describe command("cat #{pkgconfig_full_path}") do
    its('exit_status') { should eq 0 }
    its('stdout') { should_not be_empty }
    its('stdout') { should match /Version: #{plan_pkg_version}/ }
    its('stderr') { should be_empty }
  end
end
