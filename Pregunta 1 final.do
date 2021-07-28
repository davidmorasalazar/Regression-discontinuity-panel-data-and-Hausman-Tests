/*Paquetes*/
ssc install rdrobust
net install rddensity, from(https://raw.githubusercontent.com/rdpackages/rddensity/master/stata) replace
net install lpdensity, from(https://raw.githubusercontent.com/nppackages/lpdensity/master/stata) replace
/*Globales*/
global range1 "iwm94 <.32 & iwm94>-.32"
global labrange "-.25(.25).25"
global bin "25"
/*Datos*/
use "C:\Users\David Mora Salazar\Documents\ECONOMÍA UNIVERSIDAD DE COSTA RICA\Microeconometría\Examen 2\EC4300_tarea2_I2021\Meyersson_2014.dta"
/*a*/
rdplot hischshr1520m iwm94, c(0) p(4) nbins(25 25) ///
       graph_options(title("Men") ///
                     ytitle(Cohort share) xlabel(-0.25(0.25)0.25) ylabel(0(0.1)0.3)))///
                     
graph save grp1.gph, replace					 
rdplot hischshr1520f iwm94, c(0) p(4) nbins(25 25) ///
       graph_options(title("Women") ///
                     xlabel(-0.25(0.25)0.25) ylabel(0(0.1)0.3)))	
graph save grp2.gph, replace					 
graph combine grp2.gph grp1.gph 
		graph_options(title(Completed High School))

/*a con bins óptimos*/		
rdplot hischshr1520m iwm94, c(0) p(4) binselect(es) ///
graph_options(title("Men") ///
                    ytitle(Cohort share) xlabel(-0.25(0.25)0.25) ylabel(0(0.1)0.3)))///
                     
graph save grp3.gph, replace					 
rdplot hischshr1520f iwm94, c(0) p(4) binselect(es) ///
       graph_options(title("Women") ///
                     xlabel(-0.25(0.25)0.25) ylabel(0(0.1)0.3)))	
graph save grp4.gph, replace					 
graph combine grp4.gph grp3.gph 
		graph_options(title(Completed High School))

/*a con bins de 8%*/		
rdplot hischshr1520m iwm94, c(0) p(4) nbins(8 8) ///
graph_options(title("Men") ///
                    ytitle(Cohort share) xlabel(-0.25(0.25)0.25) ylabel(0(0.1)0.3)))///
                     
graph save grp5.gph, replace					 
rdplot hischshr1520f iwm94, c(0) p(4) nbins(8 8) ///
       graph_options(title("Women") ///
                     xlabel(-0.25(0.25)0.25) ylabel(0(0.1)0.3)))	
graph save grp6.gph, replace					 
graph combine grp6.gph grp5.gph 
		graph_options(title(Completed High School))	
		
/*********************************************************************************/
		
*1.b.

/*Según el documento de Meyersson(2014) todas las columnas, a excepción de la 1 y la 3, incluyen las 
siguientes variables de control: log de población, porcentaje de voto islámico,
número de partidos que reciben votos, porcentaje de población menor a 19
,porcentaje de la población mayor a 65, proporción de género y dummies de tipo municipal.
Por esta razón se crea el global covs que incluye estas variables.*/

global covs="vshr_islam1994 partycount shhs lpop1994 ageshr19 ageshr60 sexr merkezi merkezp subbuyuk buyuk pd_*"

/*Se toman la variable de interés porcentaje de mujeres entre 15 y 20 años, y X como el margen de voto obtenido
por partido islámico en Turquía 1994.*/

gen Y=hischshr1520f
gen X=iwm94
 
/* Usando el comando rdrobust se realiza la replica de la tabla II. Donde para la columna
3 a la 6 se utiliza lineal, p(1) mientras que para la columna 7 y 8 se utiliza
una forma cuadrática y cúbica respectivamente, p(2) y p(3).
Además se toma el dato de bandwidth del documeto de Meyyerson que especifica un 
h=.24 Observando también que para la columna 5 y 6 se utiliza h/2 y 2h respectivamente.
Se hace el cambio de kernel, del kernel por deafault (triangular) al uniforme que le otorga 
mismo peso a las observaciones.
Por último como control se añade el global definido arriba, covs.*/

/*columna 3*/
rdrobust Y X , kernel(uniform) p(1) h(.24)  all
/*columna 4*/
rdrobust Y X  , kernel(uniform) p(1) h(.24) covs($covs) all
/*columna 5*/
rdrobust Y X, kernel(uniform)p(1) h(.12) covs($covs) all
/*columna 6*/
rdrobust Y X, kernel(uniform) p(1) h(.48) covs($covs) all
/*columna 7*/
rdrobust Y X, kernel(uniform) p(2)  h(.24) covs($covs) all
/*columna 8*/
rdrobust Y X, kernel(uniform) p(3) h(.24) covs($covs) all


