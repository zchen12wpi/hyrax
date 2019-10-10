# frozen_string_literal: true

module Hyrax
  module Callbacks
    extend ActiveSupport::Concern

    CALLBACKS = [
      :after_initialize, :after_find, :before_validation, :after_validation,
      :before_save, :around_save, :after_save, :before_create, :around_create,
      :after_create, :before_update, :around_update, :after_update,
      :before_destroy, :around_destroy, :after_destroy,
      :before_update_index, :around_update_index, :after_update_index
    ].freeze

    included do
      extend ActiveModel::Callbacks
      include ActiveModel::Validations::Callbacks

      define_model_callbacks :initialize, :find, only: :after
      define_model_callbacks :save, :create, :update, :destroy, :update_index
    end
    
    def update_index(*args)
      _run_update_index_callbacks { super(*args) }
    end

    private

      def create_or_update(*)
        _run_save_callbacks { super }
      end

      def _create_record(*) #:nodoc:
        _run_create_callbacks { super }
      end

      def _update_record(*) #:nodoc:
        _run_update_callbacks { super }
      end
  end
end
