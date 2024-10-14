# Journal App
A simple Rails-based journal application that allows users to create, manage, and share their personal notes with attachments. The app integrates user authentication using Devise and Google OAuth2, with AWS S3 support for file storage.

## Features
User Authentication: Powered by Devise with Google OAuth2 support.
Note Creation: Users can create notes with a title, description, and file attachments (images, videos, PDFs, etc.).
File Attachments: Supports uploading and viewing images, videos, and other files with validation on file types and size (max 10 MB).
Public/Private Notes: Notes can be made public with a shareable URL or kept private.
AWS S3 Integration: Stores file attachments securely in AWS S3.
Grid Layout: Displays all notes in a grid format for easy viewing.
Dashboard: A dedicated dashboard for viewing shared journal entries.

## Prerequisites
Ruby 3.x
Rails 7.x
PostgreSQL

## Setup Instructions
1. Clone the repository

git clone https://github.com/your-username/journal-app.git
cd journal-app

2. Install Dependencies
Run the following command to install the required gems:

bundle install

3. Setup the Database
Make sure PostgreSQL is installed and running on your system. Then, create and migrate the database:

rails db:create
rails db:migrate


4. Precompile Assets
Precompile the assets before starting the server:

rails assets:precompile

5. Start the Rails Server
Run the server with:

rails server


Visit http://localhost:3000 to view the app.

## Usage
Signup/Login: Users can sign up using their email or Google account.
Create a Note: After login, users can create a new note by filling in the title, description, and attaching files (images, videos, PDFs, etc.).
Edit/Delete Notes: Users can edit or delete their existing notes.
Public/Private Notes: Toggle between public (shareable) and private (personal) visibility for each note.
Share Notes: If a note is public, a shareable URL is generated to allow others to view the note.


