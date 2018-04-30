namespace :dev do

task fake: [:fake_user, :fake_post, :fake_comment, :fake_collect, :fake_friend]

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
     User.all.each do |user|
       rand(20).times do |i|
         user.posts.create!(
           user: User.all.sample,
           title: FFaker::Lorem.sentence(10),
           content: FFaker::Lorem.sentence,
           image: File.open(Rails.root.join("public/post_image/#{rand(1..10)}.jpg")),
           public: [true, true, true, false].sample,
           authority: ["myself", "friend", "all"].sample
         )
         post.save
         post.posts_categories.create(category: Category.all.sample)
       end
     end
    puts "have created fake posts"
    puts "now you have #{Post.count} posts data"
  end


  task fake_comment: :environment do
    Comment.destroy_all
    100.times do
      user = User.all.sample
      post = Post.readable_posts(user).open_public.sample
      post.comments.create!(
        user: user,
        content: FFaker::Lorem.sentence
      )
    end

    puts "have created fake comments"
    puts "now you have #{Comment.count} comments data"
  end



  task fake_collect: :environment do
    Collect.destroy_all
       rand(100).times do |i|
         post.collects.create!(
           user: User.all.sample,
           post: Post.all.sample
         )
       end

    puts "have created fake likes"
    puts "now you have #{Collect.count} collects data"
  end


    task fake_friend: :environment do
  
      60.times do
        group1 = User.all.sample
        group2 = User.where.not(id: user1.id).sample
        unless group1.unconfirm_friend?(group2) || user1.request_friend?(group2)
          user1.unconfirm_friends.create!(friend: group2)
          puts "#{group1.name} invite #{group2.name}"
        end
      end
      30.times do
        friendship = Friendship.where(status: false).sample
        friendship.update(status: true)
        puts "#{friendship.user_id} accept friend to #{friendship.friend_id}"
      end
    end

end
