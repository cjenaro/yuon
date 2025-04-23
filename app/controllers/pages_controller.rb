class PagesController < ApplicationController
  skip_before_action :require_authentication, only: [:show]
  before_action :authenticate_for_page, only: [:show]
  before_action :set_page, only: [ :show, :edit, :update, :destroy ]
  before_action :set_breadcrumbs, only: [ :show, :edit ]

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
    return if @page.present?
    
    @page = if Current.user
      Current.user.pages.find(params[:id])
    else
      Page.find_by(id: params[:id], is_public: true)
    end
    
    unless @page
      redirect_to pages_path, alert: "Page not found or you don't have access to it."
    end
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

  def authenticate_for_page
    return true if Current.user
    
    page = Page.find_by(id: params[:id])
    if page&.is_public
      @page = page
      set_breadcrumbs
      return true
    else
      redirect_to new_session_path, alert: "Please sign in to access this page."
      return false
    end
  end
end
