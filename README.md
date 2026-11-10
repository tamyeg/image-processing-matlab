# Image Processing Algorithms in MATLAB

**MATLAB | Image Processing | Computer Vision | Convolution | Gaussian Filtering | Mathematical Morphology**

## Overview

This project explores the implementation and evaluation of fundamental digital image processing algorithms using MATLAB.

Five image processing techniques were implemented manually and compared with MATLAB's built-in functions to understand their mathematical principles, practical applications, and effects on image quality.

The experiments were conducted using two photographs converted to grayscale. Different filtering kernels and structuring element sizes were evaluated to investigate how processing parameters influence image appearance.

The project focuses on implementing algorithms from scratch, analyzing their behavior, and comparing the results with established MATLAB implementations.

## Project Objectives

- Implement fundamental image processing algorithms manually in MATLAB.
- Understand pixel intensity transformations and spatial filtering.
- Investigate the effects of convolution and Gaussian smoothing.
- Explore grayscale morphological operations.
- Compare different kernel and structuring element sizes.
- Validate manual implementations against MATLAB's built-in functions.
- Analyze the visual differences between original and processed images.

## Implemented Algorithms

### 1. Histogram Normalization

Histogram normalization adjusts image intensities to cover the available grayscale range.

The algorithm identifies the minimum and maximum pixel intensities and applies linear intensity scaling to map them into the range [0, 255].

**Implementation:**

- Convert input photographs to grayscale.
- Determine the minimum and maximum pixel intensity values.
- Apply manual normalization using nested loops.
- Display the original and normalized images.
- Compare their intensity histograms.
- Compare the manual implementation with MATLAB's `imadjust()` function.

**Observations:**

Normalization stretches the original intensity range and can improve contrast when the available grayscale range is not fully utilized.

The extent of visual improvement depends on the original image's intensity distribution.

### 2. Convolution: Averaging and Sharpening

Convolution is a spatial filtering technique that applies a kernel to neighboring pixel values.

Two 3×3 convolution kernels were implemented.

**Averaging Filter**

The averaging filter calculates the mean of neighboring pixel intensities.

Kernel:

```text
1/9 × [1 1 1
       1 1 1
       1 1 1]
```

This operation reduces local intensity variations and smooths the image.

**Sharpening Filter**

The sharpening filter emphasizes local intensity differences and image edges.

Kernel:

```text
[ 0 -1  0
 -1  5 -1
  0 -1  0]
```

**Implementation:**

- Implement convolution manually using nested loops.
- Apply averaging and sharpening filters.
- Compare the results with MATLAB's `imfilter()` function.
- Examine the effects of filtering on image details and edges.

**Observations:**

- Averaging reduces local variations but also blurs fine details.
- Sharpening enhances edges and object boundaries.
- Sharpening may amplify noise and intensity variations.
- The manual and built-in implementations produce comparable results when their boundary handling is aligned.

### 3. Gaussian Averaging

Gaussian filtering performs weighted image smoothing using a Gaussian distribution.

Unlike a uniform averaging filter, a Gaussian kernel assigns higher weights to pixels near its center.

**Experimental parameters:**

| Parameter | Value |
|---|---|
| Standard deviation (σ) | 1 |
| Kernel sizes | 3×3 and 5×5 |
| Kernel normalization | Sum of weights = 1 |

**Implementation:**

- Generate Gaussian kernels manually using the Gaussian exponential function.
- Normalize kernel weights.
- Apply convolution through nested loops.
- Compare 3×3 and 5×5 Gaussian filters.
- Validate results using MATLAB's `fspecial()` and `imfilter()` functions.

**Observations:**

- Gaussian filtering reduces high-frequency intensity variations.
- A 3×3 kernel provides relatively localized smoothing.
- A 5×5 kernel incorporates a larger neighborhood and produces a stronger overall smoothing effect.
- Increasing the kernel size can reduce fine image details.

### 4. Morphological Erosion

Grayscale erosion replaces each pixel with the minimum intensity value from a defined neighborhood.

The operation was implemented using square structuring elements.

**Experimental parameters:**

- 3×3 structuring element
- 5×5 structuring element

**Implementation:**

- Define the neighborhood around each pixel.
- Identify the minimum intensity within the neighborhood.
- Assign the minimum value to the output pixel.
- Compare the manual implementation with MATLAB's `imerode()` function.

**Observations:**

- Erosion expands darker image regions.
- Small bright features may shrink or disappear.
- A 5×5 structuring element produces a stronger effect than a 3×3 element.
- The choice of neighborhood size significantly affects the processed image.

### 5. Morphological Dilation

Grayscale dilation replaces each pixel with the maximum intensity value from its neighborhood.

The operation was implemented using square structuring elements.

**Experimental parameters:**

- 3×3 structuring element
- 5×5 structuring element

**Implementation:**

- Define the neighborhood around each pixel.
- Identify the maximum intensity within the neighborhood.
- Assign the maximum value to the output pixel.
- Compare the manual implementation with MATLAB's `imdilate()` function.

**Observations:**

- Dilation expands brighter image regions.
- Small dark regions may shrink or disappear.
- Larger structuring elements produce more pronounced changes.
- Dilation has the opposite local intensity effect to erosion.

## Experimental Setup

The experiments were performed using two input photographs:

- `Photo1.jpg`
- `Photo2.jpg`

Both images were converted to grayscale before processing.

For convolution, Gaussian filtering, erosion, and dilation, images were resized to 25% of their original dimensions to reduce computational requirements.

Manual implementations were compared with MATLAB's built-in image processing functions.

### MATLAB Functions Used

| Function | Purpose |
|---|---|
| `imread()` | Read input images |
| `rgb2gray()` | Convert RGB images to grayscale |
| `imhist()` | Display intensity histograms |
| `imresize()` | Resize images |
| `imadjust()` | Intensity normalization |
| `imfilter()` | Spatial filtering |
| `fspecial()` | Generate Gaussian kernels |
| `imerode()` | Morphological erosion |
| `imdilate()` | Morphological dilation |
| `imshow()` | Display images |

## Results and Discussion

The experiments demonstrate how different image processing techniques modify pixel intensities, local structures, and visible image details.

| Algorithm | Main Effect |
|---|---|
| Histogram normalization | Expands the grayscale intensity range |
| Averaging filter | Reduces local intensity variations |
| Sharpening filter | Enhances edges and fine details |
| Gaussian averaging | Produces weighted smoothing |
| Erosion | Expands dark regions and reduces bright features |
| Dilation | Expands bright regions and reduces dark features |

### Comparison with MATLAB Built-in Functions

Manual implementations were compared visually with MATLAB's corresponding built-in operations.

The implementations use matching filter parameters and adjusted boundary handling where applicable.

This comparison helps demonstrate the relationship between manually implemented image processing algorithms and MATLAB's optimized functions.

### Effect of Kernel Size

The experiments also investigate the influence of neighborhood size.

A larger Gaussian kernel incorporates more surrounding pixels, while larger morphological structuring elements produce stronger modifications to local image structures.

These experiments illustrate the trade-off between processing strength and the preservation of image details.

## Technologies and Tools

- **MATLAB** — algorithm implementation and visualization
- **Image Processing Toolbox** — built-in functions for validation
- **Digital Image Processing** — intensity transformations and spatial filtering
- **Mathematical Morphology** — grayscale erosion and dilation

## How to Run

### Requirements

- MATLAB
- MATLAB Image Processing Toolbox

### Instructions

1. Clone the repository:

   ```bash
   git clone https://github.com/tamyeg/image-processing-matlab.git
   ```

2. Open the repository folder in MATLAB.

3. Ensure that the following files are available in the same directory:

   ```text
   image_processing.m
   Photo1.jpg
   Photo2.jpg
   ```

4. Run the MATLAB script:

   ```matlab
   run('image_processing.m')
   ```

5. Examine the generated figures showing original images, processed images, histograms, and comparisons with MATLAB's built-in functions.

## Key Learning Outcomes

Through this project, I gained practical experience in:

- Implementing image processing algorithms without relying entirely on built-in functions.
- Understanding how pixel-level operations affect image appearance.
- Applying convolution kernels for smoothing and sharpening.
- Constructing and normalizing Gaussian filters.
- Implementing grayscale erosion and dilation.
- Investigating how kernel and structuring element sizes influence results.
- Comparing custom algorithms with established MATLAB functions.
- Interpreting and visualizing experimental results.

## Future Improvements

Potential improvements include:

- Implementing additional morphological operations, such as opening and closing.
- Evaluating alternative structuring element shapes.
- Comparing manual and built-in implementations quantitatively.
- Measuring execution times and computational efficiency.
- Extending experiments to color images.
- Investigating adaptive image enhancement and filtering methods.

## Author

**Tamara Yegorova**

MSc Artificial Intelligence in Computer Science  
Kaunas University of Technology

[GitHub](https://github.com/tamyeg) | [LinkedIn](https://www.linkedin.com/in/tamara-yegorova/)
