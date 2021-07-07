class Session < ApplicationRecord
    belongs_to :user

    enum status: [:in_active, :active]
    
    scope :active,-> {where(status: :active)}
    scope :for_token, -> (access_token) {where(access_token: access_token)}

    def self.get_new_session(user)
        acess_token_payload = {"data" => "#{user.id}#{Time.now}"}
        access_token = JWT.encode acess_token_payload, nil, 'none'
        session = Session.new(status: :active, user_id: user.id, access_token:  access_token)
        session.save
        session
    end

    def self.destroy(session)
        session.status = :in_active
        session.save
    end

    
end
