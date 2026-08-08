import CategoryCard from './CategoryCard';

export default function CategoryList({
  categories = [],
  loading,
  error,
  onUpdated,
  onDelete,
  deletingId,
}) {
  if (loading) {
    return (
      <div className="flex items-center gap-3 py-12 text-slate-500 dark:text-slate-400">
        <span className="h-4 w-4 animate-spin rounded-full border-2 border-brand-400 border-t-transparent" />
        Loading categories…
      </div>
    );
  }

  if (error) {
    return (
      <div className="rounded-2xl border border-red-500/30 bg-red-500/10 p-6 text-red-600 dark:text-red-300">
        {error}
      </div>
    );
  }

  if (!categories.length) {
    return (
      <div className="rounded-2xl border border-dashed border-slate-300 bg-slate-50/50 p-10 text-center dark:border-white/10 dark:bg-white/[0.02]">
        <p className="text-sm text-slate-500 dark:text-slate-400">
          No categories yet. Add one above to start organizing commands.
        </p>
      </div>
    );
  }

  return (
    <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
      {categories.map((category) => (
        <CategoryCard
          key={category.id}
          category={category}
          onUpdated={onUpdated}
          onDelete={onDelete}
          deleting={deletingId === category.id}
        />
      ))}
    </div>
  );
}
