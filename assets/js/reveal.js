(function () {
  // 관리자 경로(.reveal-after) 노출 시작일: 2026-10-01 (KST)
  var REVEAL_AT = new Date('2026-10-01T00:00:00+09:00');

  if (new Date() >= REVEAL_AT) {
    document.querySelectorAll('.reveal-after').forEach(function (el) {
      el.style.display = '';
    });
  }
})();
