import { BrowserRouter, Navigate, Route, Routes } from 'react-router-dom';
import { AppProvider } from './context/AppContext';
import Layout from './components/Layout';
import SearchPage from './pages/SearchPage';
import CommandPage from './pages/CommandPage';
import CategoriesPage from './pages/CategoriesPage';
import TemplatesPage from './pages/TemplatesPage';
import FeatureRequestsPage from './pages/FeatureRequestsPage';

export default function App() {
  return (
    <AppProvider>
      <BrowserRouter>
        <Routes>
          <Route element={<Layout />}>
            <Route index element={<SearchPage />} />
            <Route path="commands/:id" element={<CommandPage />} />
            <Route path="categories" element={<CategoriesPage />} />
            <Route path="templates" element={<TemplatesPage />} />
            <Route path="feature-requests" element={<FeatureRequestsPage />} />
            <Route path="*" element={<Navigate to="/" replace />} />
          </Route>
        </Routes>
      </BrowserRouter>
    </AppProvider>
  );
}
