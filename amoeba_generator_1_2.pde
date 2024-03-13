/*
(C) 2024 Zyfn Kothavala and TU/e, for use in Challenge 1 for DBB100 Creative Programming
amoeba_generator_1_2.pde
Works with Processing 4

This program uses Perlin Noise through the inbuilt noise() function to procedurally generate numerous different amoeboid shapes on a 3000*3000 canvas.

Several factors of the generation can be controlled, which are
a. Number of pages generated in PDF
b. Background color of the generation (min. RGB value)
c. Number of amoeba in the generation (min. and max.)
d. Size of amoeba in the generation (min. and max.)
e. Opacity of the amoeba generated (min.% and max.%)
f. Scale of noise (min. and max.)
g. Noise scale multiplier within each amoeba (min. and max.)
h. Angle interval between vertices of amoeba (min. and max.)

The output consists of the following: 
a. A PDF file (amoebas.pdf) containing pages with all the generations
c. TXT file (amoeba_parameters.txt) containing parameters used for overall generation as well as for each amoeba

A few .txt files in the 'alternate parameters' folder give alternate options for parameters to use that also look cool!

WARNING: Large generations with a lot of pages or large numbers of amoeba can take a while to complete generating! 
         The PDF document may show up in the folder, but you will not be able to open it until all the pages are created!

*/

import processing.pdf.*;

PrintWriter output;  //To generate text file with parameters

//The following values for the random variables have been extracted through trial and error and provide cool shapes! Other values may work well, or produce vastly different results.

//START OF PARAMETERS LIST

final int NUM_IMAGES = 25;  //Number of images to create

final int BG_COLOUR = 200;  //Minimim R/G/B value for background color

//Min/Max numbers of amoebas to draw
final int NUM_AMOEBA_MIN = 50;
final int NUM_AMOEBA_MAX = 600;

//Min/Max size of amoebas to draw
final int SIZE_AMOEBA_MIN = 100;
final int SIZE_AMOEBA_MAX = 800;

//Mean and Std. Dev. to use for Normal Distribution of Sizes of Amoebas
final int GAUSSIAN_MEAN = (SIZE_AMOEBA_MAX - SIZE_AMOEBA_MIN) / 2;
final int GAUSSIAN_SD = GAUSSIAN_MEAN / 2;

//Min/Max opacity of amoebas [opacity% * 255]
final int OPACITY_AMOEBA_MIN = (int) (0.05*255);
final int OPACITY_AMOEBA_MAX = (int) (0.8*255);

//Min/Max values for noise scale
final float NOISE_SCALE_MIN = 0.2;
final float NOISE_SCALE_MAX = 8;

//Min/Max values for noise scale multiplier
final int NOISE_SCALE_MULT_MIN = 50;
final int NOISE_SCALE_MULT_MAX = 100;

//Min/Max angle interval (radians) between points on shape
final float ANGLE_INTERVAL_MIN = 0.2;
final float ANGLE_INTERVAL_MAX = 0.4;

//END OF PARAMETERS LIST 

void setup()
{
  size(3000, 3000, PDF, "amoebas.pdf");  //Canvas of size 3000*3000 and creates pdf file 'amoebas.pdf'

  generateParametersFile();  //Generates file with constant value parameters

}

void draw()
{
  for(int i = 0; i < NUM_IMAGES; i++)
  {
    PGraphicsPDF pdf = (PGraphicsPDF) g;  //Object used to generate multi-page PDF

    // Generate random background color with opacity
    color bgColor = color(random(BG_COLOUR, 255), random(BG_COLOUR, 255), random(BG_COLOUR, 255));
    background(bgColor); // Set background color

    int numAmoebas = (int)random(NUM_AMOEBA_MIN, NUM_AMOEBA_MAX); // Number of amoebas

    for (int j = 0; j < numAmoebas; j++)
    {
      float x = random(width); // Random x-coordinate
      float y = random(height); // Random y-coordinate

      // Generate size with Gaussian distribution
      float randomSize = (randomGaussian() * GAUSSIAN_SD) + GAUSSIAN_MEAN; // Gaussian distribution with mean and standard deviation
      float size = constrain(randomSize, SIZE_AMOEBA_MIN, SIZE_AMOEBA_MAX); // Size constrained
      float opacity = random(OPACITY_AMOEBA_MIN, OPACITY_AMOEBA_MAX); // Random opacity
      color amoebaColor = randomColor(opacity); // Random color with specified opacity

      //Add details of current amoeba to parameters file
      output.println("Amoeba " + j + ":     POS = " + x + ", " + y + "    SIZE = " + size + "    OPACITY = " + opacity + "    COLOR = " + amoebaColor);

      // Draw random amoeba
      drawAmoeba(x, y, size, amoebaColor);

      output.println();  //Prints blank line to parameters file
    }

    clear();
    if(i != NUM_IMAGES - 1)
    {
      pdf.nextPage();  //Creates new page in PDF unless it is the last generation
    }

  }
  
  //After all pages are generated, closes .txt file and exits program
  output.flush();
  output.close();
  exit();
}


//Draws amoeba shape
void drawAmoeba(float x, float y, float size, color amoebaColor)
{
  fill(amoebaColor); // Set fill color
  noStroke(); // No outline
  
  beginShape();//Starts shape generation

  float noiseScale = random(NOISE_SCALE_MIN, NOISE_SCALE_MAX);  //noise scale affects the amount of detail in the output shape
  float noiseScaleMultiplier = noiseScale / random(NOISE_SCALE_MULT_MIN, NOISE_SCALE_MULT_MAX);  //used to vary the noise scale by a small amount at every point while generating shape, to induce randomness
  // Adjust the noise scale for the desired level of detail

  for (float angle = 0; angle < TWO_PI; angle += random (ANGLE_INTERVAL_MIN, ANGLE_INTERVAL_MAX))  //Loop to generate points of shape
  {
    float previousNoiseScale = noiseScale;
    noiseScale = random(previousNoiseScale - noiseScaleMultiplier, previousNoiseScale + noiseScaleMultiplier);  //varying noise scale

    float rad = size * noise(cos(angle) * noiseScale, sin(angle) * noiseScale);  //calculating radius of shape at current point where [radius = size * noise * noiseScale]

    //calculates current x and y coordinates on canvas using trigonometry
    float xPos = x + rad * cos(angle);
    float yPos = y + rad * sin(angle);

    //Create curve between last pairs of x-y coordinates
    curveVertex(xPos, yPos);

    //Add details fo current vertex of amoeba to parameters file
    output.println("\t\t ANGLE INTERVAL = " + angle + "    NOISE SCALE = " + noiseScale + "    RADIUS = " + rad + "    VERTEX = " + xPos + ", " + yPos);
  }
  endShape(CLOSE); // Close shape
}

//Generates a random color for the amoeba
color randomColor(float alpha)
{
  return color(random(255), random(255), random(255), alpha); // Random color with specified opacity
}

void generateParametersFile()  //Creates text file with parameters for the generation
{
  output = createWriter("amoeba_parameters.txt");

  output.println("NUM_IMAGES = " + NUM_IMAGES);
  output.println("BG_COLOUR = " + BG_COLOUR);

  output.println("NUM_AMOEBA_MIN = " + NUM_AMOEBA_MIN);
  output.println("NUM_AMOEBA_MAX = " + NUM_AMOEBA_MAX);

  output.println("SIZE_AMOEBA_MIN = " + SIZE_AMOEBA_MIN);
  output.println("SIZE_AMOEBA_MAX = " + SIZE_AMOEBA_MAX);

  output.println("GAUSSIAN_MEAN = " + GAUSSIAN_MEAN);
  output.println("GAUSSIAN_SD = " + GAUSSIAN_SD);

  output.println("OPACITY_AMOEBA_MIN = " + OPACITY_AMOEBA_MIN);
  output.println("OPACITY_AMOEBA_MAX = " + OPACITY_AMOEBA_MAX);

  output.println("NOISE_SCALE_MIN = " + NOISE_SCALE_MIN);
  output.println("NOISE_SCALE_MAX = " + NOISE_SCALE_MAX);

  output.println("NOISE_SCALE_MULT_MIN = " + NOISE_SCALE_MULT_MIN);
  output.println("NOISE_SCALE_MULT_MAX = " + NOISE_SCALE_MULT_MAX);

  output.println("ANGLE_INTERVAL_MIN = " + ANGLE_INTERVAL_MIN);
  output.println("ANGLE_INTERVAL_MAX = " + ANGLE_INTERVAL_MAX);

  output.println("\n");
}
