# # encoding : utf-8

MoneyRails.configure do |config|
  config.default_currency = :usd
  config.no_cents_if_whole = false
end

Money.locale_backend = :currency
Money.rounding_mode = BigDecimal::ROUND_HALF_EVEN
