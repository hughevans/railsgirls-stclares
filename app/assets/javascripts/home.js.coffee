# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

class App
  constructor: ->
    @mapCanvas = $('#map-canvas')
    @mapCenter = new google.maps.LatLng(-35.3183171, 149.1324608)
    @latField = $('#lat')
    @lonField = $('#lon')
    @activities = []
    @activityMarkers = []
    @map = new google.maps.Map @mapCanvas.get(0),
      center: @mapCenter
      zoom: 16
      mapTypeId: google.maps.MapTypeId.HYBRID
      scrollwheel: false

    @addActvities()

  setUserLocation: ->
    if navigator.geolocation
      navigator.geolocation.getCurrentPosition (position) =>
        @map.setCenter new google.maps.LatLng(position.coords.latitude, position.coords.longitude)

  dropMarker: ->
    @marker.setMap(null) if @marker?

    @marker = new google.maps.Marker
      map: @map
      draggable: true
      animation: google.maps.Animation.DROP
      position: @map.getCenter()

    google.maps.event.addListener @marker, 'dragend', => @updateLatLon()

    @updateLatLon()

  updateLatLon: ->
    @latField.val @marker.getPosition().lat()
    @lonField.val @marker.getPosition().lng()

  addActvities: ->
    $.getJSON '/activities', (data) =>
      for activity, index in data
        do (index) =>
          activityMarker =  new google.maps.Marker
            map: @map
            animation: google.maps.Animation.DROP
            position: new google.maps.LatLng(activity.lat, activity.lon)

          google.maps.event.addListener activityMarker, 'click', =>
            @openWindow index

          @activityMarkers.push activityMarker
          @activities.push activity

  openWindow: (index) ->
    @infoWindow.close() if @infoWindow?
    console.log index
    console.log @activities

    @infoWindow = new google.maps.InfoWindow
      content: """
        <h3>#{@activities[index].name}</h3>
        <em>#{@activities[index].created_at}</em>
        <hr>
        <p>#{@activities[index].description}</p>
      """

    @infoWindow.open @map, @activityMarkers[index]

$ ->
  window.app = new App

  $('#locate-me').click ->
    app.setUserLocation()

  $('#drop-pin').click ->
    app.dropMarker()
    $('#activity-form').show()
