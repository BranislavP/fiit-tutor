$(document).on('click', 'li', function(){
    $("[data^='js_button-']").removeClass('active');
    $(this).addClass('active');
    $("div[data^='div-']").removeClass('show').addClass('hidden');
    $("div[data$='"+$(this).attr('data').split('-')[1]+"']").removeClass('hidden').addClass('show');
});