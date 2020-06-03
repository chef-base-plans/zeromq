title 'Tests to confirm zeromq exists'

plan_name = input('plan_name', value: 'zeromq')
plan_ident = "#{ENV['HAB_ORIGIN']}/#{plan_name}"
zeromq_relative_path = input('command_path', value: '/bin/zeromq')
zeromq_installation_directory = command("hab pkg path #{plan_ident}")
zeromq_full_path = zeromq_installation_directory.stdout.strip + "/lib"
 
control 'core-plans-zeromq-exists' do
  impact 1.0
  title 'Ensure zeromq libraries exists'
  desc '
  See https://gist.github.com/katopz/8b766a5cb0ca96c816658e9407e83d00
  '
   describe file("#{zeromq_full_path}/libzmq.so") do
    it { should exist }
  end
  describe file("#{zeromq_full_path}/libzmq.so.5") do
    it { should exist }
  end
end
