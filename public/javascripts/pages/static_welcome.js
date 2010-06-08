$(function () {
  var removeDefault = function () {
    $(this).val("");
    $(this).removeClass("default");
    $(this).unbind("focus", removeDefault);
  };

  $("input.default").focus(removeDefault);
});
