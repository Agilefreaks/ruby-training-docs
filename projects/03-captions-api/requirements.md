# Captions API

The purpose of the this project is to continue implementation of Meme API and transform it into a usable product.

## General Considerations

*Unique names*

Make sure you handle the situation where two different users will try to generate images for the same URL/file name but with different caption text. You need to find a way to generate some unique names for the generated images.

*Response status*

If the request is successful, the response status will be `200`.

If the request was for creating a new object (like `POST /captions` or `POST /captions/instagram`) the response status will be `201`.

If a resource is not found, then the response status will be `404`. This should happen every time someone wants to get an object by id and there is no object with that id.

When fetching a collection (like `GET /captions`) if there are no objects found, then the response status will be `200` and the body will contain an empty array. Eg. `{ captions: [] }`.

If the request does not contain the required parameters, or their name is incorrect (eg: sending `uri` instead of `url` attribute in request body or not sending at all this parameters) the server should respond with `400`. More details about 400 status code [here](https://datatracker.ietf.org/doc/html/rfc7231#section-6.5.1).

If the request contains the required parameters and their name is correct but their value is invalid (eg: sending an empty string in `url`) the server response should be `422`. More details about 422 status code [here](https://datatracker.ietf.org/doc/html/rfc4918#section-11.2).

*Error response body*

When the response is `4xx` then the response body should contain an error object:

```json
{
  "code": "missing_parameters",
  "title": "Parameter is missing from the request body",
  "description" "url parameter is missing from the request body. It is a required parameter and the request cannot be processed without it"
}
```

More details about these object propertiers [here](https://jsonapi.org/format/#errors).

## Simple Captions

### POST /captions

Request:

```
POST /captions
```
with the following body:

```json
{
  "caption": {
    "url": "http://image.url",
    "text": "caption text"
  }
}
```


The server will generate a new image that will have the text specified by `text` added as caption on top of the image specified by `url`.

The response will be:
```json
{
  "caption": {
    "id": 123,
    "url": "http://image.url/meme.jpg",
    "text": "caption text",
    "caption_url": "http://example.com/images/meme.jpb"
  },
}
```
The response status will be: 303 and should contain in `Location` header field the `caption_url`.

Attributes:
- `id` - is an unique ID that uniquely identifies a generated simple caption
- `url` - is an URL of an image. Accepted mime types `image/jpg`, `image/jpeg` and `image/png`
- `text` - a string of maximum 266 chars that will be added on the image
- `caption_url` - the URL of the generated image. This will be served by your Rails server.

### GET /captions

Will return a list of all generated simple captions.

The responde body will be a JSON with the following structure:

```json
{
  "captions": [
    {
      "id": 123,
      "url": "",
      "text": "",
      "caption_url": ""
    },
    {
      "id": 124,
      "url": "",
      "text": "",
      "caption_url: ""
    }
  ]
}
```

where:
- `id` is the generated unique ID
- `url` is the original URL of the image submitted by the user
- `text` is the text that should be added on the image
- `caption_url` is the URL of the generated image

### GET /captions/:id

Will return the attributes for the caption with id `:id`
```json
{
  "caption": {
    "id": 123,
    "url": "http://image.url/meme.jpg",
    "text": "caption text",
    "caption_url": "http://<your rails server hostname>/images/meme.jpb"
  },
}
```

### DELETE /captions/:id
Will delete the caption with that ID and its associated files.
The response will be `:200` if the delete was successful.

## Instagram Captions

This endpoint should generate imags that are the right size for the instagram.
See details about images sizes [here](https://help.instagram.com/1631821640426723).

So this enpoint will do the following flow:
- download provided image
- resize to the proper image width and height
- apply filter to the resized image
- add the caption text
- save the image to a location that will be served by rails server


### POST /captions/instagrams

#### Request

```
POST /captions/instagram
```
with the following request body:

```json
{
  "image": {
    "type": "image",
    "url": "http://image.url",
    "text": "caption text",
    "filter": "blackwhite",
  }
}
```

Explanation of attributes:

`url` - URL for an image
`text` - the caption text to be added on the image

`type` attribute can be one of the following strings:
- `image`
- `color`
- `gradient`

When type is `image` this means that an image will be provided as URL with `url` attribute and the API should use that as background image.

Example of request:
```json
{
  "image": {
    "type": "image",
    "url": "http://image.url",
    "text": "caption text"
  }
}
```

When type is `color` this means that there will not be provided an image, but a `color` attribute in HEX format and that will be used to generate a background with that color:

```json
{
  "image": {
    "type": "color",
    "color": "#003166",
    "text": "caption text"
  }
}
```

When type is `gradient` this means that there will be two attributes `start_color` and `end_color` which will provide two colors in HEX format and those will be used to generate a background

```json
{
  "image": {
    "type": "gradient",
    "start_color": "#000000",
    "end_color": "#003166",
    "text": "caption text",
  }
}
```

will generate a gradient background from white to blue with the text in the middle.

`filters`

Filters will be a list of filters that can be applied to an image before adding the text.
`filter` attribute can miss. But if present it should not be an empty array.

The supported filters will be:
- `blackwhite` - will make the image black and white, this should be allowed only when `type` is `image`
- `light_blur` - will add a small blur the image, this should be allowed only with `type` = `image`
- `hard_blur` - will add a deep blur to the image, this should be allowed only with `type` = `image`


#### Response

The response will be:
```json
{
  "caption": {
    "id": 123,
    "url": "http://image.url/meme.jpg",
    "type": "image",
    "text": "caption text",
    "filter": "blackwhite",
    "caption_url": "http://example.com/images/meme.jpb"
  },
}
```
The response status will be: 303 and should contain in `Location` header field the `caption_url`.

Attributes:
- `id` - is an unique ID that uniquely identifies a generated simple caption
- `url` - is an URL of an image. Accepted mime types `image/jpg`, `image/jpeg` and `image/png`
- `text` - a string of maximum 266 chars that will be added on the image
- `type` - the type as requested by the user
- `filter` - the filters as requested by the user
- `caption_url` - the URL of the generated image. This will be served by your Rails server.


### GET /captions/instagrams

This will return a list of images in JSON format.
