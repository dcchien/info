#!/bin/ksh
#
# created: David Chien       	2009-05-14
#				2010-08-12
#				2011-06-20, NAS/NFS mount
#				2012-06-08, local SAN storage space
#				2016-11-07, fix bug/AIX 
#
# summarize the existing FS storage allocation/usage
# define server name & timestamp
HOST=$(/bin/uname -n)
OS=$(/bin/uname -s)
AWK="/bin/nawk"
DF="/bin/df -k"                 # default for Solaris
EGREP="/bin/egrep -v"
DATE=$(date '+%a %b %d, %H:%M %e %Z %Y-%m-%d')

# exclude mounted FSs, NFS, swap
excl="File|proc|fd|objfs|dfs|ctfs|mnttab|swap|:/|cdrom|libc|devices|vx/dmp|vx/rdmp|var/run|tmpfs|ccis"
#
# if it's an HP, then using /bin/bdf
# if it's an AIX, then using /bin/df -P
# if it's a Linux using /bin/df -P
#
if [ "Linux" = "${OS}" ]; then
   DF="/bin/df -P"
   OSREL=$(cat /etc/*release|egrep "Linux"|sort -u)
   AWK="/bin/gawk"
   ST=/sbin/pvscan
elif [ "SunOS" = "${OS}" ]; then
   OSREL=$(cat /etc/*release|egrep "Solaris" |sed 's/^  .*So/So/')
elif [ "AIX" = "${OS}" ]; then
   DF="/bin/df -P"
   OSREL="IBM AIX `/bin/oslevel -r`" 
   AWK="/usr/bin/nawk"
elif [ "HP-UX" = "${OS}" ]; then
   DF="/bin/bdf"
   OSREL="HP UX `/usr/sbin/uname -r`"
   AWK="/bin/awk"
else echo "Don't know what OS is running"
   exit 1
fi

if [ "AIX" != "${OS}" ]; then
printf "\n*** Server Stoage Allocation(Local Disk/SAN) and Usage, ${DATE} ***"
printf "\n<<< ${HOST} - ${OSREL} >>>\n\n"
${DF} |$EGREP $excl |
${AWK} '
BEGIN { total_st = 0; total_ds = 0;
printf ("Filesystem                                    Mount Point                   StorageAllcMB     UsedMB     Used %\n")
}
{
printf ("%-45s %-30s %12s %10s %10s\n",$1,$6,int($2/1024),int($3/1024),$5)
total_st += int($2/1024); total_ds += int($3/1024)
}
END {
printf ("         \t\t\t\t\t\t\tTotal              %sMB   %sMB\n",total_st,total_ds)
printf ("\t\t\t\t\t\t\t\t\t\t      %sGB      %sGB Avg%5.1f%\n",int(total_st/1024),int(total_ds/1024),(total_ds/total_st)*100)
}
'
else
  printf "\n*** Server Stoage Allocation(Local Disk/SAN) and Usage, ${DATE} ***"
  printf "\n<<< ${HOST} - ${OSREL} >>>\n\n"
  ${DF} |$EGREP $excl |
  ${AWK} '
  BEGIN { total_st = 0; total_ds = 0;
  printf ("Filesystem                                    Mount Point                   StorageAllcMB     UsedMB     Used %\n")
  }
  {
  printf ("%-45s %-30s %12s %10s %10s\n",$1,$6,int($2/2048),int($3/2048),$5)
  total_st += int($2/1024); total_ds += int($3/2048)
  }
  END {
  printf ("         \t\t\t\t\t\t\tTotal              %sMB   %sMB\n",total_st,total_ds)
  printf ("\t\t\t\t\t\t\t\t\t\t      %sGB      %sGB Avg%5.1f%\n",int(total_st/2048),int(total_ds/2048),(total_ds/total_st)*100)
  }
  '
fi

# storage spaces 
if [[ ("Linux" = "${OS}") && ("root" = "`whoami`") ]]; then
   /sbin/pvscan
fi
 
# NAS/NFS mount...
if [ ! -z `${DF} | egrep ":/"` ];then
   echo "***and, NAS/NFS mount....."
   ${DF} | egrep ":/"
fi

