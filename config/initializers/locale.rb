# Created by Felix Jankowski July 27, 2016

#Rails.application.config.i18n.fallbacks = [:en]


# Rails.application.config.i18n.available_locales = [:en, :de]

# Rails.application.config.i18n.enforce_available_locales = true


# From https://gist.github.com/henrik/276191

module I18n
  def self.name_for_locale(locale)
    self.with_locale(locale) { self.translate("i18n.language.name") }
  rescue I18n::MissingTranslationData
    locale.to_s
  end
end
