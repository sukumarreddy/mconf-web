# -*- coding: utf-8 -*-
# This file is part of Mconf-Web, a web application that provides access
# to the Mconf webconferencing system. Copyright (C) 2010-2012 Mconf
#
# This file is licensed under the Affero General Public License version
# 3 or later. See the LICENSE file.

class RegistrationsController < Devise::RegistrationsController
  layout 'no_sidebar'

  def new
    @event_id = params[:user][:special_event_id] if params[:user]
  end

  def edit
    redirect_to edit_user_path(current_user)
  end

end

