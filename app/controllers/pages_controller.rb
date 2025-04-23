class PagesController < ApplicationController
  allow_unauthenticated_access only: [ :show ]
  before_action :set_page, only: [ :show, :edit, :update, :destroy ]
  before_action :set_breadcrumbs, only: [ :show, :edit ]
  before_action :authorize_page_access, only: [ :show ]

  def index
    @pages = Current.user.pages.where(parent_page_id: nil)
  end

  def show
    resume_session
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
    @page = Page.find_by(id: params[:id])

    unless @page
      redirect_to Current.user ? pages_path : new_session_path,
                   alert: "Page not found."
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

  def authorize_page_access
    # Public pages can be viewed by anyone
    return true if @page.is_public

    # Non-public pages require authentication
    unless authenticated?
      redirect_to new_session_path, alert: "Please sign in to access this page."
      return false
    end

    # Check if authenticated user has access
    unless @page.user_id == Current.user.id || @page.shared_users.include?(Current.user)
      redirect_to pages_path, alert: "You don't have access to this page."
      return false
    end

    true
  end

  def page_params
    params.require(:page).permit(:title, :parent_page_id, :is_public)
  end
end
