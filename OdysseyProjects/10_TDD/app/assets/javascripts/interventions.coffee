# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  $("#intervention_building_id").parent().hide()
  $("#intervention_battery_id").parent().hide()
  $("#intervention_column_id").parent().hide()
  $("#intervention_elevator_id").parent().hide()
  $("#intervention_elevator_id").val("null")
  $("#intervention_column_id").val("null")
  $("#intervention_battery_id").val("null")
  buildings = $('#intervention_building_id').html()
  batteries = $('#intervention_battery_id').html()
  columns = $('#intervention_column_id').html()
  elevators = $('#intervention_elevator_id').html()
  $('#intervention_customer_id').change ->
    $("#intervention_elevator_id").parent().hide()
    $("#intervention_column_id").parent().hide()
    $("#intervention_battery_id").parent().hide()
    customer = $("#intervention_customer_id :selected").text()
    options = $(buildings).filter("optgroup[label='#{customer}']").html()
    if options
      $("#intervention_building_id").html(options)
      $("#intervention_building_id").parent().show()
      $("#intervention_building_id").val("null")
    else
      $("#intervention_building_id").empty()
      $("#intervention_building_id").parent().hide()
  $('#intervention_building_id').change ->
    $("#intervention_elevator_id").parent().hide()
    $("#intervention_column_id").parent().hide()
    building = $("#intervention_building_id :selected").text()
    options = $(batteries).filter("optgroup[label='#{building}']").html()
    if options
      $("#intervention_battery_id").html(options)
      $("#intervention_battery_id").parent().show()
      $("#intervention_battery_id").val("null")
    else
      $("#intervention_battery_id").empty()
      $("#intervention_battery_id").parent().hide()
  $('#intervention_battery_id').change ->
    $("#intervention_elevator_id").parent().hide()
    battery = $("#intervention_battery_id :selected").text()
    options = $(columns).filter("optgroup[label='#{battery}']").html()
    if options
      $("#intervention_column_id").html(options)
      $("#intervention_column_id").parent().show()
      $("#intervention_column_id").val("null")
    else
      $("#intervention_column_id").empty()
      $("#intervention_column_id").parent().hide()
  $('#intervention_column_id').change ->
    column = $("#intervention_column_id :selected").text()
    options = $(elevators).filter("optgroup[label='#{column}']").html()
    if options
      $("#intervention_elevator_id").html(options)
      $("#intervention_elevator_id").parent().show()
      $("#intervention_elevator_id").val("null")
    else
      $("#intervention_elevator_id").empty()
      $("#intervention_elevator_id").parent().hide()

