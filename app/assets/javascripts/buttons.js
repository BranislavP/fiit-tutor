$(document).on('click', 'button', function(){
    $("[data^='js_button-']").removeClass('clicked');
    $(this).addClass('clicked');
    $("div[data^='div-']").removeClass('show').addClass('hidden');
    $("div[data$='"+$(this).attr('data').split('-')[1]+"']").removeClass('hidden').addClass('show');
});