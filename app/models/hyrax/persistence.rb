# frozen_string_literal: true

module Hyrax
  module Persistence
    extend ActiveSupport::Concern
    extend ActiveSupport::Autoload

    def save(*args)
        puts "saving"
      # create_or_update(*args)
    end

    def save!(*args)
      create_or_update(*args)
    end

    def update; end

    def update!; end

    def destroy; end

    def destroy!; end

    def new_record?; end

    def persisted?; end
  
    def destroyed?
      @destroyed
    end

    private

      def create_or_update(*args)
        # raise ReadOnlyRecord if readonly?
        result = new_record? ? _create_record(*args) : _update_record(*args)
        result = _create_record(*args)
        result != false
      end

      def _create_record(_options = {})
        save_valkyrie_object
        # other steps
      end

      def save_valkyrie_object
         persister.save(resource: @resource)
      end
  end
end
