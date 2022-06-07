describe User do
  it 'supports bcrypt' do
    create(:user)
    expect(User.find_by(email: 'john@example.com').authenticate('password')).to be_truthy
  end
end
