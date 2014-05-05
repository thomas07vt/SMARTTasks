require 'spec_helper'
require 'rake'
include Warden::Test::Helpers
Warden.test_mode!

feature 'Todo older than 7 days gets deleted by Rake task' do
  scenario 'Successfully' do
  end
end