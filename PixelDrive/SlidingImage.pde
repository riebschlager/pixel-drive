public class SlidingImage {

  int width, height, nextSlice;
  PImage[] slices;
  float time;
  PGraphics composite;

  SlidingImage(int _width, int _height) {
    width = _width;
    height = _height;
    time = random(10);
    composite = createGraphics(width, height);
  }

  void setup(String _source, int _fadeTop, int _fadeBottom) {

    // Load the source image and blur it a bit.
    PImage img = loadImage(_source);
    img.filter(BLUR, 2);

    // Create an ARGB image so we can futz with transparency.
    // Then draw the source image to it.
    PImage canvas = createImage(img.width, img.height, ARGB);
    canvas.set(0, 0, img);

    // Create an array to hold all our slices.
    slices = new PImage[canvas.width];

    // Loop through the image and create a vertical slice for
    // each pixel of the source image's width
    for (int i=0; i<slices.length; i++) {
      slices[i] = canvas.get(i, 0, 1, canvas.height);
      // Now that we have a slice, let's fade the top and bottom
      for (int j=0; j<slices[i].pixels.length; j++) {
        int pixel = slices[i].pixels[j];
        int a = 255;
        if (j < _fadeTop) {
          a = (int) map(j, 0, _fadeTop, 0, 255);
        } 
        else if (j > slices[i].pixels.length - _fadeBottom) {
          a = (int) map(j, slices[i].pixels.length - _fadeBottom, slices[i].pixels.length, 255, 0);
        }
        slices[i].pixels[j] = color(red(pixel), green(pixel), blue(pixel), a);
      }
    }
  }

  void draw(float _timeIncrement, int _sliceStep, String _position) {
    // Grab the next slice
    nextSlice = (nextSlice < slices.length - _sliceStep) ? nextSlice + (int) random(_sliceStep) : 0;
    // Pick a random pixel. We'll use it to set the composite background.
    int pixel = slices[nextSlice].pixels[(int) random(slices[nextSlice].pixels.length)];
    composite.beginDraw();
    composite.background(red(pixel), green(pixel), blue(pixel), 5);
    // For each pixel of width, draw a slice. Nudge it with some noise.
    for (int i=0; i < width; i++) {
      float sliceHeight = map(noise(time), 0, 1, 0, height);
      if (_position == "top") {
        composite.image(slices[nextSlice], i, 0, 1, sliceHeight*2);
      }
      if (_position == "bottom") {
        composite.image(slices[nextSlice], i, height-sliceHeight, 1, sliceHeight);
      }
      time += _timeIncrement;
    }
    composite.endDraw();
  }
}

