namespace :dev do

task fake: [:fake_user, :fake_post, :fake_comment, :fake_collect, :fake_friendship]

  task fake_user: :environment do
    User.where.not(role: "admin").destroy_all
    20.times do |i|
      name = FFaker::Name::first_name
      user = User.new(
        name: name,
        email: "#{name}@example.com",
        password: "12345678",
        intro: FFaker::Lorem::sentence(50),
        avatar: File.open(Rails.root.join("public/avatar/user#{rand(1..20)}.jpg")),
      )
      user.save!
      puts user.name
    end
  end


  task fake_post: :environment do
    Post.destroy_all
    200.times do |i|
      authority_list = ["all", "friend", "myself"]
      # status = ["pending", "publish"].sample
      status = ["draft", "post"].sample
      user = User.all.sample
      post = Post.create!(
        title: FFaker::Lorem.sentence,
        content: FFaker::Lorem.paragraph(30),
        user: user,
        image: File.open(Rails.root.join("public/post_image/#{rand(1..10)}.jpg")),
        authority: authority_list.sample
      )
      post.save
      post.categories_posts.create(category: Category.all.sample)
    end
    puts "have created fake posts"
    puts "now you have #{Post.count} posts data"
  end


  task fake_comment: :environment do
    Comment.destroy_all
    100.times do
      user = User.all.sample
      post = Post.all.sample
      Comment.create!(
        user: user,
        post: post,
        content: FFaker::Lorem.sentence
      )
      # if !View.where(user_id: user.id, post_id: post.id).present?
      #   View.create(
      #     post: post,
      #     user: user
      #   )
      # end
    end
    puts "have created fake comments"
    puts "now you have #{Comment.count} comments data"
    # puts "now you have #{View.count} views data"
  end



  task fake_collect: :environment do
    Collect.destroy_all
       50.times do
       Collect.create(
         user: User.all.sample,
         post: Post.all.sample
       )
     end
    puts "have created fake likes"
    puts "now you have #{Collect.count} collects data"
  end


    task fake_friendship: :environment do
      Friendship.destroy_all
      25.times do |i|
      status = ["pending", "approved"].sample
      Friendship.create(
        user: User.all.sample,
        friend: User.all.sample,
        status: status
        )
      end
      puts "have created fake friends"
      puts "now you have #{Friendship.count} friends data"
    end

end
