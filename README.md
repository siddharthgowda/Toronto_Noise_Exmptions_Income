# Are Noise Exemptions more common in lower-income and Minority Communities?

## Overview

The repository contains all documents related to this paper about the relationship between noise exemptions in Toronto and lower-income and minority communities. Further details about what exactly is contained in the repo is in the file structure section. All aspects of this file are reproducible. If you want to reproduce some results, you should take a look at the scripts folder first so you can download the data.


## File Structure

The repo is structured as:

-   `data/raw_data` contains the raw data for both the noise permit exemptions and 2011 census. All data was from Open Data Toronto.
-   `data/analysis_data` contains the cleaned dataset that was constructed.
-   `other` contains details about LLM chat interactions and sketches of tables and figures.
-   `paper` contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper. 
-   `scripts` contains the R scripts used to simulate, download, clean data, and run data sanity tests.


## Statement on LLM usage

Aspects of the code were written with the help of chatgpt. The entire chat history is available in inputs/llms/usage.txt.