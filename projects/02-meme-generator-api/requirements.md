# Meme Generator API

The purpose of the Meme Generator API is to provide a REST API to add text in the center of an image. 

## Resources

- [Sinatra](http://sinatrarb.com)
- [MiniMagick](https://rubygems.org/gems/mini_magick) - an interface from Ruby to ImageMagick (you can also use RMagick if this does not work)

## Prerequisites

To implement a REST API you need to know about HTTP, HTTP methods, HTTP authentication and HTTP status codes. 

Here are some resources to help you understand all these concepts: 

- https://www.youtube.com/watch?v=iYM2zFP3Zn0
- https://developer.mozilla.org/en-US/docs/Web/HTTP/Overview 
- https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods
- https://developer.mozilla.org/en-US/docs/Web/HTTP/Status


# Week 1:

### Endpoints

### POST /memes

This route will allow the user to send a link to an image and a text and in return it will get a redirect to the generated image. 

Example: 

Request: 

```
POST /memems
```

Request body 

```
{
  meme: {
    "image_url": "https://images.unsplash.com/photo-1647549831144-09d4c521c1f1",
    "text": "Start the way by organising your playground"
  }
}
```

Response: 

When successful, the response status should be 307 (temporary redirect) and the redirect URL should be the URL of the generated image. 

See in the `/examples` directory a simple sintra app that redirects to an image.

## Technical Specifications

### General logic flow

You should download the image locally in a folder. Hint you can use [OpenURI](https://ruby-doc.org/stdlib-3.1.0/libdoc/open-uri/rdoc/OpenURI.html) and then simple save the content to a file locally. 

Then convert it with ImageMagick via the Ruby gem. See the section below. 

Then serve the image to the end-user. See the example in the `02-meme-generatori-api/examples` directory.

### Command line example to add a text on an image

```bash
convert -font Helvetica -fill black -undercolor White -pointsize 60 -gravity center -draw "text 0,200 'Mornings are best'" original.jpeg meme.jpeg
```

In Ruby for MiniMagick you can use the `MiniMagick::Tool::Convert.new` which would accept similar attributes but it is in Ruby and you will not need to make a system call. 

Example:

```
image = MiniMagick::Image.new("./images/original.jpeg")
image.combine_options do |c|
  c.gravity "center"
  c.draw "text 0,200 'Mornings are best'"
  c.undercolor "White"
  c.fill "Black"
  c.font "Helvetica"
  c.pointsize "60"
end
image.write("./images/meme.jpeg")
```


# Week 2:

### Endpoints

### POST /signup

This endpoint will insert a user record in the database with the username and hashed password. 
The password needs to be hashed one way using the bcrypt gem. See the bcrypt example in `02-meme-generatori-api/examples/bcrypt`

Request body
```
{
  user: {
    "username": "mr_bean",
    "password": "test123"
  }
}
```

**Responses**

HTTP Status Code | Body | Description
--- | --- | ---
201 | { "user": { "token": "9411a3b57f420dc9c09a25bd78ae2851" } } | User created successfully |
400 | { "errors": [{"message": "Username is blank"}] } | Username blank |
400 | { "errors": [{"message": "Password is blank"}] } | Password blank |
409 | N/A | User with the same email already exists |

### POST /login

This endpoint will find the user record in the database by the username and verify if the password matches.
To check the password we need to use the bcrypt gem again.

**Request body**
```
{
  user: {
    "username": "mr_bean",
    "password": "test123"
  }
}
```

Responses:

HTTP Status Code | Body | Description
--- | --- | ---
200 | { "user": { "token": "9411a3b57f420dc9c09a25bd78ae2851" } } | User Logged in successfully successfully |
409 | N/A | User with the same email already exists |

### Features
Add authorization to the POST /meme endpoint by accepting an authorization header and verifying it against the users.

**Headers**
Authorization: Bearer <insert token from log in here>

**Request body**

```
{
  meme: {
    "image_url": "https://images.unsplash.com/photo-1647549831144-09d4c521c1f1",
    "text": "Start the way by organising your playground"
  }
}
```

Responses:

HTTP Status Code | Body | Description
--- | --- | ---
401 | N/A | User is not logged in |
307 | N/A | Meme created. User is redirected to the meme location |

