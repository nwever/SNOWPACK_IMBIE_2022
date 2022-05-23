# SNOWPACK_IMBIE_2022

Workflow to calculate statistics for the IMBIE 2022 project from the SNOWPACK simulations performed for Antarctica and Greenland.

Steps to reproduce:
1) Execute the Jupyter Notebook ```create_point_lists.ipynb```, to create the mapping files between SNOWPACK simulations and the respective basins and ice sheets.
2) Execute ```bash postprocess.sh``` to postprocess the files.
3) Execute ```create_final.sh``` to create the files in the requested formatting from the postprocessed files.
