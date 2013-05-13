# encoding: utf-8
#--
#   Copyright (C) 2013 Gitorious AS
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU Affero General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU Affero General Public License for more details.
#
#   You should have received a copy of the GNU Affero General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.
#++
require "use_cases/create_user"
require "commands/activate_user_command"
require "validators/new_user_validator"

class CreateSystemUserCommand
  def execute(user)
    user.save!
    user.accept_terms!
    user
  end

  def build(params)
    password = User.generate_random_password
    User.new(params.to_hash.merge({
          :terms_of_use => true,
          :password => password,
          :password_confirmation => password
        }))
  end
end

class CreateSystemUser
  include UseCase

  def initialize
    input_class(NewUserParams)
    step(CreateSystemUserCommand.new, :validator => NewUserValidator)
    step(ActivateUserCommand.new, :builder => lambda { |user| user })
  end
end
