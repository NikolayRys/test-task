describe TokenService do
  subject { described_class }
  describe '#encode' do
    it 'encodes payload into token' do
      expect(subject.encode(user_id: 1)).to be_a String
    end
  end

  describe '#decode' do
    it 'decodes correct token' do
      token = "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.TilY2O4_CZEU1mg8FKOtYEOEq3NZBYKgsbXhmXcZIk4"
      expect(subject.decode(token)[:user_id]).to eq(1)
    end

    it 'raises error on invalid token' do
      token = "invalid"
      expect{subject.decode(token)}.to raise_error(TokenError)
    end
  end
end
