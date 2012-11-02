module ApplicationHelper
  def body_attrs
    attrs = {}
    class_name = [location_name,I18n.locale,ENV['RAILS_ENV']]
    attrs[:location]   = location_name
    attrs[:controller] = controller.controller_name
    attrs[:action]     = action_name
    attrs
  end

  def location_name?(*names)
    names.any?{ |name| name == location_name }
  end

  def location_name
    "#{action_name}_#{controller.controller_name}"
  end

  def location_match?(*names)
    names.any?{ |name| controller.controller_path.match(/#{name}/) }
  end
end
