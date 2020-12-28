$(document).ready(function() {
  var button = $('#search-room');
  var date= new Date().toJSON().slice(0,10);
  $(button).prop('disabled', true);
  var checkin;
  var checkout;

  $('#checkin').change(function() {
    checkin = $(this).val();

  });
  $('#checkout').change(function() {

    checkout = $(this).val();
    if (checkin >= date){
      if(checkin != "" && checkout != "" ){
        if(checkin < checkout) {
          $(button).prop('disabled', false);
        }
        else{
          alert(I18n.t('shared.search_room_form.fail'));
          $(button).prop('disabled', true);
        }
      }
      else{
        alert(I18n.t('shared.search_room_form.error'));
        $(button).prop('disabled', true);
      }
    }
    else{
      alert(I18n.t('shared.search_room_form.dayy'));
    }

  });
});
