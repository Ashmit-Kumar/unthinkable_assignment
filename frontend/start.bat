@echo off
echo 🚀 Starting Voice Shopping Assistant Frontend...
echo.
echo 📋 Make sure your backend is running on http://127.0.0.1:5000
echo.
echo 🌐 Opening browser to http://localhost:3232
echo ⏹️  Press Ctrl+C to stop the server
echo.

python -m http.server 3232

pause