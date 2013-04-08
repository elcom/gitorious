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
require "use_case"

class CloneRepository
  include UseCase

  def initialize(app, repository, user)
    input_class(CloneRepositoryInput)
    add_pre_condition(UserRequired.new(user))
    add_pre_condition(CommitsRequired.new(repository))
    add_pre_condition(RepositoryRateLimiting.new(user))
    add_pre_condition(AuthorizationRequired.new(app, user, repository))
    command = CloneRepositoryCommand.new(app, repository, user)
    step(command, :validator => RepositoryValidator)
  end
end
