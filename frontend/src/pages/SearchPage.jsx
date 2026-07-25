import { useEffect, useState } from 'react';
import SearchBar from '../components/SearchBar';
import CommandList from '../components/CommandList';
import Pagination from '../components/Pagination';
import useSearch from '../hooks/useSearch';
import { useApp } from '../context/AppContext';

export default function SearchPage() {
  const {
    searchQuery,
    selectedCategory,
    setSearchQuery,
    setSelectedCategory,
  } = useApp();
  const [page, setPage] = useState(1);
  const { results, total, limit, loading, error } = useSearch(searchQuery, page);

  useEffect(() => {
    setPage(1);
  }, [searchQuery, selectedCategory]);

  return (
    <div className="space-y-8">
      <section className="relative overflow-hidden rounded-3xl border border-slate-200 bg-white/60 px-4 py-10 text-center shadow-sm backdrop-blur-xl dark:border-white/10 dark:bg-white/[0.03] dark:shadow-card sm:px-6 sm:py-16">
        <span className="pointer-events-none absolute -left-24 -top-24 h-64 w-64 animate-float rounded-full bg-brand-500/20 blur-3xl" />
        <span className="pointer-events-none absolute -bottom-24 -right-24 h-64 w-64 animate-float rounded-full bg-accent-violet/20 blur-3xl" style={{ animationDelay: '2s' }} />

        <span className="inline-flex items-center gap-2 rounded-full border border-slate-200 bg-white/70 px-3 py-1 text-xs font-medium text-brand-600 backdrop-blur dark:border-white/10 dark:bg-white/[0.04] dark:text-brand-200">
          <span className="h-1.5 w-1.5 animate-pulse rounded-full bg-emerald-400" />
          Fast DevOps command lookup
        </span>

        <h2 className="mx-auto mt-5 max-w-2xl text-2xl font-bold leading-tight text-slate-900 dark:text-white sm:text-4xl">
          Find, configure &amp; copy any{' '}
          <span className="gradient-text animate-gradient-pan">CLI command</span> in seconds
        </h2>
        <p className="mx-auto mt-3 max-w-xl text-sm text-slate-600 dark:text-slate-400 sm:text-base">
          Search across databases, containers, clusters and cloud tools. Fill in
          the blanks and grab a ready-to-run command.
        </p>

        <div className="mx-auto mt-8 max-w-3xl text-left">
          <SearchBar
            query={searchQuery}
            category={selectedCategory}
            onQueryChange={setSearchQuery}
            onCategoryChange={setSelectedCategory}
          />
        </div>
      </section>

      <div className="flex items-center justify-between">
        <h3 className="text-sm font-semibold uppercase tracking-wider text-slate-500">
          {searchQuery ? 'Search results' : 'All commands'}
        </h3>
        <span className="rounded-full border border-slate-200 bg-white/70 px-3 py-1 text-xs font-medium text-slate-500 dark:border-white/10 dark:bg-white/[0.03] dark:text-slate-400">
          {loading
            ? 'Searching…'
            : `${total} command${total === 1 ? '' : 's'}`}
        </span>
      </div>

      <CommandList
        commands={results}
        loading={loading}
        error={error}
        highlightQuery={searchQuery}
      />

      {!loading && !error && (
        <Pagination
          page={page}
          limit={limit}
          total={total}
          onPageChange={setPage}
        />
      )}
    </div>
  );
}
