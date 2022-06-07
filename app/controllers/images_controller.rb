class ImagesController < ApplicationController
  include Secured

  def upload
    if params[:urls].blank?
      render json: { error: "Array if urls is required" }, status: :bad_request
      return
    end

    ids = params[:urls].map { |url| Image.find_or_create_by(url: url).id }

    Delayed::Job.enqueue(ScrapeJob.new(ids))

    render json: {ids: ids}, status: :created
  end
end
