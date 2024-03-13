# amoeba-generator

(C) 2024 Zyfn Kothavala and TU/e, for use in Challenge 1 for DBB100 Creative Programming
amoeba_generator_1_2
Works with Processing 4

----------------------------------------------------------------------------------------

Welcome to Amoeba Generator!

Source code: amoeba_generator_1_2.pde
Alternate parameters: FOLDER alternate parameters
Sample generations: FOLDER examples

----------------------------------------------------------------------------------------

INFO AND INSTRUCTIONS:

- This program uses Perlin Noise through the inbuilt noise() function to procedurally generate numerous different amoeboid shapes on a 3000*3000 canvas.

- Several factors of the generation can be controlled, which are
a. Number of pages generated in PDF
b. Background color of the generation (min. RGB value)
c. Number of amoeba in the generation (min. and max.)
d. Size of amoeba in the generation (min. and max.)
e. Opacity of the amoeba generated (min.% and max.%)
f. Scale of noise (min. and max.)
g. Noise scale multiplier within each amoeba (min. and max.)
h. Angle interval between vertices of amoeba (min. and max.)

- The output consists of the following: 
a. A PDF file (amoebas.pdf) containing pages with all the generations
c. TXT file (amoeba_parameters.txt) containing parameters used for overall generation as well as for each amoeba

- A few .txt files in the 'alternate parameters' folder give alternate options for parameters to use that also look cool!

- Some example creations to showcase the power of this pattern creator can be found in the 'examples' folder

----------------------------------------------------------------------------------------

WARNING: 
Large generations with a lot of pages or large numbers of amoeba can take a while to complete generating! 
The PDF document may show up in the folder, but you will not be able to open it until all the pages are created!

----------------------------------------------------------------------------------------

Have fun!

END
