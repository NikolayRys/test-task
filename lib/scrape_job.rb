class ScrapeJob
  ScrapeError = Class.new(StandardError)

  attr_reader :ids

  def initialize(ids)
    @ids = ids
  end

  def perform
    remaining(ids).each do |image|
      mime_type = get_mime_type(image.url)
      if mime_type && mime_type.include?('image')
        image.update(mime_type: mime_type)
      end
    end

    remaining_ids = remaining(ids).pluck(:id)
    raise ScrapeError, "Not processed: #{remaining_ids.inspect}" if remaining_ids.any?
  end

  def failure(job)
    remaining(job.payload_object.ids).destroy_all
  end

  private

  def remaining(ids)
    Image.not_ready.where(id: ids)
  end

  def get_mime_type(url)
    HTTParty.get(url).headers['content-type']
  rescue HTTParty::Error, Errno::ECONNREFUSED
    nil
  end

end
