module Admin
    class ProductSavingService
        class NotSavedProductError < StandardError; end

        attr_reader :product, :errors
        
        def initialize(params, product = nil)
           params = params.deep_symbolize_keys
           @product_params = params.reject { |key| key == :produtable_attibures }
           @product_params = params[:productable_attributes] || {}
           @errors = {}
           @product = product || Product.new
        end

        def call 
            Product.transaction do
                @product.attributes = @product_params.reject { |key| key == :productable }
                build_productable
            ensure 
                save! 
            end
        end

        def build_productable
            @product.productable ||= @product_params[:productable].camelcase.safe_constantize.new 
            @product.productable.attributes = @productable_params
        end

        def save!
             save_record!(@product.productable) if @product.productable.present?
             save_record!(@product)
        end

        def save_record!(record)
            record.save! 
        rescue ActiveRecord::RecordInvalid
            @errors.marge!(record.errors.messages)
        end
    end
end