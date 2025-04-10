class BlocksController < ApplicationController
  before_action :set_page
  before_action :set_block, only: [:update, :destroy]

  def create
    @block = @page.blocks.new(position: @page.blocks.count)
    @block_type = params[:block][:blockable_type].to_s.demodulize.underscore
    @block.build_blockable(@block_type, block_params)

    if @block.save
      respond_to do |format|
        format.html { redirect_to @page }
        format.turbo_stream
      end
    else
      respond_to do |format|
        format.html { redirect_to @page, alert: 'Failed to create block.' }
        format.turbo_stream { render turbo_stream: turbo_stream.replace('new_block_form', partial: 'blocks/form', locals: { page: @page, block: @block, block_type: @block_type }) }
      end
    end
  end

  def update
    blockable = @block.blockable
    
    if blockable.update(blockable_params)
      respond_to do |format|
        format.html { redirect_to @page }
        format.turbo_stream
      end
    else
      respond_to do |format|
        format.html { redirect_to @page, alert: 'Failed to update block.' }
        format.turbo_stream { render turbo_stream: turbo_stream.replace(dom_id(@block), partial: 'blocks/block', locals: { block: @block }) }
      end
    end
  end

  def destroy
    @block.destroy
    
    respond_to do |format|
      format.html { redirect_to @page }
      format.turbo_stream
    end
  end

  def move_up
    @block = @page.blocks.find(params[:id])
    previous_block = @page.blocks.where("position < ?", @block.position).order(position: :desc).first
    
    if previous_block
      @block.update(position: previous_block.position)
      previous_block.update(position: @block.position_was)
      
      respond_to do |format|
        format.html { redirect_to @page }
        format.turbo_stream { render :reorder }
      end
    else
      redirect_to @page
    end
  end

  def move_down
    @block = @page.blocks.find(params[:id])
    next_block = @page.blocks.where("position > ?", @block.position).order(:position).first
    
    if next_block
      @block.update(position: next_block.position)
      next_block.update(position: @block.position_was)
      
      respond_to do |format|
        format.html { redirect_to @page }
        format.turbo_stream { render :reorder }
      end
    else
      redirect_to @page
    end
  end

  def new
    @block = Block.new
    @block_type = params[:type] || 'text'
    
    render :new
  end

  def cancel
    @page = Page.find(params[:page_id])
    render :cancel
  end

  private

  def set_page
    @page = Page.find(params[:page_id])
  end

  def set_block
    @block = @page.blocks.find(params[:id])
  end

  def block_params
    params.require(:block).permit(:blockable_type, :content, :level)
  end

  def blockable_params
    case @block.blockable_type
    when 'Block::Text'
      { content: block_params[:content] }
    when 'Block::Heading'
      { content: block_params[:content], level: block_params[:level] }
    else
      {}
    end
  end
end 