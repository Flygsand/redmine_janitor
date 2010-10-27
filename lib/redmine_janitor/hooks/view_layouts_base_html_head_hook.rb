module RedmineJanitor
  module Hooks
    class ViewLayoutsBaseHtmlHeadHook < Redmine::Hook::ViewListener
      def view_layouts_base_html_head(context={})
        return stylesheet_link_tag('janitor', :plugin => 'redmine_janitor', :media => 'screen')
      end
    end
  end
end
