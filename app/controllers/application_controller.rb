# -*- coding: utf-8 -*-
# This file is part of Mconf-Web, a web application that provides access
# to the Mconf webconferencing system. Copyright (C) 2010-2012 Mconf
#
# This file is licensed under the Affero General Public License version
# 3 or later. See the LICENSE file.

# Filters added to this controller apply to all controllers in the application.
# Likewse, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Be sure to include AuthenticationSystem in Application Controller instead
  include SimpleCaptcha::ControllerHelpers
  include LocaleControllerModule

  # alias_method :rescue_action_locally, :rescue_action_in_public

  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '29d7fe875960cb1f9357db1445e2b063'

  # Don't log passwords
  config.filter_parameter :password, :password_confirmation

  # Handle errors - error pages
  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception, :with => :render_500
    rescue_from ActiveRecord::RecordNotFound, :with => :render_404
    rescue_from ActionController::RoutingError, :with => :render_404
    rescue_from ActionController::UnknownController, :with => :render_404
    rescue_from ::AbstractController::ActionNotFound, :with => :render_404
    rescue_from CanCan::AccessDenied, :with => :render_403
  end

  def space
    @space ||= Space.find_with_param(params[:space_id])
  end

  def institution
    @institution ||= Institution.find_by_permalink(params[:institution_id])
  end

  # Splits a comma separated list of emails into a list of emails without trailing spaces
  def split_emails email_string
    email_string.split(/[\s,;]/).select { |e| !e.empty? }
  end

  def valid_email? email
    /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i.match(email)
  end

  def current_ability
    @current_ability ||= Abilities.ability_for(current_user)
  end

  # Where to redirect to after sign in with Devise
  def after_sign_in_path_for(resource)
    stored_location_for(resource) || home_path
  end

  # overriding bigbluebutton_rails function
  def bigbluebutton_user
    if current_user && current_user.is_a?(User)
      current_user
    else
      nil
    end
  end

  def bigbluebutton_role(room)
    # TODO: temporary guest role that only exists in mconf-live
    guest_role = :attendee
    if defined?(BigbluebuttonRoom.guest_support) and
        BigbluebuttonRoom.guest_support
      guest_role = :guest
    end

    # when a user or a space is disabled the owner of the room is nil (because when trying to find
    # the user/room only the ones that are *not* disabled are returned) so we check if the owner is
    # not present we assume the room cannot be accessed
    # TODO: not the best solution, we should actually find a way to check if owner.disabled is true
    return nil unless room.owner

    unless bigbluebutton_user.nil?

      # user rooms
      if room.owner_type == "User"
        if room.owner.id == current_user.id
          # only the owner is moderator
          :moderator
        else
          if room.private
            :password # ask for a password if room is private
          else
            guest_role
          end
        end

      # space rooms
      elsif room.owner_type == "Space"
        space = Space.find(room.owner.id)
        if space.users.include?(current_user)
          # space members are moderators
          :moderator
        else
          if room.private
            :password
          else
            guest_role
          end
        end
      end

    # anonymous users
    else
      if room.private?
        :password
      else
        guest_role
      end
    end
  end

  def bigbluebutton_can_create?(room, role)
    can_create = current_user ? current_user.can_create_meeting?(room) : false
    if can_create
      # if the user can create the meeting but cannot record, we make sure the
      # record flag is not set before the room is created
      if bigbluebutton_user.nil? or not
          bigbluebutton_user.respond_to?(:"can_record_meeting?") or not
          bigbluebutton_user.can_record_meeting?(room, role)
        room.update_attribute(:record, false)
      end
      true
    else
      false
    end
  end

  # This method is the same as space, but raises error if no Space is found
  # TODO: do we really need this now cancan loads the resources?
  def space!
    space || raise(ActiveRecord::RecordNotFound)
  end

  helper_method :space, :space!

  def webconf_room!
    @webconf_room = @space.bigbluebutton_room
    if @webconf_room
      begin
        @webconf_room.fetch_meeting_info
      rescue Exception
      end
    else
      raise(ActiveRecord::RecordNotFound)
    end
    @webconf_room
  end

  # TODO: it's pretty annoying to show this in every page
  before_filter :not_activated_warning
  def not_activated_warning
    if user_signed_in? && !current_user.confirmed?
      flash[:notice] = t('user.not_activated', :url => new_user_confirmation_path)
    end
  end

  before_filter :set_time_zone
  def set_time_zone
    if current_user and current_user.is_a?(User) and not current_user.timezone.blank?
      Time.zone = current_user.timezone
    elsif current_site and not current_site.timezone.blank?
      Time.zone = current_site.timezone
    else
      # If everything fails defaults to UTC
      Time.zone = "UTC"
    end
  end

  # Locale as param
  before_filter :set_current_locale

  private

  def accept_language_header_locale
    request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first.to_sym if request.env['HTTP_ACCEPT_LANGUAGE'].present?
  end

  def render_404(exception)
    # FIXME: this is never triggered, see the bottom of routes.rb
    @exception = exception
    render :template => "/errors/error_404", :status => 404, :layout => "error"
  end

  def render_500(exception)
    @exception = exception
    pp exception
    render :template => "/errors/error_500", :status => 500, :layout => "error"
  end

  def render_403(exception)
    @exception = exception
    render :template => "/errors/error_403", :status => 403, :layout => "error"
  end

end
