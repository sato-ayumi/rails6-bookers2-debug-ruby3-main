class MessagesController < ApplicationController
  before_action :authenticate_user!, only: [:show, :create]
  before_action :reject_non_related, only: [:show]
  
  def show
    #チャットする相手
    @user = User.find(params[:id])
    #ログイン中のユーザーの部屋情報を全て取得
    rooms = current_user.entries.pluck(:room_id)
    #その中にチャットする相手とのルームがあるか確認
    user_rooms = Entry.find_by(user_id: @user.id, room_id: rooms)
    
    #ユーザールームがある場合
    unless user_rooms.nil?
      #ユーザー（自分と相手）と紐づいているroomを代入
      @room = user_rooms.room
    else
      @room = Room.new
      @room.save
      #自分の中間テーブルを作成
      Entry.create(user_id: current_user.id, room_id: @room.id)
      #相手の中間テーブルを作成
      Entry.create(user_id: @user.id, room_id: @room.id)
    end
    #チャットの一覧
    @messages = @room.chats
    #チャットの投稿
    @message = Message.new(room_id: @room.id)
  end
  
  def create
    @message = current_user.messages.new(message_params)
    @room = @message.room
    @messages = @room.messages
    render :validater unless @message.save
  end
  
  private
  
  def message_params
    params.require(:chat).permit(:message, :room_id)
  end
  
  # 相互フォローしていない場合
  def regect_non_related
    user = User.find(params[:id])
    unless current_user.following?(user) && user.following?(current_user)
      redirect_to books_path
    end
  end
  
end
