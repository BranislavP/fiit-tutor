$(document).on('focus', 'input', function(){
   if($(this).is("#event_date")){
       $('#event_date').datetimepicker({
           inline: true,
           sideBySide: true,
           locale: 'en-gb'
       });
   }
});