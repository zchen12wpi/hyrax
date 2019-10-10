# frozen_string_literal: true

# Example:
#    class Book < Hyrax::Base
#      attribute :title, Valkyrie::Types::Set
#      attribute :authors, Valkyrie::Types::Array.meta(ordered: true)
#
#      attr_reader :persister
#  
#      before_save :test_before_save
#      after_save  :test_after_save
#
#      def initialize(persister: Hyrax.persister)
#          @persister = persister
#      end
#     
#
#     def test_before_save
#       puts "before save"
#     end
#
#    def test_after_save
#       puts "saved"
#    end
#  end
#
# b = Book.new
# b.save
# #=> before save
# #=> saving
# #=> saved


module Hyrax
  class Base < Valkyrie::Resource
    include Hyrax::Persistence
    include Hyrax::Callbacks
  end
end
