task sample_data: :environment do 
  starting = Time.now

  p "Creating sample data"

  if Rails.env.development?
    FollowRequest.delete_all
    Comment.delete_all
    Like.delete_all
    Photo.delete_all
    User.delete_all
  end

  log_in_name = Array.new

  for a in 1..10
    log_in_name << Faker::Name.unique.first_name
  end

  
  log_in_name << "Jack"
  log_in_name << "Vinny"
  
  
  log_in_name.each do |username|
    
    u = User.create(
      username: username.downcase,
      password: "123456",
      email: "#{username}@gmail.com",
      private: [true, false].sample
    )

    
  end

  

  all_users = User.all

  all_users.each do |request_sender|
    
    flag = 0

    while flag == 0
      request_recipient = all_users.sample
      if request_sender.username != request_recipient.username 
        flag = 1
      end
    end 
    
    #first user sends request to second
    request_sender.sent_follow_requests.create(
      recipient: request_recipient,
      status: FollowRequest.statuses.values.sample
    )

    #second user sends request to second
    request_recipient.sent_follow_requests.create(
      recipient: request_sender,
      status: FollowRequest.statuses.values.sample
    )
    
    #old code:
    #fol_req = FollowRequest.create(
      #recipient_id: request_recipient.id,
      #sender_id: request_sender.id
    #)   
  end


  #create photos

  all_users.each do |user|
    rand(15).times do
      photo = user.own_photos.create(
        caption: Faker::Quote.jack_handey,
        image: "https://picsum.photos/id/#{rand(30)}/500/500"
      )

      

      user.followers.each do |follower|
        if rand < 0.5
          photo.fans << follower
        end

        if rand < 0.25
          photo.comments.create(
            body: Faker::Quote.jack_handey,
            author: follower
          )
        end
      end
    end
  
  end
  
  ending = Time.now

  p "It took #{(ending - starting).to_i} seconds to create sample data."
  p "There are now #{User.count} users."
  p "There are now #{FollowRequest.count} follow requests."
  p "There are now #{Photo.count} photos."
  p "There are now #{Like.count} likes."
  p "There are now #{Comment.count} comments."

end