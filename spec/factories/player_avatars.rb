# == Schema Information
#
# Table name: player_avatars
#
#  id                 :bigint(8)        not null, primary key
#  name               :string(50)       not null
#  image_file_name    :string
#  image_content_type :string
#  image_file_size    :integer
#  image_updated_at   :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

FactoryBot.define do
  factory :player_avatar do
    name  'Luke Skywalker'
    image_file_name 'luke-skywalker.jpg'
    image_content_type 'image/jpeg'
    image_file_size 2
    image_updated_at Time.new(2015, 8, 18).utc
  end
end
