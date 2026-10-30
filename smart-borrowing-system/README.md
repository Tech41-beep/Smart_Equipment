# Smart Borrowing System

A web application for managing shared equipment inventory, borrower requests, checkouts, returns, and overdue items.

## Project structure

- `client/` — React and Vite single-page application.
- `server/` — Express REST API and Prisma data layer.
- `docs/` — requirements, data model, and API notes.

## Getting started

Install dependencies in each application:

```sh
cd client && npm install
cd ../server && npm install
```

Copy `server/.env.example` to `server/.env`, set `DATABASE_URL` and `JWT_SECRET`, then initialize the database:

```sh
cd server
npx prisma migrate dev --name init
npm run db:seed
npm run dev
```

In another terminal, start the client:

```sh
cd client
npm run dev
```

The API listens on port `4000` by default. The Vite development server proxies `/api` requests to it.

## Architecture

The client uses role-specific layouts and route groups. Pages call API modules in `client/src/services`; shared session state lives in context. The server follows a route → controller → service → Prisma flow, with authentication and role checks in middleware and request validation at API boundaries. Borrowing records provide the lifecycle for requests, approvals, checkouts, returns, and overdue tracking.

