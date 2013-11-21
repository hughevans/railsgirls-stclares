# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

class App
  constructor: ->
    @mapCanvas = $('#map-canvas')
    @mapCenter = new google.maps.LatLng(-35.3183171, 149.1324608)
    @latField = $('#lat')
    @lonField = $('#lon')
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

    # @updateLatLon()

  updateLatLon: ->
    console.log 'Here'
    @latField.val @marker.getPosition().lat()
    @lonField.val @marker.getPosition().lng()

  addActvities: ->
    $.getJSON '/activities', (data) =>
      for activity, index in data
        activityMarker = new google.maps.Marker
          map: @map
          animation: google.maps.Animation.DROP
          position: new google.maps.LatLng(activity.lat, activity.lon)

        infoWindow = new google.maps.InfoWindow
          content: """
            <h3>#{activity.name}</h3>
            <em>#{activity.created_at}</em>
            <hr>
            <p>#{activity.description}</p>
          """

        google.maps.event.addListener activityMarker, 'click', =>
          infoWindow.open @map, activityMarker

$ ->
  app = new App

  $('#locate-me').click ->
    app.setUserLocation()

  $('#drop-pin').click ->
    app.dropMarker()
    $('#activity-form').show()
