class SessionsController < ApplicationController

  def create
    identity = Identity.find_or_create_with_omniauth(auth)

    if signed_in?
      if identity.user == current_user
        redirect_to root_url, :notice => "You already linked: #{identity}"
      else
        identity.user = current_user
        identity.save
        redirect_to root_url, :notice => "Successfully linked: #{identity}"
      end
    else
      if identity.user.present?
        self.current_user = identity.user
        redirect_to root_url, :notice => "Signed in with: #{identity}"
      else
        if identity.provider == 'moves'
          user = User.find_or_create_with_moves(identity)
          identity.user = user
          identity.save
          redirect_to root_url, :notice => "Successfully linked: #{identity}"
        else
          redirect_to root_url, :notice => 'You must login with Moves'
        end
      end
    end
  end

  def destroy
    self.current_user = nil
    redirect_to root_url, :notice => 'Signed out!'
  end

protected

  def auth
    request.env['omniauth.auth']
  end

end
