describe "Users API", type: :request do
  describe "POST /users" do
    it 'creates new user' do
      email = "jane@example.com"
      password = "password"
      post "/users", params: { user: { email: email, password: password, password_confirmation: password } }
      expect(response).to have_http_status(:created)
      expect(User.last.email).to eq(email)
      response_body = JSON.parse(response.body)
      expect(response_body["token"]).to be_a String
      expect(response_body["user"]).to eq(email)
    end

    it 'rejects incorrect attributes' do
      email = "wrong_email"
      password = "password"
      confirmation = "wrong_confirmation"
      post "/users", params: { user: { email: email, password: password, password_confirmation: confirmation } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(User.count).to eq(0)
    end
  end

  describe "POST /users/login" do
    it 'logs in existing user' do
      user = create(:user)
      post "/users/login", params: { user: { email: user.email, password: user.password } }
      expect(response).to have_http_status(:ok)
      response_body = JSON.parse(response.body)
      expect(response_body["token"]).to be_a String
      expect(response_body["user"]).to eq(user.email)
    end

    it 'rejects incorrect credentials' do
      user = create(:user)
      post "/users/login", params: { user: { email: user.email, password: 'wrong_password' } }
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
