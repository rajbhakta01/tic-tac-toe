class HomeController < ApplicationController
  def index
    puts"all player: #{$player.length}"
    if session[:player].nil?
      if $player.length == 0
        @player_no = 1
      else
        @player_no = 2
      end
      $player << @player_no
      session[:player] = @player_no
    end
  end

  def move
    if session[:player] == 1
      key = "X"
    else
      key = "O"
    end
    $gm[Integer(params[:move])] = key
    ActionCable.server.broadcast "move_channel", gm: $gm
    if session[:player] == 1
      $move_player = "Player 2"
    else
      $move_player = "Player 1"
    end
    n = 3
    cnt=0
    puts $gm

    win = false
    cnt_diag = 0
    cnt_diag2 = 0

    for i in 0..(n-1)
      win = false
      cnt_h = 0
      for j in 1..(n-1)
        # This loop for check user win horizontally.
        if $gm[(i*n)] != nil and $gm[i*n]==$gm[(i*n)+j]
          cnt_h = cnt_h + 1;
        end
      end

      cnt_v = 0
      for j in 1..(n-1)
        # This loop for check user win vertically.
        if $gm[i] != nil and $gm[i]==$gm[(j*n)+i]
          cnt_v = cnt_v + 1;
        end
      end

      if $gm[0] != nil and $gm[0]==$gm[(i*n)+i]
        cnt_diag = cnt_diag + 1;
      end

      if $gm[n-1] != nil and $gm[n-1]==$gm[(i*(n-1))+(n-1)]
        cnt_diag2 = cnt_diag2 + 1;
      end

      if cnt_h==(n-1) or cnt_v==(n-1)
        ActionCable.server.broadcast "move_channel", status: "win", msg: "Player #{session[:player]} is win."
        win = true
        $gm = []
        break
      end
    end
    if cnt_diag==n or cnt_diag2==n
      win = true
      $gm=[]
      ActionCable.server.broadcast "move_channel", status: "win", msg: "Player #{session[:player]} is win."
    end

    if !win
      if $gm.length == ((n*n)) and !$gm.any?{ |e| e.nil? }
        $gm=[]
        ActionCable.server.broadcast "move_channel", status: "Draw", msg: "Game is draw."
      end
    end

    render json:{ status: "OK" }
  end
end
