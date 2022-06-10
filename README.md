# Nikolay Rys' test task
## Requirements

- Build an API server with one of the following languages: Python, Go, Ruby on Rails, JS.
- The API server has to have a token based authentication.
- The API server only needs to have one endpoint that receives an array of URLs. Each of these URLs contain an image.
- The URLs need to be stored.
- The server should have a background process that takes the stored URLs, downloads and processes the binaries (reading the MIME type is sufficient for now).

## Installation                 
```
bundle install
bin/rake db:create
bin/rake db:schema:load
bin/rake jobs:work
bin/rails s
```

## Usage
After the server is running, for example on the default port http://127.0.0.1:3000 you can do the following.
1. Create a user: ```curl --location --request POST 'http://127.0.0.1:3000/users' \
--header 'Content-Type: application/json' \
--data-raw '{"user": {"email": "teemu@voima.com", "password": "secret", "password_confimarion": "secret"}}'```
 
2. If you missed the given token in the previous step, then you can login:  ```curl --location --request POST 'http://127.0.0.1:3000/users/login' \
--header 'Content-Type: application/json' \
--data-raw '{"user": {"email": "teemu@voima.com", "password": "secret"}}'```

3. Now you can upload images: ```curl --location -g --request POST 'http://127.0.0.1:3000/upload?urls[]=https://picsum.photos/200/300&urls[]=https://picsum.photos/300/200' \
--header 'Authorization: eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyfQ.L_w4vTbnWLz0zr4---mrCr6fbDMofP2y0gOFzmLzs8I' \
--data-raw ''```


## My comments
The task was pretty fun, I think i've covered all the requirements.
Naturally, there were some assumptions and limitations that I didn't cover.
For example, if I had more time, or this would be a real-world product, I would do the following:

- Configure the production environment, right now it's tested on development.
- Consider using a different storage engine, like Postgres and Redis
- Add expiration time to the JWT tokens
– Properly stub the HTTP requests in the tests
- Consider using different background processing libraries
- Add pepper to password hashing, since bcrypt doesn't do it by default
- Validate urls before storing them
- Filter out urls that already have been processed(I'm skipping them down the line for now, in the background job)
- Consider rate limiting to not let use the API as a DOS attack machine
- Consider connecting users and images - they exist independently now, because there were no requirement that would require it yet, but I'd expect to need it in such a service.

## Important files
### Migrations
  - db/migrate/20180502212051_create_users.rb
  - db/migrate/20180502212051_create_images.rb

### Models
  - app/models/user.rb
  - app/models/image.rb

### Controllers
  - app/controllers/images_controller.rb
  - app/controllers/users_controller.rb
  - app/controllers/concerns/secured.rb

### Jobs
  - app/jobs/scrape_job.rb

### Lib
  - app/lib/token_service.rb

### Spec
  - spec/lib/token_service_spec.rb
  - spec/jobs/scrape_job_spec.rb
  - spec/models/image_spec.rb
  - spec/models/user_spec.rb
  - spec/requests/images_controller_spec.rb
  - spec/requests/users_controller_spec.rb
