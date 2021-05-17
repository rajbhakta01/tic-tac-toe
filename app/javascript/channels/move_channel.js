import consumer from "./consumer"
var gm = [];
var move_player = "Player 1";
consumer.subscriptions.create("MoveChannel", {
  connected(data) {
    console.log("Connected to the game!");
    console.log("game:" + gm);
    if(gm.length > 0){
      for(var i=0;i<8;i++){
        $("#"+i).html("<p>" + gm[i] + "<p>");
      }
    }
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    console.log("Recieving:")
    // var element = data.move
    // var fill_value
    // if(data.player == 1){
    //   fill_value = "X"
    // }else{
    //   fill_value = "O"
    // }
    // if(!Boolean(gm[element])){
    //   $("#"+element).html("<p>" + fill_value + "<p>");
    //   gm[element] = fill_value;
    // }
    // console.log(gm);
    if(data.gm){
      gm = data.gm;
      console.log(gm);
      for(var i = 0;i< gm.length ;i++){
        if(gm[i]=="X" || gm[i]=="O"){
          $("#"+i).html("<p>" + gm[i] + "<p>")
        }
      }
    }
    if(move_player =="Player 1"){
      $("#move_text").html("Player 2")
      move_player = "Player 2"
    }else{
      $("#move_text").html("Player 1")
      move_player = "Player 1"
    }
    if(data.status){
      alert(data.msg);
      for(var i = 0;i< 9 ;i++){
        if(gm[i]=="X" || gm[i]=="O"){
          $("#"+i).html("")
        }
      }
    }
    // Called when there's incoming data on the websocket for this channel
  },
});
