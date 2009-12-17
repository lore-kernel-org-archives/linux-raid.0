From: Brett Russ <bruss@netezza.com>
Subject: bug/race in md causing device to wedge in busy state
Date: Wed, 16 Dec 2009 20:04:46 -0500
Message-ID: <4B2983AE.8020002@netezza.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm seeing cases where an attempted remove of a manually faulted disk 
from an existing RAID unit can fail with mdadm reporting "Device or 
resource busy".  I've reduced the problem down to the smallest set that 
reliably reproduces the issue:

Starting with 2 drives (a,b), each with at least 3 partitions:
1) create 3 raid1 md's on the drives using the 3 partitions
2) fault & remove drive b from each of the 3 md's
3) zero the superblock on b so it forgets where it came from (or use a 
third drive c...) and add drive b back to each of the 3 md's
4) fault & remove drive b from each of the 3 md's

The problem was originally seen sporadically during the remove part of 
step 2, but is *very* reproducible in the remove part of step 4.  I 
attribute this to the fact that there's guaranteed I/O happening during 
this step.

Now here's the catch.  If I change step 4 to:
4a) fault drive b from each of the 3 md's
4b) remove drive b from each of the 3 md's
then the removes haven't yet been seen to fail with BUSY yet (i.e. no 
issues).

But my scripts currently do this instead for each md:
4a) fault drive b from md
4b) sleep 0-10 seconds
4c) remove drive b md
which will fail on the remove from one of the md's, almost guaranteed. 
It seems odd to me that no amount of sleeping in between these steps can 
allow me to reliably remove a faulted member of an array.

Some other info:
-I haven't yet seen the problem if I use < 3 partitions.
-I've tried different create options to no avail
-I'm running a Fedora 2.6.31.6 kernel
-I've hooked up to this machine with kgdb and may poke around more if needed

I will use the "fault all" then "remove all" as my workaround if it 
proves reliable, but I thought it'd be a good idea to report this bug.

To that end, below find 3 things:

1) the simplest possible run of a script that reliably triggers bug
2) the system logs from this run
3) the script used to simulate this bug


1) console output of running simplest use case of script (note md110 is 
not part of this exercise):

> mxmx# ./sim_md_busy.sh -dg1 /dev/sdg -dg2 /dev/sdp -df /dev/sdp -dr /dev/sdp -create -m bug3part
> mdadm --create /dev/md0  --force --run --level=1 --raid-devices=2 /dev/sdg1  /dev/sdp1 --assume-clean
> mdadm: /dev/sdg1 appears to be part of a raid array:
>     level=raid1 devices=2 ctime=Wed Dec 16 19:43:50 2009
> mdadm: /dev/sdp1 appears to be part of a raid array:
>     level=raid1 devices=2 ctime=Wed Dec 16 19:43:50 2009
> mdadm: array /dev/md0 started.
> Succeeded after 0 retries
> mdadm --create /dev/md1  --force --run --level=1 --raid-devices=2 /dev/sdg3  /dev/sdp3 --assume-clean
> mdadm: /dev/sdg3 appears to be part of a raid array:
>     level=raid1 devices=2 ctime=Wed Dec 16 19:43:50 2009
> mdadm: /dev/sdp3 appears to be part of a raid array:
>     level=raid1 devices=2 ctime=Wed Dec 16 19:43:50 2009
> mdadm: array /dev/md1 started.
> Succeeded after 0 retries
> mdadm --create /dev/md2  --force --run --level=1 --raid-devices=2 /dev/sdg4  /dev/sdp4 --assume-clean
> mdadm: /dev/sdg4 appears to be part of a raid array:
>     level=raid1 devices=2 ctime=Wed Dec 16 19:43:50 2009
> mdadm: /dev/sdp4 appears to be part of a raid array:
>     level=raid1 devices=2 ctime=Wed Dec 16 19:43:50 2009
> mdadm: array /dev/md2 started.
> Succeeded after 0 retries
> mdadm --verbose  --manage /dev/md0 --fail   /dev/sdp1
> mdadm: set /dev/sdp1 faulty in /dev/md0
> Succeeded after 0 retries
> mdadm --verbose  --manage /dev/md0 --remove   /dev/sdp1
> mdadm: hot removed /dev/sdp1
> Succeeded after 0 retries
> mdadm --verbose  --manage /dev/md1 --fail   /dev/sdp3
> mdadm: set /dev/sdp3 faulty in /dev/md1
> Succeeded after 0 retries
> mdadm --verbose  --manage /dev/md1 --remove   /dev/sdp3
> mdadm: hot removed /dev/sdp3
> Succeeded after 0 retries
> mdadm --verbose  --manage /dev/md2 --fail   /dev/sdp4
> mdadm: set /dev/sdp4 faulty in /dev/md2
> Succeeded after 0 retries
> mdadm --verbose  --manage /dev/md2 --remove   /dev/sdp4
> mdadm: hot removed /dev/sdp4
> Succeeded after 0 retries
> mdadm --verbose  --manage /dev/md0 --add   /dev/sdp1
> mdadm: added /dev/sdp1
> Succeeded after 0 retries
> mdadm --verbose  --manage /dev/md1 --add   /dev/sdp3
> mdadm: added /dev/sdp3
> Succeeded after 0 retries
> mdadm --verbose  --manage /dev/md2 --add   /dev/sdp4
> mdadm: added /dev/sdp4
> Succeeded after 0 retries
> Personalities : [raid1] [raid10] [raid0] [linear]
> md2 : active raid1 sdp4[2] sdg4[0]
>       4200896 blocks [2/1] [U_]
>         resync=DELAYED
>
> md1 : active raid1 sdp3[2] sdg3[0]
>       4200896 blocks [2/1] [U_]
>         resync=DELAYED
>
> md0 : active raid1 sdp1[2] sdg1[0]
>       4200896 blocks [2/1] [U_]
>       [>....................]  recovery =  1.5% (65472/4200896) finish=1.0min speed=65472K/sec
>
> md110 : active raid1 sda6[0] sdn6[1]
>       1060248 blocks super 1.0 [2/2] [UU]
>       bitmap: 1/1 pages [4KB], 1024KB chunk
>
> unused devices: <none>
> mdadm --verbose  --manage /dev/md0 --fail   /dev/sdp1
> mdadm: set /dev/sdp1 faulty in /dev/md0
> Succeeded after 0 retries
> mdadm --verbose  --manage /dev/md0 --remove   /dev/sdp1
> mdadm: hot removed /dev/sdp1
> Succeeded after 0 retries
> mdadm --verbose  --manage /dev/md1 --fail   /dev/sdp3
> mdadm: set /dev/sdp3 faulty in /dev/md1
> Succeeded after 0 retries
> mdadm --verbose  --manage /dev/md1 --remove   /dev/sdp3
> mdadm: hot remove failed for /dev/sdp3: Device or resource busy
> mdadm: hot remove failed for /dev/sdp3: Device or resource busy
> mdadm: hot remove failed for /dev/sdp3: Device or resource busy
> ERROR: Command failed after 3 retries (mdadm --verbose  --manage /dev/md1 --remove   /dev/sdp3)
> mdadm --verbose  --manage /dev/md2 --fail   /dev/sdp4
> mdadm: set /dev/sdp4 faulty in /dev/md2
> Succeeded after 0 retries
> mdadm --verbose  --manage /dev/md2 --remove   /dev/sdp4
> mdadm: hot removed /dev/sdp4



2) the logs from that run:

> Dec 16 19:44:34 mxmx user.info kernel: md: bind<sdg1>
> Dec 16 19:44:34 mxmx user.info kernel: md: bind<sdp1>
> Dec 16 19:44:34 mxmx user.info kernel: raid1: raid set md0 active with 2 out of 2 mirrors
> Dec 16 19:44:34 mxmx user.info kernel: md0: detected capacity change from 0 to 4301717504
> Dec 16 19:44:34 mxmx user.info kernel: md: bind<sdg3>
> Dec 16 19:44:34 mxmx user.info kernel: md: bind<sdp3>
> Dec 16 19:44:34 mxmx user.info kernel: raid1: raid set md1 active with 2 out of 2 mirrors
> Dec 16 19:44:34 mxmx user.info kernel: md1: detected capacity change from 0 to 4301717504
> Dec 16 19:44:34 mxmx user.info kernel: md: bind<sdg4>
> Dec 16 19:44:34 mxmx user.info kernel: md: bind<sdp4>
> Dec 16 19:44:34 mxmx user.info kernel: raid1: raid set md2 active with 2 out of 2 mirrors
> Dec 16 19:44:34 mxmx user.info kernel: md2: detected capacity change from 0 to 4301717504
> Dec 16 19:44:35 mxmx user.info kernel:  md0:
> Dec 16 19:44:35 mxmx user.info kernel:  unknown partition table
> Dec 16 19:44:36 mxmx user.alert kernel: raid1: Disk failure on sdp1, disabling device.
> Dec 16 19:44:36 mxmx user.alert kernel: raid1: Operation continuing on 1 devices.
> Dec 16 19:44:36 mxmx user.warn kernel: RAID1 conf printout:
> Dec 16 19:44:36 mxmx user.warn kernel:  --- wd:1 rd:2
> Dec 16 19:44:36 mxmx user.warn kernel:  disk 0, wo:0, o:1, dev:sdg1
> Dec 16 19:44:36 mxmx user.warn kernel:  disk 1, wo:1, o:0, dev:sdp1
> Dec 16 19:44:36 mxmx user.warn kernel: RAID1 conf printout:
> Dec 16 19:44:36 mxmx user.warn kernel:  --- wd:1 rd:2
> Dec 16 19:44:36 mxmx user.warn kernel:  disk 0, wo:0, o:1, dev:sdg1
> Dec 16 19:44:38 mxmx user.info kernel: md: unbind<sdp1>
> Dec 16 19:44:38 mxmx user.info kernel: md: export_rdev(sdp1)
> Dec 16 19:44:38 mxmx user.info kernel:  md1:
> Dec 16 19:44:38 mxmx user.info kernel:  unknown partition table
> Dec 16 19:44:38 mxmx user.alert kernel: raid1: Disk failure on sdp3, disabling device.
> Dec 16 19:44:38 mxmx user.alert kernel: raid1: Operation continuing on 1 devices.
> Dec 16 19:44:38 mxmx user.warn kernel: RAID1 conf printout:
> Dec 16 19:44:38 mxmx user.warn kernel:  --- wd:1 rd:2
> Dec 16 19:44:38 mxmx user.warn kernel:  disk 0, wo:0, o:1, dev:sdg3
> Dec 16 19:44:38 mxmx user.warn kernel:  disk 1, wo:1, o:0, dev:sdp3
> Dec 16 19:44:38 mxmx user.warn kernel: RAID1 conf printout:
> Dec 16 19:44:38 mxmx user.warn kernel:  --- wd:1 rd:2
> Dec 16 19:44:38 mxmx user.warn kernel:  disk 0, wo:0, o:1, dev:sdg3
> Dec 16 19:44:40 mxmx user.info kernel: md: unbind<sdp3>
> Dec 16 19:44:40 mxmx user.info kernel: md: export_rdev(sdp3)
> Dec 16 19:44:40 mxmx user.info kernel:  md2:
> Dec 16 19:44:40 mxmx user.info kernel:  unknown partition table
> Dec 16 19:44:40 mxmx user.alert kernel: raid1: Disk failure on sdp4, disabling device.
> Dec 16 19:44:40 mxmx user.alert kernel: raid1: Operation continuing on 1 devices.
> Dec 16 19:44:40 mxmx user.warn kernel: RAID1 conf printout:
> Dec 16 19:44:40 mxmx user.warn kernel:  --- wd:1 rd:2
> Dec 16 19:44:40 mxmx user.warn kernel:  disk 0, wo:0, o:1, dev:sdg4
> Dec 16 19:44:40 mxmx user.warn kernel:  disk 1, wo:1, o:0, dev:sdp4
> Dec 16 19:44:40 mxmx user.warn kernel: RAID1 conf printout:
> Dec 16 19:44:40 mxmx user.warn kernel:  --- wd:1 rd:2
> Dec 16 19:44:40 mxmx user.warn kernel:  disk 0, wo:0, o:1, dev:sdg4
> Dec 16 19:44:42 mxmx user.info kernel: md: unbind<sdp4>
> Dec 16 19:44:42 mxmx user.info kernel: md: export_rdev(sdp4)
> Dec 16 19:44:42 mxmx user.info kernel: md: bind<sdp1>
> Dec 16 19:44:42 mxmx user.warn kernel: RAID1 conf printout:
> Dec 16 19:44:42 mxmx user.warn kernel:  --- wd:1 rd:2
> Dec 16 19:44:42 mxmx user.warn kernel:  disk 0, wo:0, o:1, dev:sdg1
> Dec 16 19:44:42 mxmx user.warn kernel:  disk 1, wo:1, o:1, dev:sdp1
> Dec 16 19:44:42 mxmx user.info kernel: md: recovery of RAID array md0
> Dec 16 19:44:42 mxmx user.info kernel: md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> Dec 16 19:44:42 mxmx user.info kernel: md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
> Dec 16 19:44:42 mxmx user.info kernel: md: using 128k window, over a total of 4200896 blocks.
> Dec 16 19:44:42 mxmx user.info kernel: md: bind<sdp3>
> Dec 16 19:44:42 mxmx user.warn kernel: RAID1 conf printout:
> Dec 16 19:44:42 mxmx user.warn kernel:  --- wd:1 rd:2
> Dec 16 19:44:42 mxmx user.warn kernel:  disk 0, wo:0, o:1, dev:sdg3
> Dec 16 19:44:42 mxmx user.warn kernel:  disk 1, wo:1, o:1, dev:sdp3
> Dec 16 19:44:42 mxmx user.info kernel: md: delaying recovery of md1 until md0 has finished (they share one or more physical units)
> Dec 16 19:44:42 mxmx user.info kernel: md: bind<sdp4>
> Dec 16 19:44:42 mxmx user.warn kernel: RAID1 conf printout:
> Dec 16 19:44:42 mxmx user.warn kernel:  --- wd:1 rd:2
> Dec 16 19:44:42 mxmx user.warn kernel:  disk 0, wo:0, o:1, dev:sdg4
> Dec 16 19:44:42 mxmx user.warn kernel:  disk 1, wo:1, o:1, dev:sdp4
> Dec 16 19:44:42 mxmx user.info kernel: md: delaying recovery of md2 until md0 has finished (they share one or more physical units)
> Dec 16 19:44:42 mxmx user.info kernel: md: delaying recovery of md1 until md2 has finished (they share one or more physical units)
> Dec 16 19:44:43 mxmx user.alert kernel: raid1: Disk failure on sdp1, disabling device.
> Dec 16 19:44:43 mxmx user.alert kernel: raid1: Operation continuing on 1 devices.
> Dec 16 19:44:43 mxmx user.info kernel: md: md0: recovery done.
> Dec 16 19:44:44 mxmx user.info kernel: md: delaying recovery of md1 until md2 has finished (they share one or more physical units)
> Dec 16 19:44:44 mxmx user.info kernel: md: recovery of RAID array md2
> Dec 16 19:44:44 mxmx user.info kernel: md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> Dec 16 19:44:44 mxmx user.info kernel: md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
> Dec 16 19:44:44 mxmx user.info kernel: md: using 128k window, over a total of 4200896 blocks.
> Dec 16 19:44:44 mxmx user.warn kernel: RAID1 conf printout:
> Dec 16 19:44:44 mxmx user.warn kernel:  --- wd:1 rd:2
> Dec 16 19:44:44 mxmx user.warn kernel:  disk 0, wo:0, o:1, dev:sdg1
> Dec 16 19:44:44 mxmx user.warn kernel:  disk 1, wo:1, o:0, dev:sdp1
> Dec 16 19:44:44 mxmx user.warn kernel: RAID1 conf printout:
> Dec 16 19:44:44 mxmx user.warn kernel:  --- wd:1 rd:2
> Dec 16 19:44:44 mxmx user.warn kernel:  disk 0, wo:0, o:1, dev:sdg1
> Dec 16 19:44:45 mxmx user.info kernel: md: unbind<sdp1>
> Dec 16 19:44:45 mxmx user.info kernel: md: export_rdev(sdp1)
> Dec 16 19:44:45 mxmx user.alert kernel: raid1: Disk failure on sdp3, disabling device.
> Dec 16 19:44:45 mxmx user.alert kernel: raid1: Operation continuing on 1 devices.
> Dec 16 19:44:48 mxmx user.warn kernel: md: cannot remove active disk sdp3 from md1 ...
> Dec 16 19:44:49 mxmx user.warn kernel: md: cannot remove active disk sdp3 from md1 ...
> Dec 16 19:44:50 mxmx user.warn kernel: md: cannot remove active disk sdp3 from md1 ...
> Dec 16 19:44:51 mxmx user.alert kernel: raid1: Disk failure on sdp4, disabling device.
> Dec 16 19:44:51 mxmx user.alert kernel: raid1: Operation continuing on 1 devices.
> Dec 16 19:44:51 mxmx user.info kernel: md: md2: recovery done.
> Dec 16 19:44:51 mxmx user.info kernel: md: recovery of RAID array md1
> Dec 16 19:44:51 mxmx user.info kernel: md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> Dec 16 19:44:51 mxmx user.info kernel: md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
> Dec 16 19:44:51 mxmx user.warn kernel: RAID1 conf printout:
> Dec 16 19:44:51 mxmx user.info kernel: md: using 128k window, over a total of 4200896 blocks.
> Dec 16 19:44:51 mxmx user.info kernel: md: resuming recovery of md1 from checkpoint.
> Dec 16 19:44:51 mxmx user.info kernel: md: md1: recovery done.
> Dec 16 19:44:51 mxmx user.warn kernel:  --- wd:1 rd:2
> Dec 16 19:44:51 mxmx user.warn kernel:  disk 0, wo:0, o:1, dev:sdg4
> Dec 16 19:44:51 mxmx user.warn kernel: RAID1 conf printout:
> Dec 16 19:44:51 mxmx user.warn kernel:  --- wd:1 rd:2
> Dec 16 19:44:51 mxmx user.warn kernel:  disk 0, wo:0, o:1, dev:sdg3
> Dec 16 19:44:51 mxmx user.warn kernel:  disk 1, wo:1, o:0, dev:sdp3
> Dec 16 19:44:51 mxmx user.warn kernel:  disk 1, wo:1, o:0, dev:sdp4
> Dec 16 19:44:51 mxmx user.warn kernel: RAID1 conf printout:
> Dec 16 19:44:51 mxmx user.warn kernel:  --- wd:1 rd:2
> Dec 16 19:44:51 mxmx user.warn kernel: RAID1 conf printout:
> Dec 16 19:44:51 mxmx user.warn kernel:  --- wd:1 rd:2
> Dec 16 19:44:51 mxmx user.warn kernel:  disk 0, wo:0, o:1, dev:sdg3
> Dec 16 19:44:51 mxmx user.warn kernel:  disk 0, wo:0, o:1, dev:sdg4
> Dec 16 19:44:53 mxmx user.info kernel: md: unbind<sdp4>
> Dec 16 19:44:53 mxmx user.info kernel: md: export_rdev(sdp4)



3) the script (note if/when running to adjust partition (and if needed, 
md) numbers to match your system.  Actual drive names are passed in as 
arguments.  See usage and example usage above.  "modes" which fail are 
"bug" and "bug3part".  The mode which reliably works with any # of 
partitions is "fault_all_first".

> #!/bin/sh
>
> do_md()
> {
>     md=$1
>     shift
>     op=$1
>     shift
>     opdisk=$1
>     shift
>     opdisk2=$1
>
>     # customize the 'pp' partitions used for each of the 'md' devices here:
>     case $md in
>         0) pp=1 ;;
>         1) pp=3 ;;
>         2) pp=4 ;;
>         3) pp=5 ;;
>         *)
>             echo "unsupported md dev: $md"
>             return
>             ;;
>     esac
>
>     retry="y"
>     case $op in
>         "stop")
> 	    retry="n"
>             cmd="mdadm --verbose  --stop /dev/md$md"
>             ;;
>         "create")
> 	    retry="n"
>             cmd="mdadm --create /dev/md$md  --force --run --level=1 \
> --raid-devices=2 ${opdisk}$pp  ${opdisk2}$pp --assume-clean "
>             ;;
>         *)
>             if [ "$op" = "add" ]; then
>                 mdadm --zero-superblock $opdisk$pp
>             fi
>             cmd="mdadm --verbose  --manage /dev/md$md --$op   ${opdisk}$pp"
>             ;;
>     esac
>     echo "$cmd"
>     retries=3
>     i=$retries
>     while [ $i -gt 0 ]; do
>         $cmd
> 	cmdstatus=$?
> 	if [ $cmdstatus -eq 0 ]; then
> 	    break
> 	fi
> 	[ "$retry" != "y" ] && break
>         i=$((i-1))
> 	sleep 1
>     done
>     if [ $cmdstatus -eq 0 ]; then
>         echo "Succeeded after $((retries-i)) retries"
>     else
>         echo "ERROR: Command failed after $retries retries ($cmd)"
>     fi
> }
>
> do_md_all()
> {
>     op=$1
>     shift
>     opdisk=$1
>     shift
>     opdisk2=$1
>
>     for md in $mdlist ; do
> 	do_md $md $op $opdisk $opdisk2
>     done
> }
>
> do_mode_bug()
> {
>     for md in $mdlist ; do
> 	do_md $md fail $fdisk
> 	sleep 2
> 	do_md $md remove $fdisk
>     done
>
>     for md in $mdlist ; do
> 	do_md $md add $rdisk
>     done
>
>     sleep 1
>     cat /proc/mdstat
>
>     for md in $mdlist ; do
> 	do_md $md fail $rdisk
> 	sleep 2
> 	do_md $md remove $rdisk
>     done
> }
>
> do_mode_fault_all_first()
> {
>     do_md_all "fail" $fdisk
>     do_md_all "remove" $fdisk
>
>     # regen to spare:
>
>     do_md_all "add" $rdisk
>
>     # failover spare:
>
>     sleep 1
>     cat /proc/mdstat
>
>     do_md_all "fail" $rdisk
> #    sleep 1
>     cat /proc/mdstat
> #    sleep 1
>     do_md_all "remove" $rdisk
> }
>
> usage()
> {
>     cat <<EOF
> Usage: $0 [OPTIONS]
> -m <arg>  : run in mode <arg>; supported are:
>             "bug", "fault_all_first", "bug1part",
>             "bug2part", "bug3part"
> -stop     : first stop any running arrays previously setup by
>             this program on the given disks
> -create   : create needed running md's on the given disks (otherwise
>             we assume they're already running)
> -dg1 <arg> : use <arg> as the 1st "good" disk
> -dg2 <arg> : use <arg> as the 2nd "good" disk
> -df <arg>  : use <arg> as the "failed" disk
> -dr <arg>  : use <arg> as the "replacement" disk
> EOF
> }
>
> mdlist="0 1 2 3"
>
> while [ $# -gt 0 ]; do
>     case "$1" in
> 	-m)
> 	    case "$2" in
> 		bug1part)
> 		    mdlist="0"
> 		    mode=$2 ;;
> 		bug2part)
> 		    mdlist="0 1"
> 		    mode=$2 ;;
> 		bug3part)
> 		    mdlist="0 1 2"
> 		    mode=$2 ;;
> 		bug|\
> 		fault_all_first)
> 		    mode=$2 ;;
> 		*)
> 		    usage
> 		    exit 1 ;;
> 	    esac
>             shift
>             ;;
> 	-dg1)
>             gdisk1="$2"
>             shift
>             ;;
> 	-dg2)
>             gdisk2="$2"
>             shift
>             ;;
> 	-df)
>             fdisk="$2"
>             shift
>             ;;
> 	-dr)
>             rdisk="$2"
>             shift
>             ;;
> 	-h|--help|-help)
>             usage
>             exit 0
>             ;;
> 	-stop)
>             v_stop=1
>             ;;
> 	-create)
>             v_create=1
>             ;;
> 	*)
>             usage
> 	    echo "Unknown argument: $1"
>             exit 1
>             ;;
>     esac
>     shift;
> done
>
>
> [ -n "$gdisk1" -a -n "$gdisk2" -a -n "$fdisk" -a -n "$rdisk" ] || {
>     usage
>     echo "Need all 4 disks supplied (good[12]/failed/replacement)"
>     exit 1
> }
>
> if [ -n "$v_stop" ]; then
>     for md in $mdlist ; do
> 	do_md $md "stop"
>     done
> fi
>
> sleep 1
>
> if [ -n "$v_create" ]; then
>     for md in $mdlist ; do
> 	do_md $md "create" $gdisk1 $gdisk2
>     done
> fi
>
> sleep 1
>
> if [ -z "$mode" ]; then
>     echo "No mode provided; exiting"
>     exit 0
> fi
>
> case $mode in
>     bug*) do_mode_bug ;;
>     *) do_mode_$mode ;;
> esac



Thanks,
Brett
