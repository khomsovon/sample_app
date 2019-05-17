require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller, js: true do
  context "Static pages" do
    it "should get home" do

      visit static_pages_home_path

      binding.pry

      expect(page).to have_page_title("Home")

    end
  end
end
