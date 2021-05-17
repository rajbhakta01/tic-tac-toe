module ApplicationCable
  class Connection < ActionCable::Connection::Base
      identified_by :current_user

      def connect
          # self.current_user = find_player
          # puts "********************"
          # logger.add_tags 'ActionCable', current_user
      end

      protected
      def find_player
        verified_user = cookies.signed['player']
        if verified_user && cookies.signed['user.expires_at'] > Time.now
          verified_user
        else
          if $cable_player.length == 0
            @player_no = 2
          else
            @player_no = 1
          end
          puts "======================="
          puts @player_no
          $cable_player << @player_no
          cookies[:player] = @player_no
          verified_user = cookies[:player]
          verified_user
        end
      end
  end
end
