import { useState } from 'react';
import { NavLink, Outlet } from 'react-router-dom';
import Toast from './Toast';
import ThemeToggle from './ThemeToggle';

const links = [
  { to: '/', label: 'Search', end: true },
  { to: '/categories', label: 'Categories' },
  { to: '/templates', label: 'Templates' },
  { to: '/feature-requests', label: 'Requests' },
];

const navLinkClass = ({ isActive }) =>
  `relative rounded-lg px-3.5 py-2 text-sm font-medium transition-all duration-200 ${
    isActive
      ? 'text-white'
      : 'text-slate-500 hover:text-slate-900 dark:text-slate-400 dark:hover:text-slate-100'
  }`;

const mobileLinkClass = ({ isActive }) =>
  `relative block rounded-xl px-4 py-3 text-sm font-medium transition-all duration-200 ${
    isActive
      ? 'text-white'
      : 'text-slate-600 hover:bg-slate-100 hover:text-slate-900 dark:text-slate-300 dark:hover:bg-white/[0.05] dark:hover:text-white'
  }`;

export default function Layout() {
  const [menuOpen, setMenuOpen] = useState(false);

  return (
    <div className="min-h-screen">
      <div className="app-backdrop" aria-hidden="true" />

      <header className="sticky top-0 z-40 border-b border-slate-200 bg-white/70 backdrop-blur-xl dark:border-white/5 dark:bg-ink-950/70">
        <div className="mx-auto flex max-w-6xl items-center justify-between gap-3 px-4 py-3.5">
          <NavLink
            to="/"
            className="group flex min-w-0 items-center gap-2.5 sm:gap-3"
            onClick={() => setMenuOpen(false)}
          >
            <span className="relative flex h-9 w-9 shrink-0 items-center justify-center rounded-xl bg-brand-gradient bg-[length:200%_200%] shadow-glow transition-transform duration-300 group-hover:scale-105 group-hover:animate-gradient-pan sm:h-10 sm:w-10">
              <span className="font-mono text-base font-bold text-white sm:text-lg">&gt;_</span>
            </span>
            <span className="min-w-0 leading-tight">
              <span className="block text-[10px] font-semibold uppercase tracking-[0.2em] text-brand-500 dark:text-brand-300">
                DevOps
              </span>
              <span className="block truncate text-sm font-bold text-slate-900 dark:text-white sm:text-base">
                Command <span className="gradient-text">Manager</span>
              </span>
            </span>
          </NavLink>

          <div className="flex items-center gap-2">
            <nav className="hidden items-center gap-1 rounded-2xl border border-slate-200 bg-white/60 p-1 backdrop-blur-xl dark:border-white/10 dark:bg-white/[0.03] sm:flex">
              {links.map((link) => (
                <NavLink key={link.to} to={link.to} end={link.end} className={navLinkClass}>
                  {({ isActive }) => (
                    <>
                      {isActive && (
                        <span className="absolute inset-0 -z-10 rounded-lg bg-brand-gradient bg-[length:200%_200%] opacity-90 shadow-glow animate-gradient-pan" />
                      )}
                      {link.label}
                    </>
                  )}
                </NavLink>
              ))}
            </nav>

            <ThemeToggle />

            <button
              type="button"
              onClick={() => setMenuOpen((o) => !o)}
              aria-label={menuOpen ? 'Close menu' : 'Open menu'}
              aria-expanded={menuOpen}
              className="flex h-9 w-9 items-center justify-center rounded-lg border border-slate-200 bg-white/70 text-slate-600 transition-colors hover:text-brand-500 dark:border-white/10 dark:bg-white/[0.03] dark:text-slate-300 dark:hover:text-brand-300 sm:hidden"
            >
              {menuOpen ? (
                <svg className="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
                  <path d="M18 6 6 18M6 6l12 12" />
                </svg>
              ) : (
                <svg className="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
                  <path d="M4 6h16M4 12h16M4 18h16" />
                </svg>
              )}
            </button>
          </div>
        </div>

        {menuOpen && (
          <nav className="animate-fade-up border-t border-slate-200 bg-white/90 px-4 py-3 backdrop-blur-xl dark:border-white/5 dark:bg-ink-950/90 sm:hidden">
            <div className="flex flex-col gap-1">
              {links.map((link) => (
                <NavLink
                  key={link.to}
                  to={link.to}
                  end={link.end}
                  className={mobileLinkClass}
                  onClick={() => setMenuOpen(false)}
                >
                  {({ isActive }) => (
                    <>
                      {isActive && (
                        <span className="absolute inset-0 -z-10 rounded-xl bg-brand-gradient bg-[length:200%_200%] opacity-90 shadow-glow" />
                      )}
                      {link.label}
                    </>
                  )}
                </NavLink>
              ))}
            </div>
          </nav>
        )}
      </header>

      <main className="mx-auto max-w-6xl px-4 py-8">
        <Outlet />
      </main>

      <footer className="mx-auto max-w-6xl px-4 pb-10 pt-6 text-center">
        <p className="text-xs text-slate-500 dark:text-slate-400">
          Built for fast DevOps command lookup · Phase 3
        </p>
        <p className="mt-1.5 text-xs text-slate-400/60 dark:text-slate-500/50">
          © {new Date().getFullYear()} Keval Rabadiya. All rights reserved.
        </p>
      </footer>

      <Toast />
    </div>
  );
}
