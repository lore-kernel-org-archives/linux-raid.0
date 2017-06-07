From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH 2/3] mdadm/test: Refactor the codes of 'test' script
Date: Wed,  7 Jun 2017 17:31:27 +0800
Message-ID: <1496827888-17118-3-git-send-email-zlliu@suse.com>
References: <1496827888-17118-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1496827888-17118-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

Adding functions:
die()
  uniform the abnormal situations that have to abort.
check_env()
  do various basic checking before running test suite.
save_log()
  collect array infos, include of dmesg, superblock,
  bitmap and /proc/mdstat.
main()
  the core function of this script.

Improve functions:
cleanup()
  clear dmesg and remove the /vat/tmp/mdtest* files.
mdadm()
  clear superblock once creating or building arrays
  every time, because it's always creating arrays
  many times in a test case.
check()
  just tidy up with die(), didn't change code meanings.
testdev()
  add checking $1 must be a block device, add 'return 0'
  in final because this function exists in last line of
  test case, such as tests/05r6tor0.
do_test()
  add checking abnormal dmesg and changing log management.
do_help()
  just recommend a better way to print Usage.
parse_args()
  just tidy up.

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 test | 339 +++++++++++++++++++++++++++++++++++++------------------------------
 1 file changed, 189 insertions(+), 150 deletions(-)

diff --git a/test b/test
index 7942d6e..8ecfe99 100755
--- a/test
+++ b/test
@@ -1,35 +1,17 @@
 #!/bin/bash
 #
 # run test suite for mdadm
-user=`id -un`
-if [ " $user" != " root" ]
-then
-	echo >&2 "test: testing can only be done as 'root'."
-	exit 1
-fi
-
-prefix='[0-9][0-9]'
-
-dir=`pwd`
+dir=$(pwd)
 mdadm=$dir/mdadm
-if [ \! -x $mdadm ]
-then
-	echo >&2 "test: $mdadm isn't usable."
-fi
-
 testdir="tests"
-logdir="$testdir/logs"
-logsave=0
-exitonerror=1
+targetdir="/var/tmp"
+logdir="$targetdir"
+config=/tmp/mdadm.conf
 
-echo "Testing on linux-$(uname -r) kernel"
+savelogs=0
+exitonerror=1
+prefix='[0-9][0-9]'
 
-# Check whether to run multipath tests
-modprobe multipath 2> /dev/null
-if grep -s 'Personalities : .*multipath' > /dev/null /proc/mdstat
-then
-	MULTIPATH="yes"
-fi
 INTEGRITY=yes
 DEVTYPE=loop
 LVM_VOLGROUP=mdtest
@@ -46,7 +28,6 @@ mdp1=/dev/md_d1
 
 # We test mdadm on loop-back block devices.
 # dir for storing files should be settable by command line maybe
-targetdir=/var/tmp
 size=20000
 # super0, round down to multiple of 64 and substract 64
 mdsize0=19904
@@ -68,7 +49,47 @@ mdsize12=19988
 # ddf needs bigger devices as 32Meg is reserved!
 ddfsize=65536
 
-config=/tmp/mdadm.conf
+# $1 is optional parameter, it shows why to save log
+save_log() {
+	status=$1
+	logfile="$status""$_basename".log
+
+	echo "## $HOSTNAME: saving dmesg." >> $logdir/$logfile
+	dmesg -c >> $logdir/$logfile
+	$mdadm -As 2> /dev/null
+	echo "## $HOSTNAME: saving proc mdstat." >> $logdir/$logfile
+	cat /proc/mdstat >> $logdir/$logfile
+	array=($(mdadm -Ds | cut -d' ' -f2))
+	echo "## $HOSTNAME: mdadm -D ${array[@]}" >> $logdir/$logfile
+	$mdadm -D ${array[@]} >> $logdir/$logfile
+	# ignore saving external(external file, imsm...) bitmap
+	cat /proc/mdstat | grep -q "linear\|external" && return 0
+	if [ $DEVTYPE == 'lvm' ]
+	then
+		# not supported lvm type yet
+		echo
+	elif [ $DEVTYPE == 'loop' ]
+	then
+		if [ ! -z ${array[@]} -a ${#array[@]} -ge 1 ]
+		then
+			md_disks=($($mdadm -D -Y ${array[@]} | grep "/dev/$DEVTYPE" | cut -d'=' -f2))
+			cat /proc/mdstat | grep -q "bitmap"
+			if [ $? -eq 0 ]
+			then
+				echo "## $HOSTNAME: mdadm -X ${md_disks[@]}" >> $logdir/$logfile
+				$mdadm -X ${md_disks[@]} >> $logdir/$logfile
+			fi
+		else
+			echo "## $HOSTNAME: no array assembled!" >> $logdir/$logfile
+		fi
+	fi
+}
+
+die() {
+	echo -e "\n\tERROR: $* \n"
+	save_log fail
+	exit 2
+}
 
 cleanup() {
 	udevadm settle
@@ -77,8 +98,9 @@ cleanup() {
 	loop)
 		for d in 0 1 2 3 4 5 6 7  8 9 10 11 12 13
 		do
-			losetup -d /dev/loop$d # rm -f $targetdir/mdtest$d
+			losetup -d /dev/loop$d
 			rm -f /dev/disk/by-path/loop*
+			rm -f /var/tmp/mdtest$d
 		done
 		;;
 	lvm)
@@ -88,6 +110,7 @@ cleanup() {
 		done
 		;;
 	esac
+	dmesg -c > /dev/null
 }
 
 ctrl_c() {
@@ -98,23 +121,21 @@ do_setup() {
 	trap cleanup 0 1 3 15
 	trap ctrl_c 2
 
+	[ -d $logdir ] || mkdir -p $logdir
 	# make sure there are no loop devices remaining.
 	# udev started things can sometimes prevent them being stopped
 	# immediately
 	while grep loop /proc/partitions > /dev/null 2>&1
 	do
-		mdadm -Ss
+		$mdadm -Ssq
 		losetup -d /dev/loop[0-9]* 2> /dev/null
-		sleep 1
+		sleep 0.2
 	done
 	devlist=
 	for d in 0 1 2 3 4 5 6 7 8 9 10 11 12 13
 	do
 		sz=$size
-		if [ $d -gt 7 ]
-		then
-			sz=$ddfsize
-		fi
+		[ $d -gt 7 ] && sz=$ddfsize
 		case $DEVTYPE in
 		loop)
 			[ -f $targetdir/mdtest$d ] ||
@@ -169,7 +190,17 @@ mdadm() {
 		;;
 	esac
 	case $* in
-	*-C* )
+	*-C* | *--create* | *-B* | *--build* )
+		# clear superblock every time once creating or
+		# building arrays, because it's always creating
+		# and building array many times in a test case.
+		for args in $*
+		do
+			[[ $args =~ "/dev/" ]] && {
+				[[ $args =~ "md" ]] ||
+					$mdadm --zero $args > /dev/null
+			}
+		done
 		$mdadm 2> $targetdir/stderr --quiet "$@" --auto=yes
 		;;
 	* )
@@ -191,39 +222,28 @@ mdadm() {
 check() {
 	case $1 in
 	spares )
-		spares=`tr '] ' '\012\012' < /proc/mdstat | grep -c '(S)' || exit 0`
-		if [ $spares -ne $2 ]
-		then
-			echo >&2 "ERROR expected $2 spares, found $spares"
-			exit 1
-		fi
+		spares=$(tr '] ' '\012\012' < /proc/mdstat | grep -c '(S)' || exit 0)
+		[ $spares -ne $2 ] &&
+			die "expected $2 spares, found $spares"
 		;;
 	raid* | linear )
-		grep -s "active $1 " /proc/mdstat > /dev/null || {
-			echo >&2 "ERROR active $1 not found"
-			cat /proc/mdstat
-			exit 1
-		}
+		grep -sq "active $1 " /proc/mdstat ||
+			die "active $1 not found"
 		;;
 	algorithm )
-		grep -s " algorithm $2 " /proc/mdstat > /dev/null || {
-			echo >&2 "ERROR algorithm $2 not found"
-			cat /proc/mdstat
-			exit 1
-		}
+		grep -sq " algorithm $2 " /proc/mdstat ||
+			die "algorithm $2 not found"
 		;;
 	resync | recovery | reshape )
 		cnt=5
-		while ! grep -s $1 /proc/mdstat > /dev/null
+		while ! grep -sq $1 /proc/mdstat
 		do
 			if [ $cnt -gt 0 ] && grep -v idle /sys/block/md*/md/sync_action > /dev/null
 			then # Something isn't idle - wait a bit
 				sleep 0.5
 				cnt=$[cnt-1]
 			else
-				echo >&2 ERROR no $1 happening
-				cat /proc/mdstat
-				exit 1
+				die "no $1 happening"
 			fi
 		done
 		;;
@@ -234,22 +254,18 @@ check() {
 		# to do can still take a little longer than expected.
 		# add an extra check: is sync_completed shows the end is reached, assume
 		# there is no recovery.
-		if grep -s -E '(resync|recovery|reshape) *=' > /dev/null /proc/mdstat
+		if grep -sq -E '(resync|recovery|reshape) *=' /proc/mdstat
 		then
 			incomplete=`grep / /sys/block/md*/md/sync_completed 2> /dev/null | sed '/^ *\([0-9]*\) \/ \1/d'`
-			if [ -n "$incomplete" ]
-			then
-				echo >&2 "ERROR resync or recovery is happening!"
-				cat /proc/mdstat
-				exit 1
-			fi
+			[ -n "$incomplete" ] &&
+				die "resync or recovery is happening!"
 		fi
 		;;
 	wait )
 		p=`cat /proc/sys/dev/raid/speed_limit_max`
 		echo 2000000 > /proc/sys/dev/raid/speed_limit_max
 		sleep 0.1
-		while grep -E '(resync|recovery|reshape|check|repair) *=' > /dev/null /proc/mdstat ||
+		while grep -Eq '(resync|recovery|reshape|check|repair) *=' /proc/mdstat ||
 			grep -v idle > /dev/null /sys/block/md*/md/sync_action
 		do
 			sleep 0.5
@@ -257,45 +273,28 @@ check() {
 		echo $p > /proc/sys/dev/raid/speed_limit_max
 		;;
 	state )
-		grep -s "blocks.*\[$2\]\$" /proc/mdstat > /dev/null || {
-			echo >&2 "ERROR state $2 not found!"
-			cat /proc/mdstat
-			exit 1
-		}
+		grep -sq "blocks.*\[$2\]\$" /proc/mdstat ||
+			die "state $2 not found!"
 		sleep 0.5
 		;;
 	bitmap )
-		grep -s bitmap > /dev/null /proc/mdstat || {
-			echo >&2 ERROR no bitmap
-			cat /proc/mdstat
-			exit 1
-		}
+		grep -sq bitmap /proc/mdstat ||
+			die "no bitmap"
 		;;
 	nobitmap )
-		if grep -s "bitmap" > /dev/null /proc/mdstat
-		then
-			echo >&2 ERROR bitmap present
-			cat /proc/mdstat
-			exit 1
-		fi
+		grep -sq "bitmap" /proc/mdstat &&
+			die "bitmap present"
 		;;
 	readonly )
-		grep -s "read-only" > /dev/null /proc/mdstat || {
-			echo >&2 "ERROR array is not read-only!"
-			cat /proc/mdstat
-			exit 1
-		}
+		grep -sq "read-only" /proc/mdstat ||
+			die "array is not read-only!"
 		;;
 	inactive )
-		grep -s "inactive" > /dev/null /proc/mdstat || {
-			echo >&2 "ERROR array is not inactive!"
-			cat /proc/mdstat
-			exit 1
-		}
+		grep -sq "inactive" /proc/mdstat ||
+			die "array is not inactive!"
 		;;
 	* )
-		echo >&2 ERROR unknown check $1
-		exit 1
+		die "unknown check $1"
 		;;
 	esac
 }
@@ -311,6 +310,8 @@ no_errors() {
 
 # basic device test
 testdev() {
+	# $1 must be a block device
+	[ -b $1 ] || die "$1 isn't a block device."
 	udevadm settle
 	dev=$1
 	cnt=$2
@@ -329,16 +330,11 @@ testdev() {
 		rasize=$[rasize/DEV_ROUND_K/2]
 		rasize=$[rasize*DEV_ROUND_K*2]
 	fi
-	if [ `/sbin/blockdev --getsize $dev` -eq 0 ]
-	then
-		sleep 2
-	fi
+	[ `/sbin/blockdev --getsize $dev` -eq 0 ] && sleep 2
 	_sz=`/sbin/blockdev --getsize $dev`
-	if [ $rasize -lt $_sz -o $[rasize*4/5] -gt $_sz ]
-	then
-		echo "ERROR: size is wrong for $dev: $cnt * $dvsize (chunk=$chunk) = $rasize, not $_sz"
-		exit 1
-	fi
+	[ $rasize -lt $_sz -o $[rasize*4/5] -gt $_sz ] &&
+		die "size is wrong for $dev: $cnt * $dvsize (chunk=$chunk) = $rasize, not $_sz"
+	return 0
 }
 
 fast_sync() {
@@ -359,7 +355,6 @@ do_test() {
 		# stop all arrays, just incase some script left an array active.
 		$mdadm -Ssq 2> /dev/null
 		mdadm --zero $devlist 2> /dev/null
-		mdadm --zero $devlist 2> /dev/null
 		# this might have been reset: restore the default.
 		echo 2000 > /proc/sys/dev/raid/speed_limit_max
 		# source script in a subshell, so it has access to our
@@ -367,45 +362,43 @@ do_test() {
 		echo -ne "$_script... "
 		if ( set -ex ; . $_script ) &> $targetdir/log
 		then
+			dmesg | grep -iq "error\|call trace\|segfault" &&
+				die "dmesg prints errors when testing $_basename"
 			echo "succeeded"
 			_fail=0
 		else
-			log=log
 			cat $targetdir/stderr >> $targetdir/log
-			echo "=======================dmesg=================" >> $targetdir/log
-			dmesg | tail -n 200 >> $targetdir/log
-			if [ $exitonerror == 0 ]; then
-				log=log-`basename $_script`
-				mv $targetdir/log $logdir/$log
-			fi
-			echo "FAILED - see $logdir/$log for details"
+			save_log fail
+			cp $targetdir/log $logdir/$_basename.log
+			echo "FAILED - see $logdir/$_basename.log and $logdir/$logfile for details"
 			_fail=1
 		fi
 		if [ "$savelogs" == "1" ]
 		then
-			cp $targetdir/log $logdir/$_basename.log
-		fi
-		if [ "$_fail" == "1" -a "$exitonerror" == "1" ]
-		then
-			exit 1
+			[ "$targetdir" != "$logdir" ] &&
+				mv $targetdir/log $logdir/$_basename.log
 		fi
+		[ "$_fail" == "1" -a "$exitonerror" == "1" ] && exit 1
 	fi
 }
 
 do_help() {
-	echo "Usage: $0 [options]"
-	echo " Options:"
-	echo "    --tests=<test1,test2,..>    Comma separated list of tests to run"
-	echo "    --disable-multipath         Disable any tests involving multipath"
-	echo "    --disable-integrity         Disable slow tests of RAID[56] consistency"
-	echo "    --logdir=<directory>        Directory to save logfiles in"
-	echo "    --save-logs                 Save all logs in <logdir>"
-	echo "    --keep-going                Don't stop on error, ie. run all tests"
-	echo "    --dev=[loop|lvm|ram]        Use loop devices (default), LVM, or RAM disk"
-	echo "    --volgroup=<name>           LVM volume group for LVM test"
-	echo "    setup                       Setup test environment and exit"
-	echo "    cleanup                     Cleanup test environment"
-	echo "    <prefix>                    Run tests with <prefix>"
+	cat <<-EOF
+	Usage: $0 [options]
+	Options:
+		--tests=<test1,test2,..>    Comma separated list of tests to run
+		--disable-multipath         Disable any tests involving multipath
+		--disable-integrity         Disable slow tests of RAID[56] consistency
+		--logdir=<directory>        Directory to save all logfiles in
+		--save-logs                 Usually use with --logdir together
+		--keep-going                Don't stop on error, ie. run all tests
+		--dev=[loop|lvm|ram]        Use loop devices (default), LVM, or RAM disk
+		--volgroup=<name>           LVM volume group for LVM test
+		setup                       Setup test environment and exit
+		cleanup                     Cleanup test environment
+		<prefix>                    Run tests with <prefix>
+	EOF
+	exit 0
 }
 
 parse_args() {
@@ -457,38 +450,84 @@ parse_args() {
 			;;
 		--help )
 			do_help
-			exit 0
 			;;
 		-* )
 			echo " $0: Unknown argument: $i"
 			do_help
-			exit 0
 			;;
 		esac
 	done
 }
 
-logdir=$targetdir
-parse_args $@
+check_env() {
+	user=$(id -un)
+	[ "X$user" != "Xroot" ] && {
+		echo "test: testing can only be done as 'root'."
+		exit 1
+	}
+	[ -x "raid6check" -a -x $mdadm ] || {
+		echo "test: please run 'make everything' before perform testing."
+		exit 1
+	}
+	for cmd in mdadm lsblk df udevadm losetup mkfs.ext3
+	do
+		which $cmd > /dev/null || {
+			echo "$cmd command not found!"
+			exit 1
+		}
+	done
+	mdadm_src_ver="$($mdadm -V 2>&1)"
+	mdadm_sbin_ver="$($(which mdadm) -V 2>&1)"
+	if [ "$mdadm_src_ver" != "$mdadm_sbin_ver" ]
+	then
+		# it's nessesary to 'make install' mdadm to /SBIN/DIR,
+		# such as systemd/mdadm-grow-continue@.service, would
+		# run as an instance by systemd when reshape happens,
+		# thus ensure that the correct mdadm is in testing.
+		echo "test: please run 'make install' before testing."
+		exit 1
+	fi
+	if ! $(df -T . | grep -iq ext)
+	then
+		# 'external file' bitmap only supports with ext[2-4] file system
+		echo "test: please run test suite with ext[2-4] file system."
+		exit 1
+	fi
+	if $(lsblk -a | grep -iq raid)
+	then
+		# For test purpose, it's better to make environment simple,
+		# donot run mdadm -Ss directly if there are RAIDs working.
+		echo "test: please run test suite without running RAIDs environment."
+		exit 1
+	fi
+	# Check whether to run multipath tests
+	modprobe multipath 2> /dev/null
+	grep -sq 'Personalities : .*multipath' /proc/mdstat &&
+		MULTIPATH="yes"
+}
 
-do_setup
-mkdir -p $logdir
+main() {
+	check_env
+	do_setup
+
+	echo "Testing on linux-$(uname -r) kernel"
+	[ "$savelogs" == "1" ] &&
+		echo "Saving logs to $logdir"
+	if [ "x$TESTLIST" != "x" ]
+	then
+		for script in $TESTLIST
+		do
+			do_test $testdir/$script
+		done
+	else
+		for script in $testdir/$prefix $testdir/$prefix*[^~]
+		do
+			do_test $script
+		done
+	fi
 
-if [ "$savelogs" == "1" ]
-then
-	echo "Saving logs to $logdir"
-fi
+	exit 0
+}
 
-if [ "x$TESTLIST" != "x" ]
-then
-	for script in $TESTLIST
-	do
-		do_test $testdir/$script
-	done
-else
-	for script in $testdir/$prefix $testdir/$prefix*[^~]
-	do
-		do_test $script
-	done
-fi
-exit 0
+parse_args $@
+main
-- 
2.6.6

