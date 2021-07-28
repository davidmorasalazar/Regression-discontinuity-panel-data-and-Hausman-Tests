/*Paquetes*/
ssc install outreg2
/*Datos*/
use "C:\Users\David Mora Salazar\Documents\ECONOMÍA UNIVERSIDAD DE COSTA RICA\Microeconometría\Examen 2\EC4300_tarea2_I2021\Cornwell_Trumbull_1994", clear

/*a*/
xtreg lcrmrte lprbarr lprbconv lprbpris lavgsen lpolpc ldensity lwcon lwtuc lwtrd lwfir  lwser  lwmfg   lwfed   lwsta lwloc lpctymle lpctmin west  central  urban d82 d83 d84 d85 d86 d87, be
outreg2 using regression_results1.xls, append ctitle(Between)

xtreg lcrmrte lprbarr lprbconv lprbpris lavgsen lpolpc ldensity lwcon lwtuc lwtrd lwfir  lwser  lwmfg   lwfed   lwsta lwloc lpctymle lpctmin west  central  urban d82 d83 d84 d85 d86 d87, fe
outreg2 using regression_results1.xls, append ctitle(Fixed effects)

/*Un cambio de un 1 porciento en la probabilidad de arresto se asocia con cambio de -0.355 porciento en los crímenes cometidos por persona, con un nivel de significancia del 1%.*/
/*b*/
xtreg lcrmrte lprbarr lprbconv lprbpris lavgsen lpolpc ldensity lwcon lwtuc lwtrd lwfir  lwser  lwmfg   lwfed   lwsta lwloc lpctymle i.year , fe 

*guardamos para hacer la prueba de Hausman:
estimates store fijos

xtreg lcrmrte lprbarr lprbconv lprbpris lavgsen lpolpc ldensity lwcon lwtuc lwtrd lwfir  lwser  lwmfg   lwfed   lwsta lwloc lpctymle lpctmin west  central  urban i.year, re

*Volvemos a guardar: 
estimates store aleatorios

*Realizando Prueba: 
hausman fijos aleatorios
/*c*/
xtivreg lcrmrte lprbconv lprbpris lavgsen ldensity lwcon lwtuc lwtrd lwfir lwser lwmfg lwfed lwsta lwloc lpctymle lpctmin west central urban d82 d83 d84 d85 d86 d87 (lprbarr lpolpc= ltaxpc lmix), fe
outreg2 using regression_results1.xls, append ctitle(FE2SLS)
*guardamos para hacer la prueba de Hausman:
estimates store fe2sls
xtivreg lcrmrte lprbconv lprbpris lavgsen ldensity lwcon lwtuc lwtrd lwfir lwser lwmfg lwfed lwsta lwloc lpctymle lpctmin west central urban d82 d83 d84 d85 d86 d87 (lprbarr lpolpc= ltaxpc lmix), be
outreg2 using regression_results1.xls, append ctitle(BE2SLS)

xtivreg lcrmrte lprbconv lprbpris lavgsen ldensity lwcon lwtuc lwtrd lwfir lwser lwmfg lwfed lwsta lwloc lpctymle lpctmin west central urban d82 d83 d84 d85 d86 d87 (lprbarr lpolpc= ltaxpc lmix), ec2sls
outreg2 using regression_results1.xls, append ctitle(EC2SLS)
estimates store ec2sls
/*d*/
hausman fe2sls ec2sls

