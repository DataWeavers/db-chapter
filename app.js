'use strict';

const menuButton = document.getElementById('menu-toggle');
const mobileNav = document.getElementById('mobile-nav');
function closeMenu() {
  menuButton.setAttribute('aria-expanded', 'false');
  mobileNav.hidden = true;
}
menuButton.addEventListener('click', () => {
  const opening = mobileNav.hidden;
  mobileNav.hidden = !opening;
  menuButton.setAttribute('aria-expanded', String(opening));
});
mobileNav.querySelectorAll('a').forEach(link => link.addEventListener('click', closeMenu));
document.addEventListener('keydown', event => {
  if (event.key === 'Escape' && !mobileNav.hidden) {
    closeMenu();
    menuButton.focus();
  }
});

const navigationLinks = [...document.querySelectorAll('nav a[href^="#"]')];
const trackedSections = [...document.querySelectorAll('section[id]')];
let scrollPending = false;
function updateCurrentSection() {
  let active = '';
  for (const section of trackedSections) {
    if (section.getBoundingClientRect().top <= 175) active = section.id;
  }
  navigationLinks.forEach(link => {
    if (link.getAttribute('href') === '#' + active) link.setAttribute('aria-current', 'location');
    else link.removeAttribute('aria-current');
  });
  scrollPending = false;
}
window.addEventListener('scroll', () => {
  if (!scrollPending) {
    scrollPending = true;
    requestAnimationFrame(updateCurrentSection);
  }
}, { passive: true });
updateCurrentSection();

const filter = document.getElementById('dictionary-table');
const dictionaryTables = [...document.querySelectorAll('.dictionary-table')];
filter.addEventListener('change', () => {
  let columns = 0;
  dictionaryTables.forEach(item => {
    item.hidden = filter.value !== 'all' && item.dataset.table !== filter.value;
    if (!item.hidden) columns += item.querySelectorAll('tbody tr').length;
  });
  document.getElementById('dictionary-status').textContent =
    `Showing ${filter.value === 'all' ? 'all four tables' : filter.value} · ${columns} columns.`;
});

document.querySelectorAll('.copy').forEach(button => {
  button.addEventListener('click', async () => {
    const block = button.closest('.code-block').querySelector('code');
    let copied = false;
    try {
      await navigator.clipboard.writeText(block.textContent);
      copied = true;
    } catch (_) {
      const range = document.createRange();
      range.selectNodeContents(block);
      const selection = window.getSelection();
      selection.removeAllRanges();
      selection.addRange(range);
      try { copied = document.execCommand('copy'); } catch (_) { /* Keep text selected. */ }
      if (copied) selection.removeAllRanges();
    }
    button.textContent = copied ? 'Copied ✓' : 'Selected';
    document.getElementById('copy-status').textContent = copied
      ? 'Copied to clipboard.' : 'Text selected. Press Ctrl+C or Command+C to copy.';
    setTimeout(() => { button.textContent = 'Copy'; }, 2200);
  });
});

let openedForPrint = [];
window.addEventListener('beforeprint', () => {
  openedForPrint = [...document.querySelectorAll('details:not([open])')];
  openedForPrint.forEach(item => { item.open = true; });
});
window.addEventListener('afterprint', () => {
  openedForPrint.forEach(item => { item.open = false; });
  openedForPrint = [];
});
window.addEventListener('resize', updateCurrentSection);
document.getElementById('print-guide').addEventListener('click', () => window.print());
