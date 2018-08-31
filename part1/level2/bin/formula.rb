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

result = Hash(bills: [])
result_index = 1
USERS.each do |user|
  user_bill = {
    id: result_index,
    price: calculate_yearly_price(user.provider_id, user.id),
    user_id: user.id
  }
  result[:bills].push user_bill
  result_index += 1
end

File.open('output.json', 'w+') { |file| file.write JSON.pretty_generate result }
