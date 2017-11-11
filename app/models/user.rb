class User < ApplicationRecord
    validates_presence_of :name
    has_one :cart, dependent: :destroy
end
