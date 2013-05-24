module ApplicationHelper
  def html_button_to(name, path, options)
    form_method = (options[:method] == :get ? :get : :post)
    content_tag :form, method: form_method, action: path do
      html = ('<input name="authenticity_token" type="hidden" value="' + form_authenticity_token + '" />')
      html += '<input type="hidden" name="_method" value="delete" />' if options[:method] == :delete
      html += (content_tag :button, :class => (options[:class] || "btn"), type: "submit", disabled: options[:disabled] do raw name end)
      html.html_safe
    end
  end

  def smart_navbar_item(name, path)
    html = (path == request.fullpath ? '<li class="active">' : '<li>')
    html += (link_to name, path)
    html += '</li>'
    html.html_safe
  end
end
