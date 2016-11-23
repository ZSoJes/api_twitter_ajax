$(document).ready(function() {
   var screen_ancho = screen.availWidth;
    if ($(window).width() < screen_ancho/2 ){
      $(".head").animate({ opacity: 0 },0);
      $(".boton_flotante").animate({ opacity: 0 },0);
    }

  $("form").on("submit",function(event){
    if ($("input[type=text]").val() == ""){
        event.preventDefault();
        $("#myModal").css("display","block");
    }
  });


//  enviar tuit :::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  $("form#twitter_handle").on("submit",function(event){
        event.preventDefault();
    if ($("#tuit").val() != ""){
        var url = $("#twitter_handle").attr( "action" );
      $.post(url,$("form#twitter_handle").serialize() , function(data){
        console.log(data);
      });
      $("#myModal h2").text("Mensaje enviado");
      $(".spinner-2").fadeIn(1000).fadeOut(4000);
      $("#myModal").delay(4000).fadeIn(500);
      $("#tuit").val("");
    }
    else
    {
      $("#myModal h2").text("No dejes esta caja vacia");
      $("#myModal").css("display","block");
    }
  });
//  enviar tuit :::::::::::::::::::::::::::::::::::::::::::::::::::::::::


    $("button.boton_flotante").click(function(event){
      event.preventDefault();
      $(".spinner-2").fadeIn(1000).fadeOut(6000);
      var url = $("a").attr( "href" );
      $.post(url , $("form#twitter_handle").serialize(), function(data){
        console.log(data);
        $("#nuevo_tuit").html(data);
      });
    });

  $("span.close").click(function(){
      $("#myModal").css("display","none");
  });

  $(window).resize(function(){
    //aqui el codigo que se ejecutara cuando se redimencione la ventana
     var ancho=$(window).width();
    if (ancho < screen_ancho/2 ){
      $(".head").animate({ opacity: 0 },0);
      $(".boton_flotante").animate({ opacity: 0 },0);
    }else{
      $(".head").animate({ opacity: 1 },500);
      $(".boton_flotante").animate({ opacity: 1 },500);
    }
  });
});
