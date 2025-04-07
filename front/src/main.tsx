import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';
import '@/assets/main.css';

const App = () => {
    return <h1 className="text-red-800">Hello World</h1>;
};

const root = createRoot(document.getElementById('root')!);
root.render(
    <StrictMode>
        <App />
    </StrictMode>
);
