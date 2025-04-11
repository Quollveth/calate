export default function MainPage() {
    return (
        <>
            <div className="flex flex-col gap-4">
                <h1>Main page</h1>
                <a href="/login">Login</a>
                <button
                    className="w-min"
                    onClick={() => (window.location.href = '/login')}
                >
                    Go to login
                </button>
            </div>
        </>
    );
}
