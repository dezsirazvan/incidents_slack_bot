class IncidentsController < ApplicationController
  def index
    @sort_by = params[:sort_by] || 'title'
    @order = params[:order] || 'asc'

    @incidents = Incident.order("#{@sort_by} #{@order}")

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end
end
