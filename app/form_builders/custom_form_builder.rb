class CustomFormBuilder < ActionView::Helpers::FormBuilder
  def text_field(method, options = {})
    super + error(method)
  end

  def number_field(method, options = {})
    super + error(method)
  end

  def telephone_field(method, options = {})
    super + error(method)
  end

  def collection_select(method, collection, value_method, text_method, options = {}, html_options = {})
    super + error(method)
  end

  def collection_radio_buttons(method, collection, value_method, text_method, options = {}, html_options = {}, &block)
    super + error(method)
  end

  private

  def error(method)
    error_html(error_message(method))
  end

  def error_message(method)
    (@object.errors[method].size > 0) ? I18n.t("activerecord.attributes.#{@object.model_name.singular}.#{method}") + @object.errors[method].first : ""
  end

  def error_html(msg)
    return "" unless msg.present?
  end
end