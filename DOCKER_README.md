# 🐳 Voice Shopping Assistant - Docker Deployment Guide

This guide explains how to deploy the Voice Shopping Assistant using Docker and Docker Compose.

## 📋 Prerequisites

- **Docker** (version 20.10+)
- **Docker Compose** (version 2.0+)
- **API Keys** for Groq and AssemblyAI

### Install Docker

#### Windows/Mac
- Download Docker Desktop from [docker.com](https://www.docker.com/products/docker-desktop)

#### Linux (Ubuntu/Debian)
```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER
```

## 🚀 Quick Start

### 1. Clone and Setup
```bash
git clone <your-repo>
cd voice-shopping-assistant
```

### 2. Configure Environment
Create a `.env` file with your API keys:
```bash
GROQ_API_KEY=your_groq_api_key_here
ASSEMBLYAI_API_KEY=your_assemblyai_api_key_here
MONGO_URI=mongodb://mongodb:27017/wishlistDB
```

### 3. Deploy

#### Option A: Using Deploy Scripts (Recommended)

**Linux/Mac:**
```bash
chmod +x deploy.sh
./deploy.sh dev          # Development mode
./deploy.sh prod         # Production mode
```

**Windows:**
```cmd
deploy.bat dev           # Development mode
deploy.bat prod          # Production mode
```

#### Option B: Manual Docker Compose

**Development:**
```bash
docker-compose up --build -d
```

**Production:**
```bash
docker-compose -f docker-compose.production.yml up --build -d
```

## 📁 Docker Files Overview

### Core Docker Files

| File | Purpose |
|------|---------|
| `Dockerfile` | Basic development container |
| `Dockerfile.production` | Optimized multi-stage production build |
| `docker-compose.yml` | Development environment with local MongoDB |
| `docker-compose.production.yml` | Production environment with MongoDB Atlas |
| `.dockerignore` | Excludes unnecessary files from build context |

### Configuration Files

| File | Purpose |
|------|---------|
| `nginx.conf` | Nginx configuration for serving frontend |
| `deploy.sh` | Linux/Mac deployment script |
| `deploy.bat` | Windows deployment script |

## 🏗️ Architecture

### Development Mode
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Frontend      │    │   FastAPI       │    │   MongoDB       │
│   (Nginx)       │◄──►│   Backend       │◄──►│   (Local)       │
│   Port: 3232    │    │   Port: 8000    │    │   Port: 27017   │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

### Production Mode
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Frontend      │    │   FastAPI       │    │   MongoDB       │
│   (Nginx)       │◄──►│   Backend       │◄──►│   Atlas         │
│   Port: 80/443  │    │   Port: 8000    │    │   (Cloud)       │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## 🔧 Configuration Options

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `GROQ_API_KEY` | Groq LLM API key | Required |
| `ASSEMBLYAI_API_KEY` | AssemblyAI speech recognition key | Required |
| `MONGO_URI` | MongoDB connection string | `mongodb://mongodb:27017/wishlistDB` |
| `ENVIRONMENT` | Deployment environment | `development` |

### Docker Compose Profiles

#### Development (`docker-compose.yml`)
- **Frontend**: Nginx serving static files on port 3232
- **Backend**: FastAPI application on port 8000
- **Database**: Local MongoDB container on port 27017
- **Features**: Hot reload, debug logging, development tools

#### Production (`docker-compose.production.yml`)
- **Frontend**: Nginx with SSL support on ports 80/443
- **Backend**: Optimized FastAPI with resource limits
- **Database**: MongoDB Atlas (cloud)
- **Features**: SSL termination, caching, monitoring

## 📊 Service Management

### Common Commands

```bash
# Start services
./deploy.sh dev                    # Development
./deploy.sh prod                   # Production

# View logs
./deploy.sh logs                   # Development logs
./deploy.sh logs prod              # Production logs

# Stop services
./deploy.sh stop                   # Stop development
./deploy.sh stop prod              # Stop production

# Seed database
./deploy.sh seed                   # Add sample products

# Manual commands
docker-compose ps                  # Check service status
docker-compose logs -f api         # Follow API logs
docker-compose exec api bash       # Access API container
```

### Health Checks

All services include health checks:
- **API**: `http://localhost:8000/wishlist/healthcheck`
- **Frontend**: `http://localhost:3232/health`
- **MongoDB**: Internal Docker health check

## 🔍 Troubleshooting

### Common Issues

#### 1. Port Already in Use
```bash
# Check what's using the port
lsof -i :8000
netstat -tulpn | grep :8000

# Stop conflicting services
docker-compose down
```

#### 2. API Keys Not Working
```bash
# Check environment variables
docker-compose exec voice-shopping-api env | grep API

# Recreate containers with new env
docker-compose up --force-recreate
```

#### 3. MongoDB Connection Issues
```bash
# Check MongoDB logs
docker-compose logs mongodb

# Test connection
docker-compose exec voice-shopping-api python -c "from db import client; print(client.server_info())"
```

#### 4. Frontend Not Loading
```bash
# Check Nginx logs
docker-compose logs voice-shopping-frontend

# Verify file permissions
ls -la frontend/
```

### Debug Mode

Enable debug logging:
```bash
# Add to .env file
DEBUG=true
LOG_LEVEL=debug

# Restart services
docker-compose up --force-recreate
```

## 📈 Performance Optimization

### Production Optimizations

1. **Multi-stage Build**: Reduces image size by 60%
2. **Resource Limits**: Prevents memory leaks
3. **Nginx Caching**: Improves frontend performance
4. **Gzip Compression**: Reduces bandwidth usage
5. **Health Checks**: Ensures service reliability

### Monitoring

Add monitoring services:
```yaml
# Add to docker-compose.production.yml
  prometheus:
    image: prom/prometheus
    ports:
      - "9090:9090"
    
  grafana:
    image: grafana/grafana
    ports:
      - "3001:3000"
```

## 🔒 Security

### Production Security Features

1. **Non-root User**: Containers run as non-root
2. **Security Headers**: Nginx adds security headers
3. **SSL Support**: HTTPS termination
4. **Network Isolation**: Services in private network
5. **Resource Limits**: Prevents DoS attacks

### SSL Configuration

For production SSL:
```bash
# Create SSL directory
mkdir ssl

# Add your certificates
cp your-cert.pem ssl/
cp your-key.pem ssl/

# Update nginx.prod.conf with SSL settings
```

## 📦 Deployment Strategies

### Local Development
```bash
./deploy.sh dev
```

### Staging Environment
```bash
# Use production compose with staging env
cp .env .env.staging
# Edit .env.staging with staging values
docker-compose -f docker-compose.production.yml --env-file .env.staging up -d
```

### Production Deployment
```bash
./deploy.sh prod
```

### Cloud Deployment (AWS/GCP/Azure)

1. **Push to Container Registry**:
```bash
docker build -f Dockerfile.production -t voice-shopping-api .
docker tag voice-shopping-api your-registry/voice-shopping-api
docker push your-registry/voice-shopping-api
```

2. **Deploy with Cloud Services**:
- AWS ECS/Fargate
- Google Cloud Run
- Azure Container Instances

## 🧪 Testing

### API Testing
```bash
# Test API endpoints
curl http://localhost:8000/wishlist/test_user
curl -X POST http://localhost:8000/update_wishlist/test_user \
  -H "Content-Type: application/json" \
  -d '{"product":"test","quantity":1,"category":"test","action":"add","status":"test"}'
```

### Frontend Testing
```bash
# Access test page
open http://localhost:3232/test.html
```

### Load Testing
```bash
# Install Apache Bench
apt-get install apache2-utils

# Test API performance
ab -n 1000 -c 10 http://localhost:8000/wishlist/test_user
```

## 📚 Additional Resources

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Reference](https://docs.docker.com/compose/)
- [FastAPI Deployment](https://fastapi.tiangolo.com/deployment/)
- [Nginx Configuration](https://nginx.org/en/docs/)

## 🆘 Support

If you encounter issues:

1. Check the logs: `./deploy.sh logs`
2. Verify environment variables
3. Ensure all ports are available
4. Check Docker daemon status
5. Review this troubleshooting guide

For additional help, check the main README.md or create an issue in the repository.