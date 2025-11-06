document.addEventListener('DOMContentLoaded', () => {
  // Mobile Menu
  const navToggle = document.querySelector('.nav-toggle');
  const mobileMenu = document.getElementById('mobile-menu');
  const siteHeader = document.querySelector('.site-header');

  if (navToggle && mobileMenu) {
    navToggle.addEventListener('click', () => {
      const isExpanded = navToggle.getAttribute('aria-expanded') === 'true';
      navToggle.setAttribute('aria-expanded', !isExpanded);
      mobileMenu.hidden = !mobileMenu.hidden;
    });
  }

  // Sticky Header
  if (siteHeader) {
    const observer = new IntersectionObserver(
      ([e]) => e.target.classList.toggle('scrolled', e.intersectionRatio < 1),
      { threshold: [1] }
    );
    observer.observe(siteHeader);
  }

  // Scroll Animations
  const animatedEls = document.querySelectorAll('[data-observe]');
  if (animatedEls.length > 0) {
    const observer = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          entry.target.querySelectorAll('[data-anim]').forEach((el, i) => {
            const delay = el.dataset.animDelay || 0;
            el.style.setProperty('--delay', `${parseInt(delay, 10)}ms`);
            el.classList.add('is-inview');
          });
          observer.unobserve(entry.target);
        }
      });
    }, { rootMargin: '0px 0px -10% 0px' });

    animatedEls.forEach(el => observer.observe(el));
  }

  // RSVP Form
  const rsvpForm = document.querySelector('.rsvp-form');
  if (rsvpForm) {
    rsvpForm.addEventListener('submit', (e) => {
      // Netlify会自动处理表单提交
      console.log('RSVP表单提交中...');
    });
  }

  // Guestbook Form
  const guestbookForm = document.querySelector('.guestbook-form');
  if (guestbookForm) {
    guestbookForm.addEventListener('submit', (e) => {
      // Netlify会自动处理表单提交
      console.log('留言表单提交中...');
    });
  }
});