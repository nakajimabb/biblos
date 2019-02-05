import React from 'react';
import DefaultLayout from './containers/DefaultLayout';

const Dashboard = React.lazy(() => import('./views/Dashboard'));
const Articles = React.lazy(() => import('./views/Articles/index'));
const Article = React.lazy(() => import('./views/Articles/show'));

// https://github.com/ReactTraining/react-router/tree/master/packages/react-router-config
const routes = [
  { path: '/', name: 'Home', component: DefaultLayout, exact: true },
  { path: '/dashboard', name: 'Dashboard', component: Dashboard },
  { path: '/articles/:id', name: '記事', component: Article },
  { path: '/articles', name: '記事一覧', component: Articles },
];

export default routes;
