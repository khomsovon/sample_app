RSpec::Matchers.define :have_flash_message do |content|
  match_unless_raises do |page|
    page.within("#flash") do
      expect(page).to have_content(content)
    end
  end
end

RSpec::Matchers.define :have_hint do |content|
  match_unless_raises do |page|
    expect(page).to have_selector("p.help-block", text: content)
  end
end

RSpec::Matchers.define :have_page_title do |content|
  match_unless_raises do |page|
    page.within("#page-title") do
      expect(page).to have_content(content)
    end
  end
end

RSpec::Matchers.define :have_merchant_address_filled do |address_attributes|
  match_unless_raises do |page|
    pumi = Pumi::Village.find_by_id(address_attributes[:location_code])
    expect(page).to have_select("Province / City", selected: translate_pumi!(pumi.province))
    expect(page).to have_select("District", selected: translate_pumi!(pumi.district))
    expect(page).to have_select("Commune", selected: translate_pumi!(pumi.commune))
    expect(page).to have_select("Village", selected: translate_pumi!(pumi))
  end
end

RSpec::Matchers.define :be_saved_with_merchant do |merchant_attributes|
  match_unless_raises do |merchant|
    sample_filename = merchant_attributes[:sample_filename]

    expect(merchant.name).to eq(merchant_attributes[:name])
    expect(merchant.abbreviation).to eq(merchant_attributes[:abbreviation])
    expect(merchant.business_type).to eq(merchant_attributes[:business_type])
    expect(merchant.start_date).to eq(Date.parse(Date.parse(merchant_attributes[:start_date]).strftime("%Y/%m/01")))
    expect(merchant.refund_policy).to eq(merchant_attributes[:refund_policy])
    expect(merchant.projected_annual_volume).to eq(merchant_attributes[:projected_annual_volume])
    expect(merchant.typical_transaction_amount).to eq(merchant_attributes[:typical_transaction_amount])
    expect(merchant.largest_expected_amount).to eq(merchant_attributes[:largest_expected_amount])

    address = merchant.address
    merchant_address_attributes = merchant_attributes[:address]
    expect(address.house_number).to eq(merchant_address_attributes[:house_number])
    expect(address.street).to eq(merchant_address_attributes[:street])
    expect(address.location_code).to eq(merchant_address_attributes[:location_code])

    business_registration = merchant.business_registration
    business_registration_attributes = merchant_attributes[:business_registration]
    expect(business_registration.number).to eq(business_registration_attributes[:number])
    expect(business_registration.expiry_date.to_s).to eq(business_registration_attributes[:expiry_date])
    expect(business_registration.files.first.filename).to eq(sample_filename)

    tax_information_attributes = merchant_attributes[:tax_information]
    tax_information = merchant.tax_information
    expect(tax_information.number).to eq(tax_information_attributes[:number])

    merchant_owner = merchant.merchant_owner
    merchant_owner_attributes = merchant_attributes[:merchant_owner]
    expect(merchant_owner.first_name).to eq(merchant_owner_attributes[:first_name])
    expect(merchant_owner.nationality).to eq(merchant_owner_attributes[:nationality])
    expect(merchant_owner.email).to eq(merchant_owner_attributes[:email])
    expect(merchant_owner.phone).to eq(PhonyRails.normalize_number(merchant_owner_attributes[:phone], country_number: MerchantOwner::DEFAULT_PHONE_COUNTRY_CODE))

    address = merchant_owner.address
    merchant_owner_address_attributes = merchant_attributes[:merchant_owner][:address]
    expect(address.house_number).to eq(merchant_owner_address_attributes[:house_number])
    expect(address.street).to eq(merchant_owner_address_attributes[:street])
    expect(address.location_code).to eq(merchant_owner_address_attributes[:location_code])

    if merchant_owner_attributes[:nationality] == "KH"
      national_id_card = merchant_owner.national_identification_card
      national_id_card_attributes = merchant_attributes[:merchant_owner][:national_identification_card]
      expect(national_id_card.number).to eq(national_id_card_attributes[:number])
      expect(national_id_card.expiry_date.to_s).to eq(national_id_card_attributes[:expiry_date])
      expect(national_id_card.files.first.filename).to eq(sample_filename)
    else
      passport_attributes = merchant_attributes[:merchant_owner][:passport]
      passport = merchant_owner.passport
      expect(passport.number).to eq(passport_attributes[:number])
      expect(passport.expiry_date.to_s).to eq(passport_attributes[:expiry_date])
      expect(passport.files.first!.filename).to eq(sample_filename)
    end
  end
end
