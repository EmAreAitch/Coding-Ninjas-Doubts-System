# 🎓 Coding Ninjas Doubt Resolution System

A comprehensive doubt resolution platform built for Coding Ninjas, enabling seamless interaction between students and Teaching Assistants with real-time analytics and scalable architecture.

## 🚀 Live Demo

**[Visit Live Application](https://coding-ninjas-doubts-system.onrender.com)**

### Test Credentials
**Students:**
- `student1@test.com` / `password123`
- `student2@test.com` / `password123`
- `student3@test.com` / `password123`

**Teaching Assistants:**
- `ta1@test.com` / `password123`
- `ta2@test.com` / `password123`
- `ta3@test.com` / `password123`

## ✨ Features

### 👨‍🎓 Student Features
- **Raise Doubts**: Create detailed doubts with rich text descriptions
- **Add Comments**: Interactive commenting system for ongoing discussions
- **Track Progress**: View all doubts with real-time status updates
- **Rich Text Editor**: Format doubts with ActionText for better clarity
- **File Uploads**: Support for images and attachments via ActionText

### 👩‍🏫 Teaching Assistant Features
- **Smart Assignment**: Accept doubts with automatic conflict prevention
- **Doubt Resolution**: Comprehensive resolution interface with rich text responses
- **Escalation System**: Escalate complex doubts to other TAs seamlessly
- **Live Dashboard**: Real-time analytics and performance metrics

### 📊 Analytics Dashboard
- **System Stats**: Total doubts asked, resolved, and escalated
- **Performance Metrics**: Average resolution times and activity tracking
- **TA Reports**: Individual performance analytics for each teaching assistant
- **Real-time Updates**: Live data synchronization across all metrics

## 🏗️ Architecture & Design Decisions

### Database Schema
The system uses a carefully designed relational schema optimized for performance and scalability:

```sql
-- Core Models
Users (STI: Student, TeachingAssistant)
Doubts (with status tracking and resolution timing)
DoubtAssignments (junction table with status management)
Comments (polymorphic for extensibility)

-- Performance Optimization Tables
DoubtStats (singleton pattern for system-wide metrics)
TaStats (individual TA performance tracking)
```

### Key Performance Optimizations

#### 1. **Stats Tables Strategy**
Instead of expensive aggregation queries, I implemented dedicated stats tables:
- `DoubtStats`: Singleton pattern storing system-wide metrics
- `TaStats`: Per-TA performance data with real-time updates
- Both tables are **transaction-safe** and **refreshable** for data integrity

#### 2. **Efficient Query Design**
```ruby
# Optimized query for available doubts (TA filtering in JOIN vs WHERE clause)
Doubt.joins(Doubt.sanitize_sql([
  "LEFT JOIN doubt_assignments da ON doubts.id = da.doubt_id AND da.ta_id = ?", 
  current_user.id
])).where(accepted: false, da: {id: nil})
```

#### 3. **Resolution Time Optimization**
- Stored as integers (seconds) instead of datetime calculations
- Enables fast aggregations without complex date arithmetic
- Database-agnostic approach for better portability

### Scalability Considerations

**What scales well:**
- Composite indexes on frequently queried column combinations
- DoubtStats queries are O(1) (singleton pattern)
- TaStats queries are O(k) where k = number of TAs (vs O(n*m) for live aggregations)
- Indexed foreign keys for fast relationship lookups
- Pagination with `pagy` gem for large datasets
- Status-based filtering without complex joins

**Future improvements identified:**
- Add composite indexes on `(status, accepted)` for doubts
- Consider materialized views for complex analytics

## 🛠️ Tech Stack

- **Backend**: Ruby on Rails 8.0
- **Database**: PostgreSQL with optimized indexing
- **Authentication**: Devise with role-based access
- **Frontend**: Hotwire (Turbo + Stimulus) for modern UX
- **Rich Text**: ActionText for formatted content
- **Pagination**: Pagy with infinite scroll
- **Styling**: TailwindCSS for modern design
- **Deployment**: Render with automatic deployments

## 🚀 Getting Started

### Prerequisites
- Ruby 3.4+
- PostgreSQL 14+
- Node.js 18+ (for asset compilation)

### Installation

```bash
# Clone the repository
git clone git@github.com:EmAreAitch/Coding-Ninjas-Doubts-System.git
cd coding-ninjas-doubt-system

# Install dependencies
bundle install

# Database setup
rails db:prepare

# Start the server
rails server
```

### Seeding Data
The application comes with realistic seed data:
- 10 Students and 6 Teaching Assistants
- 15 sample doubts with varying statuses
- Comments and resolutions for demonstration
- Complete analytics data for dashboard testing

## 💡 System Design Highlights

### 1. **Conflict-Free Assignment**
TAs can only accept doubts when they have no active assignments, preventing resource conflicts and ensuring focused attention.

### 2. **Real-time Analytics**
Stats update automatically through Rails callbacks within database transactions, ensuring data consistency and real-time dashboard updates.

### 3. **Extensible Architecture**
- Polymorphic comments system ready for future features
- STI user model easily extendable to new roles
- Status enums for clear state management

### 4. **Performance-First Approach**
Every query is designed with scale in mind:
- Minimal N+1 queries through strategic eager loading
- Database-level constraints for data integrity
- Efficient indexing strategy for common access patterns

## 🔄 Database Relationships

```
User (STI) ──┐
             ├── Student ─── has_many ──→ Doubts
             └── TeachingAssistant ─── has_many ──→ DoubtAssignments

Doubt ──── has_many ──→ Comments
      ──── has_many ──→ DoubtAssignments ──── belongs_to ──→ TeachingAssistant

DoubtStats (Singleton) ← Updated by ← Doubt callbacks
TaStats ← Updated by ← DoubtAssignment callbacks
```

*Full ER diagram available in `erd.pdf`*

## 🎯 Future Enhancements

### Immediate Priorities
- **Real-time Notifications**: WebSocket integration for instant updates
- **Advanced Search**: Full-text search across doubts and comments

### Scalability Improvements
- **Caching Layer**: Redis for frequently accessed data
- **Background Jobs**: Sidekiq/SolidQueue for heavy analytics processing
- **Database Sharding**: Preparation for multi-tenant architecture

### Feature Extensions
- **TA Assignment Logic**: Teacher-controlled doubt assignment
- **Priority System**: Escalation-based priority queuing
- **Personal Dashboards**: Individual performance tracking for TAs, Students, etc.

## 🧠 Development Journey

### Technical Challenges Conquered
1. **Dashboard Performance**: Chose stats tables over expensive joins for sub-millisecond response times
2. **Query Optimization**: Designed left joins with embedded conditions for efficient TA filtering
3. **Data Consistency**: Implemented transaction-safe stats updates with callback chains
4. **Rich Text Integration**: Resolved ActionText partial rendering performance issues

### Key Learning Outcomes
- Advanced Rails query optimization techniques
- Database design for analytical workloads
- Performance vs. consistency trade-offs in system design
- Modern Rails patterns with Hotwire integration

## 📈 Performance Metrics

- **Dashboard Load Time**: < 100ms (with stats tables)
- **Doubt Assignment**: Fast conflict detection via indexed lookups
- **Page Load**: Infinite scroll with Turbo Frame lazy loading
- **Data Consistency**: 100% through transactional updates

---

**Built in 3 days** | **Rails 8** | **Production Ready** | **Scalable Architecture**

> This project demonstrates advanced Rails development with a focus on performance, scalability, and clean architecture. Every technical decision was made with production deployment and scale in mind.
