module ApplicationHelper
  def html_button_to(name, path, options)
    form_method = (options[:method] == :get ? :get : :post)
    content_tag :form, method: form_method, action: path do
      html = ('<input name="authenticity_token" type="hidden" value="' + form_authenticity_token + '" />').html_safe
      html += '<input type="hidden" name="_method" value="delete" />'.html_safe if options[:method] == :delete
      html += (content_tag :button, :class => (options[:class] || "btn"), type: "submit", disabled: options[:disabled] do raw name end)
    end
  end
end
