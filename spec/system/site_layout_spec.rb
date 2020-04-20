require 'rails_helper'

RSpec.describe "SiteLayoutSpecs", type: :system do
  context 'access to root_path' do
    before do
      visit root_path
    end
    
    it 'has links sach as root_path, help_path, and about_path' do
      expect(page).to have_link nil, href: root_path, count: 2
      expect(page).to have_link 'Help', href: help_path
      expect(page).to have_link 'About', href: about_path
      expect(page).to have_link 'Contact', href: contact_path
      expect(page).to have_link 'Sign up now!', href: signup_path
    end
  end
end
