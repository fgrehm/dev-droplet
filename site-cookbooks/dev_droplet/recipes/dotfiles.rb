%w( dotfiles vimfiles ).each do |project|
  bash "setup-#{project}" do
    code "./setup.sh"
    cwd "#{node.developer.projects_root}/#{project}"
    user node.developer.user
    environment 'HOME' => "/home/#{node.developer.user}"
  end
end
