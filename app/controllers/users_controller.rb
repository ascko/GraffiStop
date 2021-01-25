class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update]
  before_action :correct_user,   only: [:edit, :update]







  resource_description do
    short "User API"
    description  <<EOF
User's controller description
EOF

  end



  def_param_group :user do
    param :user, Hash, :action_aware => true do
      param :name, String
      param :email, String
    end
  end


  api :GET, '/users', "Users' index"
  description <<EOF
    List users
EOF

  def index
    @users = User.paginate(page: params[:page], :per_page => 10)
  end

  api :GET, '/users/:id', "Gets user"
  returns :user, :desc => "The user"
  param :id, String, required: true, desc: "id of user"

  def show
    @user = User.find(params[:id])
    @locations = @user.locations.paginate(page: params[:page], :per_page => 8)
  end

  def new
    @user = User.new
  end
 
  api :POST, '/users', "Creates a new user"
  param :user, Hash, desc: "User data" do
    param :email, String, :required => true
    param :name, String
    param :password, String
    param :password_confirmation, String
  end
  description <<-EOF
    creates a new user
    EOF




  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Witamy w GraffiStop!"
      redirect_to root_url
    else
      render 'new'
    end
  end



  api :PUT, '/users/:id', "Updates user"
  param :id, String, required: true, desc: "id of user"
  param :user, Hash, desc: "User data" do
    param :email, String,  :required => false, :desc => "if E-Mail is changed we actually start reconfirmation"
    param :name, String,  :required => false
  end
  returns :user, code: 200, desc: 'User Object'
  description <<EOF
      updates user
EOF




  def update
    @user = User.find(params[:id]).update_attributes(user_params)
    if @user.errors.blank?
      redirect_to admin_users_path, :notice => "User updated successfully."
    end
  end


  api :DELETE, '/users/:id', "Removes user"
  param :id, String, required: true, desc: "id of user"
  returns :user, code: 204
  description <<EOF
      removes user
EOF


  def destroy
    @user.destroy
  end


  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

end
