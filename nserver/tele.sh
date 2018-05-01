#!/bin/bash
#-------------------------------
#* File name : tele.sh
#* Author (s) : Hossein Ebrahimi @he71.com,
# 
#* license AGPL-3.0 
#
#* This code is free software: you can redistribute it and/or modify
#* it under the terms of the GNU Affero General Public License, version 3,
#* as published by the Free Software Foundation.
#*
#* This program is distributed in the hope that it will be useful,
#* but WITHOUT ANY WARRANTY; without even the implied warranty of
#* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#* GNU Affero General Public License for more details.
#*
#* You should have received a copy of the GNU Affero General Public License, version 3,
#* along with this program.  If not, see <http://www.gnu.org/licenses/>
#
#
#* Last Update : 
#* History :
#------------------------------

to=nServer
##


function show_usage {

	echo "Usage $0 [message]"
	exit
}

if [ $# -lt 1 ]
then
  show_usage
fi

./tg/bin/telegram-cli -W -e "post $to $1"