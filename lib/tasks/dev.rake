namespace :dev do

  task fake_user: :environment do
    User.destroy_all
    20.times do |i|
      name = FFaker::Name::first_name
      file = File.open("#{Rails.root}/public/avatar/user#{i+1}.jpg")

      user = User.new(
        name: name,
        email: "#{name}@example.co",
        password: "12345678",
        intro: FFaker::Lorem::sentence(30),
        avatar: file
      )

      user.save!
      puts user.name
    end
  end


  task fake_post: :environment do
    Post.destroy_all

     User.all.each do |user|
       rand(30).times do |i|
         user.posts.create!(
           description: FFaker::Lorem.sentence,
           user: User.all.sample,
           category: Category.all.sample
         )


       end
     end
    puts "have created fake posts"
    puts "now you have #{Post.count} posts data"
  end


  task fake_comment: :environment do
     Post.all.each do |post|
       3.times do |i|
         post.comments.create!(
           content: FFaker::Lorem.sentence,
           user: User.all.sample
         )
       end
     end
    puts "have created fake comments"
    puts "now you have #{Comment.count} comments data"
  end




  task fake_like: :environment do
    Like.destroy_all
     Post.all.each do |post|
       rand(30).times do |i|
         post.likes.create!(
           user: User.all.sample,
           tweet: Post.all.sample
         )
       end
     end
    puts "have created fake likes"
    puts "now you have #{Like.count} likes data"
  end

end
