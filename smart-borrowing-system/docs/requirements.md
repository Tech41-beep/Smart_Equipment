# Requirements

## Roles
- **Administrator:** manage users, categories, equipment, QR identifiers, requests, checkouts, returns, and overdue records.
- **Borrower:** browse available equipment, request items, and track active and past borrowing.

## Core workflows
1. An administrator registers equipment and assigns an asset tag and optional QR code.
2. A borrower submits a request with one or more items and a due date.
3. An administrator approves or rejects the request.
4. Approved items are checked out; quantities are reserved and then deducted from availability.
5. Items are checked in on return. A scheduled job identifies checked-out records past their due date.

## Baseline quality requirements
- Validate request data at API boundaries and enforce role-based access for protected operations.
- Keep inventory quantities consistent when requests are approved, checked out, or returned.
- Record timestamps for request, checkout, and return events.
- Keep secrets and database configuration in environment variables.

