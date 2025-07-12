# Auth Project Setup Guide

This guide will help you set up and run the Auth Project Rails application on your local machine.

## Prerequisites

- **Ruby** (version 3.1 or later recommended)
- **Rails** (version 7 or later)
- **Bundler**
- **Node.js** and **Yarn** (for JavaScript dependencies)
- **PostgreSQL** (or your preferred database, update `config/database.yml` as needed)
- **ImageMagick** (for ActiveStorage/CarrierWave if using file uploads)

## 1. Clone the Repository

```
git clone <your-repo-url>
cd auth_project
```

## 2. Install Ruby Gems

```
bundle install
```

## 3. Install JavaScript Dependencies

```
yarn install
```

## 4. Set Up Database

- Create and migrate the database:

```
bin/rails db:create db:migrate
```

- (Optional) Seed the database:

```
bin/rails db:seed
```

## 5. Set Up Credentials

- Ensure you have `config/master.key` for Rails credentials.
- If missing, generate with:

```
bin/rails credentials:edit
```

## 6. Start the Rails Server

```
bin/rails server
```

Visit [http://localhost:3000](http://localhost:3000) in your browser.

## 7. Running Tests

```
bin/rails test
```

## 8. Additional Notes

- **Devise** is used for authentication. User registration and login are available at `/users/sign_up` and `/users/sign_in`.
- **Bootstrap** is included for styling.
- **ActiveStorage** or **CarrierWave** is used for file uploads (age verification, etc.).
- Organization membership supports join requests and approval flows.

## Troubleshooting

- If you encounter missing JS/CSS, ensure you have run `yarn install` and restarted the Rails server.
- For database errors, check your `config/database.yml` and ensure PostgreSQL is running.
- For file upload issues, ensure ImageMagick is installed.

---

For further help, see the code comments or contact the project maintainer.
