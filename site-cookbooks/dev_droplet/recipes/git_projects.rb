Chef::Provider::Git.class_eval do
  alias :run_options_old :run_options
  def run_options(run_opts={})
    ret = run_options_old(run_opts)
    ret[:environment] = {} unless ret[:environment]
    ret[:environment]['HOME'] = "/home/#{node[:developer][:user]}"
    ret
  end
end

directory node[:developer][:projects_root] do
  recursive true
  owner     node[:developer][:user]
  group     node[:developer][:user]
end

node.developer.projects.each do |project, data|
  git "#{node[:developer][:projects_root]}/#{project}" do
    repository data[:repository]
    revision   'master'
    user       node[:developer][:user]
    group      node[:developer][:user]
  end
end
