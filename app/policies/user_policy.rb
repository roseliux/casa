class UserPolicy < ApplicationPolicy
  def update_volunteer_email?
    is_admin?
  end

  def unassign_case?
    admin_or_supervisor?
  end

  alias_method :activate?, :unassign_case?

  def deactivate?
    activate?
  end

  def update_supervisor_email?
    is_admin? || record == user
  end

  def update_supervisor_name?
    update_supervisor_email?
  end

  def edit_name?(viewed_user)
    is_admin? || viewed_user == user
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      case user
      when CasaAdmin, Supervisor # scope.in_casa_administered_by(user)
        scope.by_organization(@user.casa_org)
      when Volunteer
        scope.where(id: user.id)
      else
        raise "unrecognized role #{@user.type}"
      end
    end

    alias_method :edit?, :resolve
  end
end
