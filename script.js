document.addEventListener('DOMContentLoaded', () => {
  // Mobile Menu
  const navToggle = document.querySelector('.nav-toggle');
  const menuContainer = document.querySelector('.mobile-menu-container');
  const menuOverlay = document.querySelector('.mobile-menu-overlay');

  if (navToggle && menuContainer) {
    const toggleMenu = (open) => {
      navToggle.setAttribute('aria-expanded', open);
      menuContainer.hidden = !open;
      document.body.style.overflow = open ? 'hidden' : '';
    };

    navToggle.addEventListener('click', () => {
      const isExpanded = navToggle.getAttribute('aria-expanded') === 'true';
      toggleMenu(!isExpanded);
    });

    menuOverlay.addEventListener('click', () => toggleMenu(false));

    // Close menu when a link is clicked
    const menuLinks = menuContainer.querySelectorAll('a');
    menuLinks.forEach(link => {
      link.addEventListener('click', () => toggleMenu(false));
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