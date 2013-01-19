#!/bin/sh

#Copyright (C) 2012 momiji-mac.com  All Rights Reserved.
#Our homepage is http://momiji-mac.com/wp/

###### configure ###################

    #### Text ######
    POSITION_X=20 
    POSITION_Y=20
    CHAR_SIZE=24

    #### TEXT COLOR ########
    readonly TC_B="black"
    readonly TC_W="white"
    TC="${TC_W}"
    
    #####Font path ##########
    readonly font_hiragino="/System/Library/Fonts/ヒラギノ角ゴ ProN W3.otf"
    readonly font_osak="/Library/Fonts/Osaka.ttf"


######  Default color map ########

export NONE=''
export BLACK='\033[0;30m'
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export BROWN='\033[0;33m'
export BLUE='\033[0;34m'
export PURPLE='\033[0;35m'
export CYAN='\033[0;36m'
export LIGHT_GREY='\033[0;37m'
export DARK_GREY='\033[1;30m'
export LIGHT_RED='\033[1;31m'
export LIGHT_GREEN='\033[1;32m'
export YELLOW='\033[1;33m'
export LIGHT_BLUE='\033[1;34m'
export LIGHT_PURPLE='\033[1;35m'
export LIGHT_CYAN='\033[1;36m'
export WHITE='\033[1;37m'
export DEFAULT='\033[0;39m'
export GREEN_U='\033[4;32m'
export LIGHT_RED_U='\033[4;31m'
export YELLOW_U='\033[4;33m'
export BLUE_U='\033[4;34m'

######### functions ###############

function display_help(){
    cat <<EOF                                      
Usage: tateGaki.sh [fileName] ["moji wa ireru"] 
                                                                                                      
OPTION

EOF
}

function errorMessage()
{
    
    display_help
}


function check_extention(){
   
    EXTNAME=${fileName##*.}
    case "${EXTNAME}" in
        [Pp][nN][Gg]) echo "match: PNG"
            ;;
        [jJ][pP][gG]) echo "match: JPG"
            ;;
        *) echo "un-match"
            exit
            ;;
    esac

   addText
}

function addText(){

    local length=${#target_text} # 文字数カウント
    
    local COUNTER=1
    local TARGET_FILE="${fileName}"
    local FILE_TREATED="temp_terat2.jpg"

    while [ "${COUNTER}" -le "${length}" ]
    do
        char=`echo "${target_text}" | cut -c "${COUNTER}"`

        convert -font "${font_hiragino}" -fill "${TC}" -pointsize "${CHAR_SIZE}" -draw "text "${POSITION_X}","${POSITION_Y}" '${char}'" "${TARGET_FILE}" "${FILE_TREATED}"

        TARGET_FILE="${FILE_TREATED}"
        let POSITION_Y=POSITION_Y+"${CHAR_SIZE}"+1
        echo "${POSITION_Y}"
        let COUNTER++
    done

    renameFile

 }

function renameFile(){
    target_pre=`echo "${fileName}" | cut -d "." -f 1 `
    target_pos=`echo "${fileName}" | cut -d "." -f 2 `
    mv temp_terat2.jpg "${target_pre}""-treated.""${target_pos}"

}


######### #Script mains #################
echo "---------------------------------"
echo  "${LIGHT_CYAN}""  TATE-GAKI""${DEFAULT}"
echo "---------------------------------"

# 引数確認
    # 変数 $# の値が 1~2 でなければエラー終了。
    if [ $# -ne 2 ]; then
        errorMessage
        exit 1
    fi

    fileName=$1 # file name    
    target_text=$2

    #引数の種類確認
    check_extention
    
    #file 存在確認
    if [ -e ${fileName} ]; then
        echo ""
    else 
        echo "${fileName}"" is not exist."
        exit
    fi

    