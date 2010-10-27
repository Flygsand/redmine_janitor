# -*- coding: utf-8 -*-

require 'redmine'
require 'dispatcher'

Redmine::Plugin.register :redmine_janitor do
  name 'Redmine Janitor plugin'
  author 'Martin Häger'
  description 'This plugin provides a utility for cleaning up a Redmine instance'
  version '0.0.1'
  url 'http://github.com/mtah/redmine_janitor'
  author_url 'http://freeasinbeard.org'

  menu :admin_menu, :janitor, { :controller => 'janitor', :action => 'index' }, :caption => 'Janitor'
end


Dispatcher.to_prepare :redmine_janitor do
  require 'redmine_janitor/hooks/view_layouts_base_html_head_hook'
end
