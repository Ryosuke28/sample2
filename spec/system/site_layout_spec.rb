require 'rails_helper'

RSpec.describe "SiteLayoutSpecs", type: :system do
  context 'access to root_path' do
    before do
      visit root_path
    end
    subject { page }
    it 'has links sach as root_path, help_path, and about_path' do
      is_expected.to have_link nil, href: root_path, count: 2
      is_expected.to have_link 'Help', href: help_path
      is_expected.to have_link 'About', href: about_path
    end
  end
end
