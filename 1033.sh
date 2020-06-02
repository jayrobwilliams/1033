#!/bin/bash

# find file name
FILE=$(wget -O - https://www.dla.mil/DispositionServices/Offers/Reutilization/LawEnforcement/PublicInformation/ | grep -o "DISP_AllStatesAndTerritories.*\.xlsx")

# download to temporary file
wget -O temp.xlsx "https://www.dla.mil/Portals/104/Documents/DispositionServices/LESO/$FILE"

# check if first time running
SHEETS=$(ls -1 *.xlsx 2>/dev/null | wc -l)
if [ $SHEETS = 1 ]; then
    DATE=$(date +"%m-%d-%y")
    mv temp.xlsx "${DATE}-${FILE}"
else
    # get sha256 of most recent local file and compare with downloaded file
    NEWEST=$(ls -1t *.xlsx | head -n1)
    NEW_SHA=$(sha256sum temp.xlsx | cut -d " " -f1)
    OLD_SHA=$(sha256sum $NEWEST | cut -d " " -f1)

    # rename and save file if newer than most recent local one
    if [ $OLD_SHA != $NEW_SHA ]; then
	DATE=$(date +"%m-%d-%y")
	mv temp.xlsx "${DATE}-${FILE}"
    else
	rm temp.xlsx
    fi
fi
