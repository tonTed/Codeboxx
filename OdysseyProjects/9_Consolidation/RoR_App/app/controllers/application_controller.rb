class ApplicationController < ActionController::Base
    helper :all
    protect_from_forgery prepend: true, with: :exception
    skip_before_action :verify_authenticity_token
    protected
    #Jorge - redirecto to home after signin or signup
    def after_sign_in_path_for(resource)
        '/home'
    end

    def after_sign_up_path_for(resource)
        '/home' 
    end

    def is_employee?
        if !current_user || current_user.has_role?('employee') == false
            redirect_to '/home', alert: "You need to be a employee"
        elsif current_user.has_role? :employee
        else
            redirect_to '/home', alert: "You need to be a employee"
        end
    end
end
