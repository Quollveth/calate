import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';
import '@/assets/main.css';

import LoginPage from './login';
import MainPage from './main';

const App = () => {
    const route = window.location.pathname;
    switch (route) {
        case '/login':
            return LoginPage();
        default:
            return MainPage();
    }
};

const root = createRoot(document.getElementById('root')!);
root.render(
    <StrictMode>
        <App />
    </StrictMode>
);
