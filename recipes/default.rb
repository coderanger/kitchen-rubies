#
# Author:: Noah Kantrowitz <noah@coderanger.net>
#
# Copyright 2013, Noah Kantrowitz
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'apt' if platform_family?('debian', 'ubuntu')

node.set['omnibus']['install_dir'] = "/opt/#{node['kitchen-rubies']['project']}"

include_recipe 'git'
include_recipe 'omnibus'

directory node['kitchen-rubies']['dir'] do
  owner node['omnibus']['build_user']
  mode '755'
end

git node['kitchen-rubies']['dir'] do
  repository 'https://github.com/coderanger/omnibus-rubies.git'
  revision 'master'
  user node['omnibus']['build_user']
end

template File.join(node['kitchen-rubies']['dir'], 'omnibus.rb') do
  source 'omnibus.rb.erb'
  owner node['omnibus']['build_user']
  mode '644'
end

{
  'bundle install' => 'bundle install --binstubs --path vendor/bundle',
  'rm pkg/*' => "rm -f #{node['kitchen-rubies']['dir']}/pkg/*",
  'omnibus build' => "bin/omnibus build project #{node['kitchen-rubies']['project']}",
  'omnibus release' => Chef::DelayedEvaluator.new { "bin/omnibus release package #{Dir[node['kitchen-rubies']['dir'] + '/pkg/*'].find{|n| !n.end_with?('.json') }}" },

}.each do |name, cmd|
  rbenv_execute name do
    command cmd
    ruby_version node['omnibus']['ruby_version']
    cwd node['kitchen-rubies']['dir']
    user node['omnibus']['build_user']
    environment 'HOME' => node['kitchen-rubies']['dir']
  end
end
