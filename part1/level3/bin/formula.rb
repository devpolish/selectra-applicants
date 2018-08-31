# frozen_string_literal: true

require 'json'
require 'ostruct'
require_relative '../lib/symbolize_helper'
using SymbolizeHelper

raise ArgumentError, 'Please provide an data file as JSON' if ARGV[0].nil?

# Read source file
source = JSON.parse(File.read(ARGV[0])).deep_symbolize_keys
PROVIDERS = []
USERS = []
CONTRACTS = []
DAILY_INSURANCE_COMMISSION = 0.05

source[:providers].each do |provider|
  PROVIDERS.push OpenStruct.new(provider)
end

source[:users].each do |user|
  USERS.push OpenStruct.new(user)
end

source[:contracts].each do |contract|
  CONTRACTS.push OpenStruct.new(contract)
end

def apply_discount(contract_length)
  case
  when contract_length <= 1
    10
  when contract_length > 1 && contract_length <= 3
    20
  when contract_length > 3
    25
  end
end

def calculate_yearly_price(provider_id, user_id)
  contract = CONTRACTS.select { |c| c.user_id == user_id }.first
  provider = PROVIDERS.select { |p| p.id == contract.provider_id }.first
  user = USERS.select { |u| u.id == user_id }.first
  total_bill = (user.yearly_consumption * provider.price_per_kwh).to_i
  discount = (total_bill * apply_discount(contract.contract_length)) / 100
  total_bill - discount
end

def calculate_earnings(total_amount, user_id)
  contract = CONTRACTS.select { |c| c.user_id == user_id }.first
  total_insurance_fee = (DAILY_INSURANCE_COMMISSION * 365) * contract.contract_length
  total_provider_fee = (total_amount - total_insurance_fee)
  total_selectra_fee = ((total_amount - total_insurance_fee) * 12.5) / 100
  {
    insurance_fee: total_insurance_fee,
    provider_fee: total_provider_fee,
    selectra_fee: total_selectra_fee.truncate(2)
  }
end

result = Hash(bills: [])
result_index = 1
USERS.each do |user|
  user_total_price = calculate_yearly_price(user.provider_id, user.id)
  user_bill = {
    commission: calculate_earnings(user_total_price, user.id),
    id: result_index,
    price: user_total_price,
    user_id: user.id
  }
  result[:bills].push user_bill
  result_index += 1
end

File.open('output.json', 'w+') do |f|
  f.write JSON.pretty_generate(result)
end
