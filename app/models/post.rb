class Post < ActiveRecord::Base

  belongs_to :user
  belongs_to :commentable , polymorphic: true

  has_attached_file :photo, :styles => { :display => "800>" },
                     #url: "/assets/posts/:id/:style/:basename.:extension",
                     #path: ":rails_root/public/assets/posts/:id/:style/:basename.:extension"
                     :storage => :dropbox,
                     :dropbox_credentials => Rails.root.join("config/dropbox.yml"),
                     :path => "Posts/:style/:id_:filename"  # Defaults to ":filename"
                     #:dropbox_options => {...}

  #validates_attachment_presence :photo
  validates_attachment_size :photo, less_than: 5.megabytes
  validates_attachment_content_type :photo, content_type: ['image/jpeg', 'image/png', 'image/gif']
  validates :post_type, inclusion: { in: ["link", "image"]}
  
  def type? type
  	post_type == type.to_s
  end

  def as_json(options={})
    options[:except] ||= [:user_id, :commentable_id, :commentable_type]
    json = super(options)
    json["username"] = self.user.username
    json
  end 

end