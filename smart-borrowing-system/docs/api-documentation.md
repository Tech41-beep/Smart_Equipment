# API documentation

Base path: `/api`

| Method | Path | Purpose |
| --- | --- | --- |
| GET | `/health` | Check API availability |
| GET | `/equipment` | List equipment; accepts optional `?search=` |

Equipment responses are JSON arrays with database fields. Authentication, borrowing, and admin mutation endpoints are planned and should be added with their corresponding validators, controllers, and services.

