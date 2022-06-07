describe ScrapeJob do
  it 'extracts image mime type from urls' do
    # Using real requests for testing, to keep the scope of the task down.
    # In real life, I would use a stubbed request with a library like.
    image_1 = Image.create(url: "https://picsum.photos/200/300")
    image_2 = Image.create(url: "https://picsum.photos/300/200")

    job = ScrapeJob.new([image_1.id, image_2.id])

    enqueued = Delayed::Job.enqueue(job)
    expect{enqueued.invoke_job}.to_not raise_error

    expect(image_1.reload.mime_type).to eq("image/jpeg")
    expect(image_2.reload.mime_type).to eq("image/jpeg")
  end

  it 'fails if some images are not retrieved' do
    image = Image.create(url: "https://picsum.photos/200/300")
    other_object = Image.create(url: "https://example.com/")
    wrong_url = Image.create(url: "wrong_url")

    job = ScrapeJob.new([image.id, other_object.id, wrong_url.id])

    enqueued = Delayed::Job.enqueue(job)
    expect{enqueued.invoke_job}.to raise_error(ScrapeJob::ScrapeError)

    expect(image.reload.mime_type).to eq("image/jpeg")
    expect(other_object.reload.mime_type).to be_nil
    expect(wrong_url.reload.mime_type).to be_nil
    expect(Image.not_ready.count).to eq(2)

    enqueued.hook(:failure)
    expect(Image.not_ready.count).to eq(0)
    expect{other_object.reload.mime_type}.to raise_error(ActiveRecord::RecordNotFound)
    expect{wrong_url.reload.mime_type}.to raise_error(ActiveRecord::RecordNotFound)
  end
end
