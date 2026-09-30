-- PostgreSQL Schema for Support Ticket Automation
CREATE TABLE IF NOT EXISTS public.tickets (
    ticket_id VARCHAR(50) PRIMARY KEY,
    requester_name VARCHAR(100),
    email VARCHAR(100),
    ticket_title VARCHAR(255),
    description TEXT,
    category VARCHAR(50),
    priority VARCHAR(20),
    status VARCHAR(20),
    assigned_team VARCHAR(50),
    created_at TIMESTAMP
);
