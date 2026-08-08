import { useState } from 'react';
import CategoryForm from '../components/CategoryForm';
import CategoryList from '../components/CategoryList';
import useCategories from '../hooks/useCategories';
import { useApp } from '../context/AppContext';

export default function CategoriesPage() {
  const { showToast } = useApp();
  const { categories, loading, error, addCategory, replaceCategory, removeCategory } =
    useCategories();
  const [deletingId, setDeletingId] = useState(null);

  const handleDelete = async (category) => {
    if (!window.confirm(`Delete category "${category.name}"?`)) return;

    setDeletingId(category.id);
    try {
      await removeCategory(category.id);
      showToast('Category deleted', 'success');
    } catch (err) {
      showToast(err.message, 'error');
    } finally {
      setDeletingId(null);
    }
  };

  return (
    <div className="space-y-8">
      <section className="relative overflow-hidden rounded-3xl border border-slate-200 bg-white/60 px-4 py-10 text-center shadow-sm backdrop-blur-xl dark:border-white/10 dark:bg-white/[0.03] dark:shadow-card sm:px-6 sm:py-14">
        <span className="pointer-events-none absolute -left-24 -top-24 h-64 w-64 animate-float rounded-full bg-brand-500/20 blur-3xl" />
        <span
          className="pointer-events-none absolute -bottom-24 -right-24 h-64 w-64 animate-float rounded-full bg-accent-violet/20 blur-3xl"
          style={{ animationDelay: '2s' }}
        />

        <h2 className="mx-auto max-w-2xl text-2xl font-bold leading-tight text-slate-900 dark:text-white sm:text-4xl">
          Browse &amp; manage <span className="gradient-text animate-gradient-pan">categories</span>
        </h2>
        <p className="mx-auto mt-3 max-w-xl text-sm text-slate-600 dark:text-slate-400 sm:text-base">
          Organize commands across databases, containers, clusters and cloud
          providers. Add a category to start grouping new commands under it.
        </p>
      </section>

      <CategoryForm onSaved={addCategory} />

      <div className="flex items-center justify-between gap-3">
        <h3 className="text-sm font-semibold uppercase tracking-wider text-slate-500">
          Categories
        </h3>
        <span className="rounded-full border border-slate-200 bg-white/70 px-3 py-1 text-xs font-medium text-slate-500 dark:border-white/10 dark:bg-white/[0.03] dark:text-slate-400">
          {loading ? 'Loading…' : `${categories.length} categor${categories.length === 1 ? 'y' : 'ies'}`}
        </span>
      </div>

      <CategoryList
        categories={categories}
        loading={loading}
        error={error}
        onUpdated={replaceCategory}
        onDelete={handleDelete}
        deletingId={deletingId}
      />
    </div>
  );
}
