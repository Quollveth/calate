import { useState } from 'react';
import { ENDPOINT_HEALTH } from './constants';

export default function TestButton() {
    const [status, setStatus] = useState<'idle' | 'success' | 'error'>('idle');

    const handleClick = async () => {
        try {
            const res = await fetch(ENDPOINT_HEALTH);
            if (res.status === 200) {
                setStatus('success');
            } else {
                setStatus('error');
            }
        } catch (error) {
            setStatus('error');
        }
    };

    const buttonColor =
        status === 'success'
            ? 'bg-green-500 hover:bg-green-600'
            : status === 'error'
              ? 'bg-red-500 hover:bg-red-600'
              : 'bg-blue-500 hover:bg-blue-600';

    return (
        <div className="flex h-screen items-center justify-center">
            <button
                className={`text-white px-6 py-3 rounded-lg text-lg font-semibold transition-colors duration-300 ${buttonColor}`}
                onClick={handleClick}
            >
                Test
            </button>
        </div>
    );
}
