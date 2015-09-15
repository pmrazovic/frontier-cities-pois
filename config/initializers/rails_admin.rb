RailsAdmin.config do |config|

  config.main_app_name = ["Frontier Cities", "/ POI management"]

  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)

  ## == Cancan ==
  # config.authorize_with :cancan

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  config.model 'Poi' do
    weight 1
    label "POI" 
    label_plural "POIs"
    list do
      exclude_fields :created_at, :updated_at
    end
  end

  config.model 'Category' do
    weight 2
    list do
      exclude_fields :created_at, :updated_at
    end
  end

  config.model 'Subcategory' do
    weight 3
    list do
      exclude_fields :created_at, :updated_at
    end
  end

  config.model 'Filter' do
    weight 4
    list do
      exclude_fields :created_at, :updated_at
    end
  end

  config.model 'Neighborhood' do
    weight 5
    list do
      exclude_fields :created_at, :updated_at
    end
  end

end
