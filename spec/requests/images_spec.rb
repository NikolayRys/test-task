describe "Users API", type: :request do
  describe "POST /upload" do
    let(:user) { create(:user) }

    it 'creates new empty image records' do
      post "/upload",
           params: { urls: %w[https://picsum.photos/200/300 wrong_url] },
           headers: { "Authorization" => TokenService.encode(user_id: user.id) }

      expect(response).to have_http_status(:created)
      expect(Image.first.url).to eq("https://picsum.photos/200/300")
      expect(Image.last.url).to eq("wrong_url")
    end

    it 'rejects if urls are missing' do
      post "/upload", headers: { "Authorization" => TokenService.encode(user_id: user.id) }

      expect(response).to have_http_status(:bad_request)
      expect(Image.count).to eq(0)
    end

    it 'rejects if unauthorized' do
      post "/upload", params: { urls: %w[https://picsum.photos/200/300 wrong_url] }

      expect(response).to have_http_status(:unauthorized)
      expect(Image.count).to eq(0)
    end
  end
end
