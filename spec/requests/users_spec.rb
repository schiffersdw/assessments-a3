# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'GET /index' do
    it 'List of Users' do
      get users_path
      expect(response).to have_http_status(:ok)
    end
  end
end
