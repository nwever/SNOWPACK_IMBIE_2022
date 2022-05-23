# This script calculates the statistics requested by IMBIE.
# Invoke this script either without command line option (everything will be executed), or a number between 1 and 8 to execute one of the code blocks below
Gr_dir="/pl/active/icesheetsclimate/IDS_Greenland2/"
Ant_dir="/pl/active/icesheetsclimate/IDS_Antarctica/"


# Load the lists of basins
source basins.dat


Extract () {
	bash concatenate.sh ${dir}/zip/LATLON_MERRA2.zip *output*smet \
	`# Construct the list with points to pick` \
	$(awk -v sel=${i} -v fmt_flag=${fmt_flag} -v ant=${ant} '((fmt_flag && $2==sel) || (!fmt_flag && $1==sel)) {print ((ant)?($4):($3)) "_" ((ant)?($3):($2)), ((ant)?($7):($6))}' ${pts_file} | sort -k1,1 | join <(sort -k1,1 sim_status.txt) - | awk '($2=="OK") {print $1 "_" $3}' | tr '_' ',') | \
	`# Process the data` \
	awk 'BEGIN {header=0} {if(/SMET 1.1 ASCII/) {header=1; p++}; if (/fields/) {for(i=3; i<=NF; i++) {if($i=="SWE") {swe=i-2}; if($i=="MS_Snow") {mssnow=i-2}; if($i=="MS_Wind") {mswind=i-2}; if($i=="MS_Rain") {msrain=i-2}; if($i=="MS_Water") {mswater=i-2}; if($i=="MS_Sublimation") {mssublimation=i-2}; if($i=="MS_Evap") {msevaporation=i-2}; if($i=="MS_SN_Runoff") {msrunoff=i-2}; if($i=="HS_mod") {hs=i-2}}}; if(!header) {d=substr($1,1,10); FAC=($hs/100)-(($swe-$mswater)/917+$mswater/1000); SMB=($mssnow-$mswind)+$msrain+$mssublimation+$msevaporation-$msrunoff; a[d]+=FAC*$NF; b[d]+=SMB*$NF; c[d]+=$msrunoff*$NF; m[d]++; n[d]+=$NF}; if (/\[DATA\]/) {header=0}} END {for(i in a) {m[i]/=p; print i, p, m[i], n[i], a[i]/n[i], (b[i]/n[i])*m[i], (c[i]/n[i])*m[i]}}' | sort -k1,1 > ${outfile}
}


#
# Antarctica
#
dir=${Ant_dir}
fmt_flag=0	# We need a flag, since we need to select regions in the second column in the file SNOWPACK_pts_weights_AntBas_R.txt, while selecting regions in the first column in all other files
ant=1
if [[ -z "$1" ]] || (( "$1" == 1 )); then
	for i in ${Ant_R}
	do
		pts_file="SNOWPACK_pts_weights_Ant_R.txt"
		outfile="postprocess/Ant_R_${i}.txt"
		Extract
	done
fi
if [[ -z "$1" ]] || (( "$1" == 2 )); then
	for i in ${Ant_Z}
	do
		pts_file="SNOWPACK_pts_weights_Ant_Z.txt"
		outfile="postprocess/Ant_Z_${i}.txt"
		Extract
	done
fi
if [[ -z "$1" ]] || (( "$1" == 3 )); then
	for i in ${Ant_Bas_R}
	do
		fmt_flag=1
		pts_file="SNOWPACK_pts_weights_AntBas_R.txt"
		outfile="postprocess/AntBas_R_${i}.txt"
		Extract
		fmt_flag=0
	done
fi
if [[ -z "$1" ]] || (( "$1" == 4 )); then
	for i in ${Ant_Bas_Z}
	do
		pts_file="SNOWPACK_pts_weights_AntBas_Z.txt"
		outfile="postprocess/AntBas_Z_${i}.txt"
		Extract
	done
fi


#
# Greenland
#
dir=${Gr_dir}
ant=0
if [[ -z "$1" ]] || (( "$1" == 5 )); then
	for i in ${Gr_R}
	do
		pts_file="SNOWPACK_pts_weights_Gr_R.txt"
		outfile="postprocess/Gr_R_${i}.txt"
		Extract
	done
fi
if [[ -z "$1" ]] || (( "$1" == 6 )); then
	for i in ${Gr_Z}
	do
		pts_file="SNOWPACK_pts_weights_Gr_Z.txt"
		outfile="postprocess/Gr_Z_${i}.txt"
		Extract
	done
fi
if [[ -z "$1" ]] || (( "$1" == 7 )); then
	for i in ${Gr_Bas_R}
	do
		pts_file="SNOWPACK_pts_weights_GrBas_R.txt"
		outfile="postprocess/GrBas_R_${i}.txt"
		Extract
	done
fi
if [[ -z "$1" ]] || (( "$1" == 8 )); then
	for i in ${Gr_Bas_Z}
	do
		pts_file="SNOWPACK_pts_weights_GrBas_Z.txt"
		outfile="postprocess/GrBas_Z_${i}.txt"
		Extract
	done
fi
