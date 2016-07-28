module LocalizationHelper
  def link_to_locale (loc)
    link_to({locale: loc}, {class: "dropdown-item"}) do
      "<span class='flag-icon flag-icon-#{loc}'> </span> #{I18n.name_for_locale(loc)}".html_safe
    end
  end
end
