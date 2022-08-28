# frozen_string_literal: true

class Emitter < ApplicationRecord
  scope :search_query, lambda { |param|
    where('UPPER(name) LiKE ? ', "%#{param.upcase}%") if param
  }

  scope :actives, -> { where(active: true) }
end
