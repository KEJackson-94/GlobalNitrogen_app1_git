# GlobalNitrogen_app1_git
This is a draft application currently pushed to shiny.io (https://environ-sci-and-policy-visualizations.shinyapps.io/n_app/) that enables users to choose the input/output N benchamrk of interest to view changes by countries over time. 

Folder Structure:

"~\\GlobalNitrogen_app1_git\\"
	GlobalNStudy_DataCleaning.R 
	ISO.csv
	Zhang_et_al_2021.xlsx
	
	"~\\GlobalNitrogen_app1_git\\n_app\\"
        	app.R
        	GlobalNStudyFinal_Amax.csv
	        GlobalNStudyFinal_Amed.csv
        	GlobalNStudyFinal_Amin.csv
		

Descriptions of R codes contained in this zip folder:

GlobalNStudy_DataCleaning.R - I use this to clean and prepare data based on Zhang_et_al_2021.xlsx which is the 
raw supplemental data from Zhang et al., 2021. This includes renaming country names and linking names with iso 
codes to effectively map using plot_geo(). It sounds like this is relevant to some of your needs. Give it a look. 
Outputs from this file are the long-format dataframes where input and output values are normalized by min area 
(GlobalNStudyFinal_Amin.csv), max area (GlobalNStudyFinal_Aax.csv), and median 
area(GlobalNStudyFinal_Amed.csv). These are the three csv files needed to run app.R

app.R – code that contains server and ui functions (shiny app code).

References:

Zhang, X., Zou, T., Lassaletta, L. et al. Quantification of global and national nitrogen budgets for crop production. 
Nat Food 2, 529–540 (2021). https://doi.org/10.1038/s43016-021-00318-5
