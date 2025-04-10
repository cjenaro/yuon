class PagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_page, only: [:show, :edit, :update, :destroy]
  before_action :set_breadcrumbs, only: [:show, :edit]
  
  def index
    @pages = Current.user.pages.where(parent_page_id: nil)
  end
  
  def show
  end
  
  def new
    @page = Page.new
    @page.parent_page_id = params[:parent_page_id] if params[:parent_page_id]
  end
  
  def create
    @page = Current.user.pages.new(page_params)
    
    if @page.save
      redirect_to @page, notice: "Page was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  def edit
  end
  
  def update
    if @page.update(page_params)
      redirect_to @page, notice: "Page was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  def destroy
    @page.destroy
    redirect_to pages_path, notice: "Page was successfully deleted."
  end
  
  def update_sidebar_state
    session[:expanded_pages] = params[:expanded_pages]
    head :ok
  end
  
  private
  
  def set_page
    @page = Current.user.pages.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to pages_path, alert: "Page not found or you don't have access to it."
  end
  
  def set_breadcrumbs
    @breadcrumbs = []
    current_page = @page
    
    while current_page
      @breadcrumbs.push({ 
        title: current_page.title, 
        path: current_page == @page ? nil : page_path(current_page)
      })
      current_page = current_page.parent_page
    end

    @breadcrumbs.push({ title: "Pages", path: pages_path })
    @breadcrumbs.reverse!
  end
  
  def page_params
    params.require(:page).permit(:title, :parent_page_id, :is_public)
  end
  
  def authenticate_user!
    redirect_to new_session_path, alert: "Please sign in to access pages." unless Current.user
  end
end 