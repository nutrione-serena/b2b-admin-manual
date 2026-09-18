(function () {
  var overlay = document.createElement('div');
  overlay.className = 'lightbox-overlay';
  var img = document.createElement('img');
  overlay.appendChild(img);

  function ready() {
    document.body.appendChild(overlay);

    function close() {
      overlay.classList.remove('active');
      img.src = '';
    }

    overlay.addEventListener('click', close);
    document.addEventListener('keydown', function (e) {
      if (e.key === 'Escape') close();
    });

    document.querySelectorAll('img.zoomable').forEach(function (el) {
      el.addEventListener('click', function () {
        img.src = el.currentSrc || el.src;
        img.alt = el.alt || '';
        overlay.classList.add('active');
      });
    });
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', ready);
  } else {
    ready();
  }
})();
