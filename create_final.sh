source basins.dat	# Load the lists of basins
export TZ=UTC

part_name="Wever"
exp_group="Surface_Mass_Balance"

PrintHeader () {
	echo "#Participant Surname,Experiment Group (altimetry/gravimetry/mass budget),Drainage Region Set (Rignot/Zwally),Drainage Region ID,Drainage Region Area (km2),Drainage Region Area Observed (km2),Date (decimal years),Relative Mass Change (Gt),Relative Mass Change Uncertainty (Gt)"
}

# Note: 1 gigaton = 1E12 kg
#       1 km2 =	1E6 m2
# Thus, going from SMB in kg/m2 to Gt/basin, with area in km2 is: SMB * area * 1E6 / 1E12 = SMB * area * 1E-6
PrepareOutput () {
	mawk -v part_name=${part_name} -v exp_group=${exp_group} -v set=${set} -v id=${i} '{doy=strftime("%j", mktime(sprintf("%04d %02d %02d %02d %02d %02d 0", substr($1,1,4), substr($1,6,2), substr($1,9,2), 0, 0, 0))); maxdoy=strftime("%j", mktime(sprintf("%04d %02d %02d %02d %02d %02d 0", substr($1,1,4), 12, 31, 0, 0, 0))); dd=(doy-1)/maxdoy; area=$4/$3; area_obs="NaN"; smb=area*$6*1E-6; smb_err="NaN"; printf("%s,%s,%s,%s,%s,%s,%.4f,%s,%s\n", part_name, exp_group, set, id, area, area_obs, int(substr($1,1,4))+dd, smb, smb_err)}' ${outfile}
}


PrintHeader

#
# Antarctica
#
for i in ${Ant_R}
do
	set="Rignot"
	outfile="postprocess/Ant_R_${i}.txt"
	PrepareOutput
done
for i in ${Ant_Z}
do
	set="Zwally"
	outfile="postprocess/Ant_Z_${i}.txt"
	PrepareOutput
done
for i in ${Ant_Bas_R}
do
	set="Rignot"
	outfile="postprocess/AntBas_R_${i}.txt"
	PrepareOutput
done
for i in ${Ant_Bas_Z}
do
	set="Zwally"
	outfile="postprocess/AntBas_Z_${i}.txt"
	PrepareOutput
done


#
# Greenland
#
for i in ${Gr_R}
do
	set="Rignot"
	outfile="postprocess/Gr_R_${i}.txt"
	PrepareOutput
done
for i in ${Gr_Z}
do

	set="Zwally"
	outfile="postprocess/Gr_Z_${i}.txt"
	PrepareOutput
done
for i in ${Gr_Bas_R}
do
	set="Rignot"
	outfile="postprocess/GrBas_R_${i}.txt"
	PrepareOutput
done
for i in ${Gr_Bas_Z}
do
	set="Zwally"
	outfile="postprocess/GrBas_Z_${i}.txt"
	PrepareOutput
done


