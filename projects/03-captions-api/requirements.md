# Captions API 

The purpose of the this project is to continue implementation of Meme API and transform it into a usable product.

## Simple Captions

### POST /captions

API client will do a request: 

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
and it will get back the image with the caption text on it so the response will be 303 and redirect to the image URL. 

### GET /captions

Will return a list of all generated simple captions.
The responde body will be JSON:

```json
{
  "captions": [
    {
      "id": 123,
      "url": "",
      "text": ""
    },
    {
      "id": 124,
      "url": "",
      "text": ""
    }
  ]
}
```

### GET /captions/:id
Will redirect to the generated image.

### DELETE /captions/:id
Will delete the caption with that ID and its associated files. 


## Instagram Captions

### POST /captions/instagrams

API client will do a request: 

```
POST /captions/instagram
```
with the following body: 

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
The response will the same as for the `POST /captions`

See details about images sizes [here](https://help.instagram.com/1631821640426723), you should crop the image accordingly with the image sizes. 

##### `type` 

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

##### `filters` 

Filters will be a list of filters that can be applied to an image before adding the text.

The supported filters will be:
- `blackwhite` - will make the image black and white, this should be allowed only when `type` is `image`
- `light_blur` - will add a small blur the image, this should be allowed only with `type` = `image`
- `hard_blur` - will add a deep blur to the image, this should be allowed only with `type` = `image`


### GET /captions/instagrams

This will return a list of images. 
