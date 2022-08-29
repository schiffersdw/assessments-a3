# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'InvoicesController', type: :request do
  describe 'GET /index' do
    it 'List of invoices' do
      get invoices_path
      expect(response).to have_http_status(:ok)
    end
  end
end
