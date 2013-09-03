module TabsHelper

  def user_edit_tabbable(options, &block)
    tabbable({
      'my-details'       => user_edit_my_details_path(current_user),
      'change-password'  => user_edit_password_path(current_user),
      'ssh-keys'         => user_edit_ssh_keys_path(current_user),
      'manage-favorites' => user_edit_favorites_path(current_user) },
      options.reverse_merge(:position => 'left', :active => 'my-details'), &block
    )
  end

  def tabbable(tabs, options = {}, &block)
    position = options.fetch(:position, 'top')
    names    = tabs.is_a?(Hash) ? tabs.keys : tabs
    active   = (names.include?(params[:tab]) && params[:tab]) || options[:active]

    content_tag(:div, :class => "tabbable tabs-#{position}") {
      nav_tabs(tabs, active) + tab_content(&block)
    }.html_safe
  end

  def nav_tabs(tabs, active)
    content_tag(:ul, :class => 'nav nav-tabs', :data => { :active => active }) {
      tabs.map { |name, path|
        class_names = []
        class_names << 'active' if name == active
        content_tag(:li, nav_link(name, path), :class => class_names)
      }.join("\n").html_safe
    }
  end

  def nav_link(name, path)
    path ||= "##{name}"

    link_to(t("views.tabs.#{name.underscore}"), path,
      :data => { :toggle => 'tab', :target => "##{name.to_s.dasherize}" })
  end

  def tab_content(&block)
    content_tag(:div, :class => "tab-content") { capture(&block) }.html_safe
  end

  def tab_pane(id, options = {}, &block)
    active = options.fetch(:active, false)

    class_names = 'tab-pane'
    class_names << 'active' if active

    content_tag(:div, :class => class_names, :id => id.to_s.dasherize) {
      capture(&block)
    }
  end

end
