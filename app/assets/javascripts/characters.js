jQuery(document).ready(function() {
  jQuery('#submit_character').click(function(e) {
    e.preventDefault();
    jQuery('#character_status').val('1');
    jQuery('form').submit();
  });
});


$('#add_knack').click(function(e) {
  e.preventDefault();
  var knackText = $('#knack').val();
  var newItem = $('.template.knacks').find('li').clone();
  newItem.find('span').text(knackText);
  newItem.children('input[name="character[knacks][][knack]"]').val(knackText);
  $('#knacks').append(newItem);
  $('#knack').val("");
  validateStats();
});

$('#add_flaw').click(function(e) {
  e.preventDefault();
  var knackText = $('#flaw').val();
  var newItem = $('.template.flaws').find('li').clone();
  newItem.find('span').text(knackText);
  newItem.children('input[name="character[flaws][][flaw]"]').val(knackText);
  $('#flaws').append(newItem);
  $('#flaw').val("");
  validateStats();
});

$('#add_power').click(function(e) {
  e.preventDefault();
  var powerId = parseInt($('#power_power_id option:selected').val());
  $.ajax({
    url: '/api/characters/get_power/'+powerId,
    method: 'GET',
    success: function(data) {
      var newItem = $('.template.powers').find('li').clone();
      newItem.children('p.name').text(data['name']);
      newItem.children('p.description').text(data['description']);
      newItem.children('p.specification').children('label').text(data['specification_name']);
      newItem.children('input[name="character[character_has_powers][][power_id]"]').val(powerId);
      $('#powers').append(newItem);
    }
  });
  validateStats();
});

$('.delete').click(function() {
  $(this).parent().remove();
  validateStats();
});

$('#character_item, #character_money, #character_allies, #character_broad_type').change(function () {
  validateStats();
});

function validateStats() {
  var formData = $('form').serialize();
  $.ajax({
    url: '#{validate_stats_path}',
    method: 'GET',
    data: formData,
    success: function(data) {
      console.log(data);
    }
  })
}
