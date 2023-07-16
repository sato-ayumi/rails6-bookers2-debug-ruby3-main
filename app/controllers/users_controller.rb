class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    @current_user_entry = Entry.where(user_id: current_user.id)
    @user_entry = Entry.where(user_id: @user.id)
    # 他のユーザーのプロフィールページを表示している場合
    unless @user.id == current_user.id
      # 二人のルームがあるか一つずつ確認
      @is_room = @current_user_entry.any? { |cu| @user_entry.any? { |u| cu.room_id == u.room_id } }
      unless @is_room
        @room = Room.new
        @entry = Entry.new
      end
    end
    @books = @user.books
    # @today_book = @books.created_today
    # @yesterday_book = @books.created_yesterday
    # @this_week_book = @books.created_this_week
    # @last_week_book = @books.created_last_week
    @book = Book.new
  end

  def index
    @users = User.all
    @book = Book.new
    @user = current_user
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user.id), notice: "You have updated user successfully."
    else
      render 'edit'
    end
  end

  def search
    @user = User.find(params[:user_id])
    @books = @user.books
    @book = Book.new
    if params[:created_at] == ""
      @search_book = "日付を選択してください"
    else
      create_at = params[:created_at]
      @search_book = @books.where(['created_at LIKE ? ', "#{create_at}%"]).count
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
