class MailImage < Sequel::Model
  plugin :validation_helpers

  mount_uploader :photo, MailPhotoUploader

  dataset_module do
    def group_by_day
      self.all.group_by do |mail|
        mail.created_at.to_date
      end
    end
  end

  def validate
    super
    validates_presence :identifier
    validates_unique :identifier
    validates_presence :photo
  end
end

# Table: mail_images
# Columns:
#  id         | integer                     | PRIMARY KEY DEFAULT nextval('mail_images_id_seq'::regclass)
#  photo      | text                        |
#  created_at | timestamp without time zone |
#  identifier | text                        |
# Indexes:
#  mail_images_pkey           | PRIMARY KEY btree (id)
#  mail_images_identifier_key | UNIQUE btree (identifier)
