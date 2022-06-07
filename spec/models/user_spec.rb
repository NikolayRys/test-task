describe User do
  it 'supports bcrypt' do
    User.create!(email: 'john@example.com', password: 'password', password_confirmation: 'password')
    expect(User.find_by(email: 'john@example.com').authenticate('password')).to be_truthy
  end
end
