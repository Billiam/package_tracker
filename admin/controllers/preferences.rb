Trackify::Admin.controllers :preferences do
  get :index do
    @title = "Preferences"
    @preferences = Preference.order(:key).all
    render 'preferences/index'
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "preference #{params[:id]}")
    @preference = Preference[params[:id]]
    if @preference
      render 'preferences/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'preference', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id, params: [:save_and_continue, preference: [:value]] do
    @title = pat(:update_title, :model => "preference #{params[:id]}")
    @preference = Preference[params[:id]]
    if @preference
      if @preference.modified! && @preference.update(params[:preference])
        flash[:success] = pat(:update_success, :model => 'Preference', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:preferences, :index)) :
          redirect(url(:preferences, :edit, :id => @preference.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'preference')
        render 'preferences/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'preference', :id => "#{params[:id]}")
      halt 404
    end
  end
end
