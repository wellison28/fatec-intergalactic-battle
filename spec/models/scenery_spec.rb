require 'rails_helper'

RSpec.describe Scenery, type: :model do
  include ActionDispatch::TestProcess

  it 'has a valid factory' do
    image = fixture_file_upload('scenaries/images/background.jpg', 'image/jpeg')
    expect(create(:scenery, image: image)).to be_valid
  end

  describe '#name' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_most(50) }
  end

  describe '#rows' do
    it { is_expected.to validate_presence_of(:rows) }

    it do
      is_expected.to validate_numericality_of(:rows).
        only_integer.is_greater_than_or_equal_to(10)
    end
  end

  describe '#columns' do
    it { is_expected.to validate_presence_of(:columns) }

    it do
      is_expected.to validate_numericality_of(:columns).
        only_integer.is_greater_than_or_equal_to(10)
    end
  end

  describe '#image' do
    it { is_expected.to respond_to(:image) }
    it { is_expected.to validate_attachment_size(:image).less_than(2.megabyte) }

    it do
      is_expected.to validate_attachment_content_type(:image).allowing(
        'image/jpg',
        'image/jpeg'
      )
    end
  end
end