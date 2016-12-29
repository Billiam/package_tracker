Trackify::Admin.controllers :tracking_numbers do
  get :index do
    @title = "Tracking_numbers"
    @tracking_numbers = TrackingNumber.order(:scheduled_for).all
    render 'tracking_numbers/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'tracking_number')
    @tracking_number = TrackingNumber.new
    render 'tracking_numbers/new'
  end

  post :create do
    @tracking_number = TrackingNumber.new(params[:tracking_number])
    if (@tracking_number.save rescue false)
      @title = pat(:create_title, :model => "tracking_number #{@tracking_number.id}")
      flash[:success] = pat(:create_success, :model => 'TrackingNumber')
      params[:save_and_continue] ? redirect(url(:tracking_numbers, :index)) : redirect(url(:tracking_numbers, :edit, :id => @tracking_number.id))
    else
      @title = pat(:create_title, :model => 'tracking_number')
      flash.now[:error] = pat(:create_error, :model => 'tracking_number')
      render 'tracking_numbers/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "tracking_number #{params[:id]}")
    @tracking_number = TrackingNumber[params[:id]]
    if @tracking_number
      render 'tracking_numbers/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'tracking_number', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "tracking_number #{params[:id]}")
    @tracking_number = TrackingNumber[params[:id]]
    if @tracking_number
      if @tracking_number.modified! && @tracking_number.update(params[:tracking_number])
        flash[:success] = pat(:update_success, :model => 'Tracking_number', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:tracking_numbers, :index)) :
          redirect(url(:tracking_numbers, :edit, :id => @tracking_number.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'tracking_number')
        render 'tracking_numbers/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'tracking_number', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Tracking_numbers"
    tracking_number = TrackingNumber[params[:id]]
    if tracking_number
      if tracking_number.destroy
        flash[:success] = pat(:delete_success, :model => 'Tracking_number', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'tracking_number')
      end
      redirect url(:tracking_numbers, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'tracking_number', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Tracking_numbers"
    unless params[:tracking_number_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'tracking_number')
      redirect(url(:tracking_numbers, :index))
    end
    ids = params[:tracking_number_ids].split(',').map(&:strip)
    tracking_numbers = TrackingNumber.where(:id => ids)
    
    if tracking_numbers.destroy
    
      flash[:success] = pat(:destroy_many_success, :model => 'Tracking_numbers', :ids => "#{ids.join(', ')}")
    end
    redirect url(:tracking_numbers, :index)
  end
end
