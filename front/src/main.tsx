import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';
import '@/assets/main.css';

import TestButton from './testButton.tsx';

const root = createRoot(document.getElementById('root')!);
root.render(
    <StrictMode>
        <TestButton />
    </StrictMode>
);
