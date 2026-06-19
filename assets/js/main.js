(function () {
  const toggle = document.querySelector(".nav-toggle");
  const nav = document.querySelector(".site-nav");

  if (toggle && nav) {
    toggle.addEventListener("click", function () {
      const expanded = toggle.getAttribute("aria-expanded") === "true";
      toggle.setAttribute("aria-expanded", String(!expanded));
      nav.classList.toggle("is-open", !expanded);
    });
  }
})();

(function () {
  const modal = document.querySelector("#person-photo-modal");
  const modalImage = modal ? modal.querySelector("img") : null;
  const closeButtons = modal ? modal.querySelectorAll(".photo-modal-backdrop, .photo-modal-close") : [];
  const photoButtons = document.querySelectorAll(".person-photo-button");

  if (!modal || !modalImage || photoButtons.length === 0) {
    return;
  }

  function closeModal() {
    modal.classList.remove("is-open");
    modal.setAttribute("aria-hidden", "true");
    modalImage.setAttribute("src", "");
    modalImage.setAttribute("alt", "");
  }

  photoButtons.forEach(function (button) {
    button.addEventListener("click", function () {
      modalImage.setAttribute("src", button.dataset.photoSrc);
      modalImage.setAttribute("alt", button.dataset.photoAlt || "");
      modal.classList.add("is-open");
      modal.setAttribute("aria-hidden", "false");
    });
  });

  closeButtons.forEach(function (button) {
    button.addEventListener("click", closeModal);
  });

  document.addEventListener("keydown", function (event) {
    if (event.key === "Escape" && modal.classList.contains("is-open")) {
      closeModal();
    }
  });
})();
