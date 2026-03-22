# MATLAB Optical Character Recognition (OCR) System

This project implements a custom OCR engine in MATLAB, designed to convert scanned images of English text into editable digital format. The system utilizes image processing techniques and correlation based classification to achieve high accuracy.

##Features
* **Custom Character Database**: Automatically generates a reference database from a template image.
* **Line & Character Segmentation**: Uses horizontal and vertical projection (summation) to isolate text lines and individual characters.
* **Intelligent Spacing**: An algorithm that calculates the maximum gap in a line to accurately insert spaces between words.
* **Special Character Handling**: Includes logic to handle multi-object characters like 'i' and 'j' by analyzing height ratios.
* **High Accuracy**: Achieved up to 100% accuracy on standard test cases with high-quality input.

## Project Assumptions
To ensure optimal performance, the following conditions are assumed:
* **Language**: English only.
* **Font**: Consolas Bold.
* **Content**: No punctuation or numbers.
* **Quality**: High-resolution input images.

## Performance & Results
The system was tested on various datasets with the following results:
| Test Case | Accuracy | Execution Time | Character Size |
| :--- | :--- | :--- | :--- |
| Lowercase only | 100% | 1.56s | 30x23 |
| Uppercase only | 99.69% | 1.32s | 13x9 |
| Mixed Paragraphs | 99.48% | 4.50s | 16x13 |

*Note: Minor errors in uppercase recognition were occasionally due to morphological similarities between characters (e.g., 'U' vs 'V')*

## How to Use
1. Ensure `project.m` and the template image `ABC_consolas_bold.png` are in the same directory.
2. Update the `input` variable in `project.m` with your image filename (e.g., `text1.png`).
3. Run the script.
4. The recognized text will be displayed in the command window and saved to `output.txt`.
