function iniciarMap(){
    var coord = {lat:20.05305706448482 ,lng: -99.3492785313313};
    var map = new google.maps.Map(document.getElementById('map'),{
      zoom: 10,
      center: coord
    });
    var marker = new google.maps.Marker({
      position: coord,
      map: map
    });
}