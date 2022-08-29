# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Receivers', type: :request do
  describe 'GET /index' do
    it 'List of Receivers' do
      get receivers_path
      expect(response).to have_http_status(:ok)
    end
  end
end
