# 🛒 Voice Shopping Assistant

A modern **AI-powered voice shopping assistant** that lets users manage their shopping lists through natural speech commands. Built with **FastAPI**, **Groq LLMs**, **AssemblyAI speech recognition**, and a responsive web interface.

![Voice Shopping Assistant](https://img.shields.io/badge/AI-Powered-blue) ![FastAPI](https://img.shields.io/badge/FastAPI-0.104.1-green) ![Docker](https://img.shields.io/badge/Docker-Ready-blue) ![License](https://img.shields.io/badge/License-MIT-yellow)

---

## ✨ Features

### 🎤 **Voice-First Experience**
- **Natural Speech Commands**: Say "Add 2 liters of milk" or "Remove apples from my list"
- **Real-time Processing**: Speech → Text (AssemblyAI) → Structured Actions (Groq AI)
- **Smart Confirmation**: Visual confirmation before executing voice commands

### 🧠 **AI-Powered Intelligence**
- **LLM Command Parsing**: Groq's `llama-3.3-70b-versatile` extracts product, quantity, category, and action
- **Fuzzy Product Matching**: Handles variations in product names using RapidFuzz
- **Text Normalization**: Understands different ways of expressing shopping intents

### 📱 **Modern Web Interface**
- **Responsive Design**: Works seamlessly on desktop, tablet, and mobile
- **Real-time Updates**: Live wishlist and recommendations without page refresh
- **Visual Feedback**: Loading states, notifications, and confirmation dialogs
- **Offline Support**: Graceful handling of network connectivity issues

### 🤖 **Smart Recommendations**
- **ML-Based Suggestions**: Uses SentenceTransformers + FAISS for semantic product matching
- **Personalized Results**: Recommendations based on shopping history and preferences
- **Category-Aware**: Prioritizes items from similar categories
- **Stock-Aware**: Only suggests available products

### 🐳 **Production Ready**
- **Docker Support**: Separate containers for frontend and backend
- **EC2 Deployment**: Ready-to-deploy configuration for AWS EC2
- **Environment Management**: Secure API key and configuration handling
- **Scalable Architecture**: Microservices-ready design

---

## 🏗️ Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Frontend      │    │    Backend      │    │    Database     │
│   (Nginx)       │◄──►│   (Python)      │◄──►│   (MongoDB)     │
│   Port: 3232    │    │   Port: 5000    │    │   Atlas/Local   │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│ • Vanilla JS    │    │ • FastAPI       │    │ • User Wishlists│
│ • HTML/CSS      │    │ • Speech-to-Text│    │ • Store Products│
│ • Voice Recording│    │ • AI Processing │    │ • Shopping History│
│ • Real-time UI  │    │ • Recommendations│    │ • Vector Search │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

---

## 📂 Project Structure

```
voice-shopping-assistant/
├── 🐳 Docker Configuration
│   ├── Dockerfile.backend          # Python FastAPI container
│   ├── Dockerfile.frontend         # Nginx static file server
│   ├── docker-compose.yml          # Local development setup
│   └── nginx.conf                  # Nginx configuration
│
├── 🖥️ Backend (Python)
│   ├── main.py                     # FastAPI application & routes
│   ├── db.py                       # MongoDB connection & collections
│   ├── helper_function.py          # Utility functions & validation
│   ├── prompt.py                   # Groq AI integration
│   ├── seed_store.py              # Sample store data
│   └── requirements.txt            # Python dependencies
│
├── 🌐 Frontend (Web)
│   ├── index.html                  # Main application interface
│   ├── css/
│   │   ├── main.css               # Core styles & layout
│   │   ├── components.css         # UI component styles
│   │   └── responsive.css         # Mobile-responsive design
│   └── js/
│       ├── app.js                 # Main application logic
│       ├── api.js                 # API communication layer
│       ├── audio.js               # Voice recording functionality
│       └── ui.js                  # UI management & interactions
│
├── ⚙️ Configuration
│   ├── .env                       # Environment variables (local)
│   ├── .env.example              # Environment template
│   ├── .dockerignore             # Docker build exclusions
│   └── .gitignore                # Git exclusions
│
└── 📚 Documentation
    ├── README.md                  # This file
    └── DOCKER_README.md          # Docker deployment guide
```

---

## 🚀 Quick Start

### 🐳 **Docker Deployment (Recommended)**

1. **Clone the repository**
   ```bash
   git clone https://github.com/Ashmit-Kumar/unthinkable_assignment
   cd voice-shopping-assistant
   ```

2. **Configure environment**
   ```bash
   cp .env.example .env
   # Edit .env with your API keys
   ```

3. **Build and run**
   ```bash
   docker-compose up --build -d
   ```

4. **Access the application**
   - **Frontend**: http://localhost:3232
   - **Backend API**: http://localhost:5000
   - **API Documentation**: http://localhost:5000/docs

### � F**Local Development**

1. **Backend Setup**
   ```bash
   pip install -r requirements.txt
   uvicorn main:app --host 0.0.0.0 --port 5000 --reload
   ```

2. **Frontend Setup**
   ```bash
   cd frontend
   python -m http.server 3232
   # Or use any static file server
   ```

---

## 🔧 Configuration

### 📋 **Environment Variables**

Create a `.env` file with the following variables:

```env
# Groq API Key (get from https://console.groq.com/)
GROQ_API_KEY=gsk_your_groq_api_key_here

# AssemblyAI API Key (get from https://www.assemblyai.com/)
ASSEMBLYAI_API_KEY=your_assemblyai_api_key_here

# MongoDB Connection String
MONGO_URI=mongodb+srv://username:password@cluster.mongodb.net/database_name
# Or for local MongoDB:
# MONGO_URI=mongodb://localhost:27017
```

### 🗄️ **Database Setup**

The application uses MongoDB with two main collections:

- **`users`**: Stores user wishlists and shopping history
- **`store`**: Contains available products with categories and stock

Sample store data is automatically seeded when you run `seed_store.py`.

---

## 🎯 API Endpoints

### 🎤 **Voice Processing**
- `POST /recognise_text_to_llm` - Process voice recording and return structured command

### 📝 **Wishlist Management**
- `GET /wishlist/{username}` - Get user's current wishlist
- `POST /update_wishlist/{username}` - Add/remove items from wishlist

### 💡 **Recommendations**
- `GET /recommendations/{username}` - Get personalized product recommendations

### 📊 **API Documentation**
- `GET /docs` - Interactive Swagger UI documentation
- `GET /redoc` - ReDoc API documentation

---

## 🎤 Usage Examples

### **Voice Commands**

| Command | Action | Result |
|---------|--------|--------|
| "Add milk to my list" | Add item | Adds milk (quantity: 1) |
| "I need 2 apples" | Add item | Adds apples (quantity: 2) |
| "Remove bananas" | Remove item | Removes bananas from list |
| "Delete chocolate from my list" | Remove item | Removes chocolate |

### **API Usage**

```javascript
// Get user's wishlist
const response = await fetch('/wishlist/john_doe');
const data = await response.json();

// Add item to wishlist
const addAction = {
    product: "Apple",
    quantity: 2,
    category: "fruit",
    action: "add",
    status: "manual_add"
};

await fetch('/update_wishlist/john_doe', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(addAction)
});
```

---

## 🐳 Docker Deployment

### **Build Images**
```bash
# Build backend image
docker build -f Dockerfile.backend -t voice-shopping-backend:latest .

# Build frontend image  
docker build -f Dockerfile.frontend -t voice-shopping-frontend:latest .
```

### **Run with Docker Compose**
```bash
# Development
docker-compose up --build -d

# Production (with pre-built images)
docker-compose -f docker-compose.prod.yml up -d
```

### **AWS EC2 Deployment**
```bash
# On EC2 instance
git clone <your-repo>
cd voice-shopping-assistant

# Configure environment
cp .env.example .env
nano .env  # Add your API keys

# Deploy
docker-compose up --build -d
```

**Security Group Configuration:**
- Port 3232: Frontend access
- Port 5000: Backend API
- Port 22: SSH access

---

## 🧠 AI & ML Components

### **Speech Recognition**
- **Provider**: AssemblyAI
- **Language**: English (en)
- **Format**: WebM audio from browser

### **Language Model**
- **Provider**: Groq
- **Model**: `llama-3.3-70b-versatile`
- **Purpose**: Parse natural language into structured shopping commands

### **Recommendation Engine**
- **Embeddings**: SentenceTransformers (`all-MiniLM-L6-v2`)
- **Vector Search**: FAISS (Facebook AI Similarity Search)
- **Strategy**: Semantic similarity + category boosting + stock filtering

### **Text Processing**
- **Fuzzy Matching**: RapidFuzz for product name variations
- **Normalization**: Regex-based intent recognition
- **Validation**: Schema validation for AI responses

---

## 🔒 Security Features

- **Input Validation**: All user inputs are validated and sanitized
- **API Key Management**: Environment-based configuration
- **CORS Protection**: Configurable cross-origin resource sharing
- **Error Handling**: Graceful error responses without exposing internals
- **Non-root Containers**: Docker containers run with non-privileged users

---

## 📊 Performance & Scalability

- **Async Processing**: FastAPI with async/await for concurrent requests
- **Vector Indexing**: FAISS for fast similarity search
- **Connection Pooling**: MongoDB connection management
- **Caching**: Browser-side caching for static assets
- **Compression**: Gzip compression for API responses

---

## 🛠️ Development

### **Prerequisites**
- Python 3.11+
- Node.js (for frontend development)
- Docker & Docker Compose
- MongoDB (local or Atlas)

### **Development Workflow**
```bash
# Backend development
pip install -r requirements.txt
uvicorn main:app --reload --port 5000

# Frontend development
cd frontend
python -m http.server 3232

# Run tests
python -m pytest tests/

# Code formatting
black *.py
```

### **Adding New Features**
1. Update API endpoints in `main.py`
2. Add frontend functionality in `js/app.js`
3. Update UI components in `js/ui.js`
4. Add styles in appropriate CSS files
5. Update documentation

---

## 🚀 Deployment Options

### **Local Development**
- Direct Python execution
- Local MongoDB instance
- Static file server for frontend

### **Docker Compose**
- Containerized backend and frontend
- Nginx reverse proxy
- Environment-based configuration

### **Cloud Deployment**
- **AWS EC2**: Full Docker deployment
- **Heroku**: Backend deployment with static frontend
- **Vercel/Netlify**: Frontend deployment with API proxy
- **MongoDB Atlas**: Managed database service

---

## 🔮 Future Enhancements

### **Planned Features**
- [ ] **Multi-language Support**: Support for multiple languages in speech recognition
- [ ] **User Authentication**: Login/signup with JWT tokens
- [ ] **Shopping Lists**: Multiple named lists per user
- [ ] **Price Tracking**: Historical price data and alerts
- [ ] **Barcode Scanning**: Mobile app with barcode integration
- [ ] **Voice Synthesis**: Text-to-speech responses
- [ ] **Real-time Collaboration**: Shared family shopping lists

### **Technical Improvements**
-  **Caching Layer**: Redis for session and recommendation caching
-  **Message Queue**: Celery for background processing
-  **Monitoring**: Prometheus + Grafana for metrics
-  **Testing**: Comprehensive test suite with pytest
-  **CI/CD**: GitHub Actions for automated deployment
-  **Load Balancing**: Multiple backend instances

---

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b feature/amazing-feature`
3. **Make your changes** and add tests
4. **Commit your changes**: `git commit -m 'Add amazing feature'`
5. **Push to the branch**: `git push origin feature/amazing-feature`
6. **Open a Pull Request**

### **Development Guidelines**
- Follow PEP 8 for Python code
- Use meaningful commit messages
- Add tests for new features
- Update documentation as needed
- Ensure Docker builds work correctly

---

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- **AssemblyAI** for speech recognition services
- **Groq** for fast LLM inference
- **Sentence Transformers** for semantic embeddings
- **FAISS** for efficient vector search
- **FastAPI** for the excellent web framework
- **MongoDB** for flexible document storage

---

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/Ashmit-Kumar/unthinkable_assignment/issues)
- **Discussions**: [GitHub Discussions](https://github.com/Ashmit-Kumar/unthinkable_assignment/discussions)
- **Email**: ashmitkumar1020@gmail.com

---

**Built with ❤️ for smarter shopping experiences**