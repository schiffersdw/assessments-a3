# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Emitters', type: :request do
  describe 'GET /index' do
    it 'List of emitters' do
      get emitters_path
      expect(response).to have_http_status(:ok)
    end
  end
end
