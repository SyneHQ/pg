# 🚀 SyneHQ PostgreSQL with pgvector Docker Image 🚀

<div align="center">
  <a href="https://synehq.com">
    <img src="https://framerusercontent.com/images/DpVtRdL2gGDwSRNF4GSIdB6Ajkg.svg?scale-down-to=512" alt="synehq Logo" width="200"/>
  </a>
  <p><em>Enterprise-grade Vector Database Solutions by <a href="https://synehq.com">SyneHQ</a></em></p>
</div>

This Dockerfile creates a production-ready PostgreSQL database with pgvector extension enabled for vector similarity search capabilities. It also includes pg_stat_statements extension for query performance monitoring, developed and maintained by [SyneHQ](https://synehq.com).

> 📢 **Looking for a standard PostgreSQL image?** Check out our [`synehq/pg`](https://hub.docker.com/r/synehq/pg) image for non-vector database requirements! Same enterprise-grade quality without the vector extensions. Perfect for traditional database workloads! 🐘

[![Visit SyneHQ](https://img.shields.io/badge/visit-synehq.com-blue)](https://synehq.com)
[![Docker Pulls](https://img.shields.io/docker/pulls/synehq/postgres-pgvector)](https://hub.docker.com/r/synehq/postgres-pgvector)
[![GitHub License](https://img.shields.io/badge/license-MIT-blue.svg)](https://synehq.com/license)

## ✨ Features ✨

- 🏢 Enterprise-ready vector database solution
- 🐘 Based on official pgvector/pgvector:pg17 image
- 📊 Includes pg_stat_statements extension for query performance monitoring
- 🔍 Configured with vector similarity search support
- 🔌 Increased max connections (200)
- 🧙‍♂️ Automatic initialization with vector extensions and sample table
- 🔮 Pre-configured similarity search function
- 🚄 Production-grade performance optimizations

## Getting Started

```bash
docker run -d --name postgres-pgvector \
    -e POSTGRES_PASSWORD=your_password \
    -p 5432:5432 \
    -v $(pwd)/certificates:/etc/postgresql/ssl \
    ghcr.io/synehq/pg-vector
```

```bash
docker run -d --name postgres-pg \
    -e POSTGRES_PASSWORD=your_password \
    -p 5432:5432 \
    ghcr.io/synehq/pg
```

## 🎯 Quick Start for development 🎯

### 🔨 Building the Image
```bash
docker build -t synehq/pg-vector vector/
```

```bash
docker build -t synehq/pg .
```

### 🔒 Generating Self-Signed Certificates (for Testing)

Need some certificates but don't want the hassle? We've got you covered! 🛡️

```bash
# Create directories
mkdir -p certificates

# Generate self-signed certificate (abracadabra! 🪄)
openssl req -new -x509 -days 365 -nodes \
  -out certificates/server.crt \
  -keyout certificates/server.key \
  -subj "/CN=postgres" \
  -addext "subjectAltName = DNS:postgres,DNS:localhost,IP:127.0.0.1"

# Set permissions (keep it secret, keep it safe! 🧙‍♂️)
chmod 600 certificates/server.key
chmod 644 certificates/server.crt
```

This approach provides secure ways to pass SSL certificates to your PostgreSQL container, ensuring proper encryption for your database connections while maintaining security best practices.

### 🚢 Running the Container

```bash
docker run -d --name postgres-pgvector \
    -e POSTGRES_PASSWORD=your_password \
    -p 5432:5432 \
    -v $(pwd)/certificates:/etc/postgresql/ssl \
    ghcr.io/synehq/pg-vector
```

```bash
docker run -d --name postgres-pg \
    -e POSTGRES_PASSWORD=your_password \
    -p 5432:5432 \
    ghcr.io/synehq/pg
```

### 💻 Accessing the Database

```bash
docker exec -it postgres-pgvector psql -U postgres
```

## 🦸 Features & Capabilities 🦸‍♀️

### 🔧 Initial Setup

The container automatically:
- 🔌 Enables the vector and pg_stat_statements extensions
- 📋 Creates a sample 'items' table with vector embedding support
- 🚀 Sets up an IVFFlat index for efficient similarity search
- 🧪 Creates a helper function for vector similarity matching

### 🧩 Sample Usage

```sql
-- Insert a sample item (it's that easy! 🎉)
INSERT INTO items (description, embedding) 
VALUES ('Sample item', '[0.1, 0.2, ..., 0.5]'::vector);

-- Find similar items (like magic! 🪄)
SELECT * FROM match_items(
    '[0.1, 0.2, ..., 0.5]'::vector,  -- query embedding
    0.8,                             -- similarity threshold
    5                                -- number of results
);
```

## 📚 Technical Documentation 📚

### 📊 Available Tables

#### items
- `id`: Serial primary key
- `description`: Text description (tell us your stories! 📝)
- `embedding`: Vector(1536) for storing embeddings (where the magic happens! ✨)
- `created_at`: Timestamp of creation (we like to keep track of time! ⏰)

### 🛠️ Available Functions

#### match_items(query_embedding, match_threshold, match_count)
Finds similar items based on vector similarity (like finding your database soulmates! 💘):
- `query_embedding`: Vector to match against
- `match_threshold`: Minimum similarity score (0-1)
- `match_count`: Maximum number of results to return

## 🧠 SyneHQ Database Options 🧠

| Image | Use Case | Features |
|-------|----------|----------|
| [`synehq/postgres-pgvector`](https://hub.docker.com/r/synehq/postgres-pgvector) | AI & Vector Search | PostgreSQL + pgvector for similarity search, embeddings storage, and AI applications |
| [`synehq/pg`](https://hub.docker.com/r/synehq/pg) | Standard Database | Enterprise-grade PostgreSQL without vector extensions, optimized for traditional workloads |

Choose the right tool for your job! Both images include our enterprise-grade optimizations and support. 🛠️

## 🆘 Support & Resources 🆘

- [Documentation](https://synehq.com/docs) 📖
- [API Reference](https://synehq.com/api) 🔌
- [Community Forum](https://synehq.com/community) 👥
- [Enterprise Support](https://synehq.com/enterprise) 🏢

## 🏢 About synehq 🏢

[synehq](https://synehq.com) provides enterprise-grade database solutions for modern AI applications. Our technology powers thousands of production deployments worldwide, helping businesses leverage the power of vector similarity search at scale. We're like database superheros, but without the capes! 🦸‍♂️🦸‍♀️

## 📜 License 📜

This project is licensed under the MIT License - see [synehq.com/license](https://synehq.com/license) for details. No fine print, we promise! 😉

---
<div align="center">
  <p>Built with ❤️ by <a href="https://synehq.com">synehq</a></p>
  <p>
    <a href="https://synehq.com">Website</a> •
    <a href="https://synehq.com/docs">Documentation</a> •
    <a href="https://synehq.com/blog">Blog</a> •
    <a href="https://synehq.com/contact">Contact</a>
  </p>
  <p>Made with 🍕, 🍦, and a little bit of database magic! ✨</p>
</div>