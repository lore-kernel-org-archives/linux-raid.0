From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH RFC] test: revise 'test' and make it easier to understand
Date: Tue, 28 Feb 2017 10:47:33 +0800
Message-ID: <1488250053-10436-1-git-send-email-zlliu@suse.com>
References: <a81137d5-3042-e983-fe0e-1b9a0de836ff@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a81137d5-3042-e983-fe0e-1b9a0de836ff@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.com, Jes.Sorensen@redhat.com
Cc: linux-raid@vger.kernel.org, gqjiang@suse.com, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

1. use 'Tab' as the code style.
2. arrange the testing steps and provide the 'main' entrance.
3. draft the log_save feature, it captures the /proc/mdstat,
   md superblock info, bitmap info and the detail dmesg.
4. modified the mdadm() func, adding the operation that clear
   the superblock when create or build one new array, and it
   would exit testing when mdadm command returned non-0 value.
5. delete no_errors() func, it only used in tests/04update-uuid,
   I recommend the new mdadm() using method.
6. delete fast_sync() func.
7. testdev(), add the object file checking, otherwise this command
   would create one regular file, it's one trouble thing.
8. add dmesg checking in do_test() func, it's necessary to check
   dmesg whether or not printed abnormal message.
9. add checking conditions in main(), such as $pwd/raid6check need
   exists, here is a prompt to remind users to 'make everything'
   before testing; the $targetdir should mount under ext[2-4] FS,
   because the external bitmap only supports ext, the bmap() API
   of bitmap.c doesn't exist in all filesystem, such as btrfs.

Signed-off-by: Zhilong Liu <zlliu@suse.com>

diff --git a/test b/test
index 13f1bda..e23addb 100755
--- a/test
+++ b/test
@@ -1,36 +1,21 @@
 #!/bin/bash
 #
 # run test suite for mdadm
-user=`id -un`
-if [ " $user" != " root" ]
-then echo >&2 "test: testing can only be done as 'root'."
-     exit 1;
-fi
-
-prefix='[0-9][0-9]'
-
-dir=`pwd`
+dir=$(pwd)
+DEVTYPE=loop
 mdadm=$dir/mdadm
-if [ \! -x $mdadm ]
-then
-   echo >&2 "test: $mdadm isn't usable."
-fi
-
 testdir="tests"
-logdir="$testdir/logs"
 logsave=0
 exitonerror=1
-
-echo "Testing on linux-$(uname -r) kernel"
-
-# Check whether to run multipath tests
-modprobe multipath 2> /dev/null
-if grep -s 'Personalities : .*multipath' > /dev/null /proc/mdstat ; then
-    MULTIPATH="yes"
-fi
+prefix='[0-9][0-9]'
 INTEGRITY=yes
-DEVTYPE=loop
 LVM_VOLGROUP=mdtest
+targetdir="/var/tmp/mdtest"
+[ -d "$targetdir" ] &&
+	rm -fr $targetdir
+logdir="$dir/$testdir/log"
+[ -d "$logdir" ] &&
+	rm -fr $logdir
 
 # make sure to test local mdmon, not system one
 export MDADM_NO_SYSTEMCTL=1
@@ -42,7 +27,7 @@ mdp1=/dev/md_d1
 
 # We test mdadm on loop-back block devices.
 # dir for storing files should be settable by command line maybe
-targetdir=/var/tmp
+#targetdir=/var/tmp/mdtest
 size=20000
 # super0, round down to multiple of 64 and substract 64
 mdsize0=19904
@@ -68,22 +53,64 @@ config=/tmp/mdadm.conf
 
 cleanup() {
 	udevadm settle
-	$mdadm -Ssq 2> /dev/null
-        case $DEVTYPE in
-        loop)
-	  for d in 0 1 2 3 4 5 6 7  8 9 10 11 12 13
-	  do
-	    losetup -d /dev/loop$d ; # rm -f $targetdir/mdtest$d
-	    rm -f /dev/disk/by-path/loop*
-	  done
-          ;;
-        lvm)
-	  for d in 0 1 2 3 4 5 6 7  8 9 10 11 12 13
-	  do
-	    eval "lvremove --quiet -f \$dev$d"
-	  done
-          ;;
-        esac
+	$mdadm -Ssq
+	case $DEVTYPE in
+		loop )
+			for d in 0 1 2 3 4 5 6 7  8 9 10 11 12 13
+			do
+				losetup -d /dev/loop$d ; # rm -f $targetdir/mdtest$d
+				rm -f /dev/disk/by-path/loop*
+			done
+		;;
+		lvm )
+			for d in 0 1 2 3 4 5 6 7  8 9 10 11 12 13
+			do
+				eval "lvremove --quiet -f \$dev$d"
+			done
+		;;
+	esac
+	dmesg -c > /dev/null
+}
+
+die()
+{
+	echo -e "\n\tERROR: $* \n"
+	log_save fail
+	exit 2
+}
+
+# add save_log func, $1 is the flag why save log.
+log_save() {
+	status=$1
+	save_log="$status""$_basename".log
+
+	echo "## $HOSTNAME: dmesg saved." >> $logdir/$save_log
+	dmesg -c >> $logdir/$save_log
+	$mdadm -As 2> /dev/null
+	echo "## $HOSTNAME: md status message saved." >> $logdir/$save_log
+	cat /proc/mdstat >> $logdir/$save_log
+
+	if [ $DEVTYPE == 'lvm' ]
+	then
+		# waiting for supporting.
+		echo
+	elif [ $DEVTYPE == 'loop' ]
+	then
+		array=($($mdadm -Ds | cut -d' ' -f2))
+		if [ ${#array[@]} -ge 1 ]; then
+			md_disks=($($mdadm -D -Y ${array[@]} | grep "/dev/$DEVTYPE" | cut -d'=' -f2))
+			echo "## $HOSTNAME: mdadm -D ${array[@]}" >> $logdir/$save_log
+			$mdadm -D ${array[@]} >> $logdir/$save_log
+			$mdadm -X $md_disks &> /dev/null
+			if [ $? -eq 0 ]
+			then
+				echo "## $HOSTNAME: mdadm -X ${md_disks[@]}" >> $logdir/$save_log
+				$mdadm -X ${md_disks[@]} >> $logdir/$save_log
+			fi
+		elif [ ${#array[@]} -lt 1 ]; then
+			echo "## $HOSTNAME: no array assembled!" >> $logdir/$save_log
+		fi
+	fi
 }
 
 ctrl_c() {
@@ -91,350 +118,374 @@ ctrl_c() {
 }
 
 do_setup() {
-  trap cleanup 0 1 3 15
-  trap ctrl_c 2
+	trap cleanup 0 1 3 15
+	trap ctrl_c 2
 
-  # make sure there are no loop devices remaining.
-  # udev started things can sometimes prevent them being stopped
-  # immediately
-  while grep loop /proc/partitions > /dev/null 2>&1
-  do
-    mdadm -Ss
-    losetup -d /dev/loop[0-9]* 2> /dev/null
-    sleep 1
-  done
-  devlist=
-  for d in 0 1 2 3 4 5 6 7 8 9 10 11 12 13
-  do
-    sz=$size
-    if [ $d -gt 7 ]; then sz=$ddfsize ; fi
-    case $DEVTYPE in
-    loop)
-      [ -f $targetdir/mdtest$d ] || dd if=/dev/zero of=$targetdir/mdtest$d count=$sz bs=1K > /dev/null 2>&1
-      # make sure udev doesn't touch
-      mdadm --zero $targetdir/mdtest$d 2> /dev/null
-      [ -b /dev/loop$d ] || mknod /dev/loop$d b 7 $d
-      if [ $d -eq 7 ]
-      then
-        losetup /dev/loop$d $targetdir/mdtest6 # for multipath use
-      else
-        losetup /dev/loop$d $targetdir/mdtest$d
-      fi
-      eval dev$d=/dev/loop$d
-      eval file$d=$targetdir/mdtest$d
-      ;;
-    lvm)
-      unset MULTIPATH
-      eval dev$d=/dev/mapper/${LVM_VOLGROUP}-mdtest$d
-      if ! lvcreate --quiet -L ${sz}K -n mdtest$d $LVM_VOLGROUP; then
-	  trap '' 0 # make sure lvremove is not called
-	  eval echo error creating \$dev$d
-	  exit 129
-      fi
-      ;;
-    ram)
-      unset MULTIPATH
-      eval dev$d=/dev/ram$d
-      ;;
-    esac
-    eval devlist=\"\$devlist \$dev$d\"
-    eval devlist$d=\"\$devlist\"
-   #" <-- add this quote to un-confuse vim syntax highlighting
-  done
-  path0=$dev6
-  path1=$dev7
+	# make sure there are no loop devices remaining.
+	# udev started things can sometimes prevent them being stopped
+	# immediately
+	while grep loop /proc/partitions > /dev/null 2>&1
+	do
+		mdadm -Ss
+		losetup -d /dev/loop[0-9]* 2> /dev/null
+		sleep 0.2
+	done
+	devlist=
+	for d in 0 1 2 3 4 5 6 7 8 9 10 11 12 13
+	do
+		sz=$size
+		[ $d -gt 7 ] && sz=$ddfsize
+		case $DEVTYPE in
+		loop )
+			[ -f $targetdir/mdtest$d ] ||
+				dd if=/dev/zero of=$targetdir/mdtest$d count=$sz bs=1K > /dev/null 2>&1
+			# make sure udev doesn't touch
+			mdadm --zero $targetdir/mdtest$d 2> /dev/null
+			[ -b /dev/loop$d ] || mknod /dev/loop$d b 7 $d
+			if [ $d -eq 7 ]
+			then
+				losetup /dev/loop$d $targetdir/mdtest6 # for multipath use
+			else
+				losetup /dev/loop$d $targetdir/mdtest$d
+			fi
+			eval dev$d=/dev/loop$d
+			eval file$d=$targetdir/mdtest$d
+		;;
+		lvm )
+			unset MULTIPATH
+			eval dev$d=/dev/mapper/${LVM_VOLGROUP}-mdtest$d
+			if ! lvcreate --quiet -L ${sz}K -n mdtest$d $LVM_VOLGROUP; then
+				trap '' 0 # make sure lvremove is not called
+				eval echo error creating \$dev$d
+				exit 129
+			fi
+		;;
+		ram )
+			unset MULTIPATH
+			eval dev$d=/dev/ram$d
+		;;
+		esac
+		eval devlist=\"\$devlist \$dev$d\"
+		eval devlist$d=\"\$devlist\"
+		#" <-- add this quote to un-confuse vim syntax highlighting
+	done
+	path0=$dev6
+	path1=$dev7
 
-  ulimit -c unlimited
-  [ -f /proc/mdstat ] || modprobe md_mod
-  echo 2000 > /proc/sys/dev/raid/speed_limit_max
-  echo 0 > /sys/module/md_mod/parameters/start_ro
+	ulimit -c unlimited
+	[ -f /proc/mdstat ] || modprobe md_mod
+	echo 2000 > /proc/sys/dev/raid/speed_limit_max
+	echo 0 > /sys/module/md_mod/parameters/start_ro
 }
 
 # mdadm always adds --quiet, and we want to see any unexpected messages
 mdadm() {
-    rm -f $targetdir/stderr
-    case $* in
-	*-S* ) udevadm settle
-	       p=`cat /proc/sys/dev/raid/speed_limit_max`
-	       echo 20000 > /proc/sys/dev/raid/speed_limit_max
-    esac
-    case $* in
-	*-C* ) $mdadm 2> $targetdir/stderr --quiet "$@" --auto=yes;;
-	* )    $mdadm 2> $targetdir/stderr --quiet "$@"
-    esac
-    rv=$?
-    case $* in
-	*-S* ) udevadm settle
-	       echo $p > /proc/sys/dev/raid/speed_limit_max
-    esac
-    cat >&2 $targetdir/stderr
-    return $rv
+	rm -f $targetdir/stderr
+	case $* in
+		*-S* )
+			udevadm settle
+			p=`cat /proc/sys/dev/raid/speed_limit_max`
+			echo 20000 > /proc/sys/dev/raid/speed_limit_max
+	esac
+	case $* in
+		*-C* | *--create* | *-B* | *--build* )
+			for args in $*
+			do
+				[[ $args =~ "/dev/" ]] && {
+					[[ $args =~ "md" ]] ||
+						$mdadm --zero $args > /dev/null
+					}
+			done
+			$mdadm 2> $targetdir/stderr --quiet "$@" --auto=yes
+		;;
+		* )
+			$mdadm 2> $targetdir/stderr --quiet "$@"
+	esac
+	rv=$?
+	case $* in
+		*-S* )
+			udevadm settle
+			echo $p > /proc/sys/dev/raid/speed_limit_max
+	esac
+	cat >&2 $targetdir/stderr > $targetdir/log
+	[  $rv -ne 0 ] && exit 1
+	return $rv
 }
 
 # check various things
 check() {
-   case $1 in
-    spares )
-       spares=`tr '] ' '\012\012' < /proc/mdstat | grep -c '(S)' || exit 0`
-       if [ $spares -ne $2 ]
-       then
-          echo >&2 "ERROR expected $2 spares, found $spares"; exit 1;
-       fi
-      ;;
-    raid* | linear )
-      grep -s "active $1 " /proc/mdstat > /dev/null || {
-		echo >&2 "ERROR active $1 not found" ; cat /proc/mdstat ; exit 1;}
-     ;;
-    algorithm )
-      grep -s " algorithm $2 " /proc/mdstat > /dev/null || {
-	  echo >&2 "ERROR algorithm $2 not found"; cat /proc/mdstat; exit 1;}
-     ;;
-    resync | recovery | reshape)
-	cnt=5
-	while ! grep -s $1 /proc/mdstat > /dev/null
-	do
-	    if [ $cnt -gt 0 ] && grep -v idle /sys/block/md*/md/sync_action > /dev/null
-	    then # Something isn't idle - wait a bit
-		sleep 0.5
-		cnt=$[cnt-1]
-	    else
-		echo >&2 ERROR no $1 happening; cat /proc/mdstat; exit 1
-	    fi
-	done
-	;;
-
-     nosync )
-       sleep 0.5
-       # Since 4.2 we delay the close of recovery until there has been a chance for
-       # spares to be activated.  That means that a recovery that finds nothing
-       # to do can still take a little longer than expected.
-       # add an extra check: is sync_completed shows the end is reached, assume
-       # there is no recovery.
-       if grep -s -E '(resync|recovery|reshape) *=' > /dev/null /proc/mdstat ; then
-	   incomplete=`grep / /sys/block/md*/md/sync_completed 2> /dev/null | sed '/^ *\([0-9]*\) \/ \1/d'`
-	   if [ -n "$incomplete" ]; then
-		echo >&2 "ERROR resync or recovery is happening!"; cat /proc/mdstat ; exit 1;
-	   fi
-       fi
-     ;;
-
-    wait )
-      p=`cat /proc/sys/dev/raid/speed_limit_max`
-      echo 2000000 > /proc/sys/dev/raid/speed_limit_max
-      sleep 0.1
-      while grep -E '(resync|recovery|reshape|check|repair) *=' > /dev/null /proc/mdstat ||
-	      grep -v idle > /dev/null /sys/block/md*/md/sync_action
-      do sleep 0.5;
-      done
-      echo $p > /proc/sys/dev/raid/speed_limit_max
-      ;;
-
-    state )
-       grep -s "blocks.*\[$2\]\$" /proc/mdstat > /dev/null || {
-		echo >&2 "ERROR state $2 not found!"; cat /proc/mdstat ; exit 1; }
-       sleep 0.5
-      ;;
-
-    bitmap )
-       grep -s bitmap > /dev/null /proc/mdstat || {
-		echo >&2 ERROR no bitmap ; cat /proc/mdstat ; exit 1; }
-      ;;
-    nobitmap )
-       if grep -s "bitmap" > /dev/null /proc/mdstat
-       then
-		echo >&2 ERROR bitmap present ; cat /proc/mdstat ; exit 1;
-       fi
-      ;;
-
-    readonly )
-       grep -s "read-only" > /dev/null /proc/mdstat || {
-                echo >&2 "ERROR array is not read-only!"; cat /proc/mdstat ; exit 1; }
-      ;;
-
-    inactive )
-       grep -s "inactive" > /dev/null /proc/mdstat || {
-                echo >&2 "ERROR array is not inactive!"; cat /proc/mdstat ; exit 1; }
-      ;;
-    * ) echo >&2 ERROR unknown check $1 ; exit 1;
-   esac
+	case $1 in
+		spares )
+			spares=$(tr '] ' '\012\012' < /proc/mdstat | grep -c '(S)')
+			[ $spares -ne $2 ] &&
+				die "expected $2 spares, found $spares"
+		;;
+		raid* | linear )
+			grep -s -q "active $1 " /proc/mdstat ||
+				die "active $1 not found"
+		;;
+		algorithm )
+			grep -s -q " algorithm $2 " /proc/mdstat ||
+				die "algorithm $2 not found"
+		;;
+		resync | recovery | reshape )
+			cnt=5
+			while ! grep -s $1 /proc/mdstat > /dev/null
+			do
+				if [ $cnt -gt 0 ]
+				then # Something isn't idle - wait a bit
+					sleep 0.5
+					cnt=$[cnt-1]
+				else
+					die "no $1 happening"
+				fi
+			done
+		;;
+		nosync )
+			sleep 0.5
+			# Since 4.2 we delay the close of recovery until there has been a chance for
+			# spares to be activated.  That means that a recovery that finds nothing
+			# to do can still take a little longer than expected.
+			# add an extra check: is sync_completed shows the end is reached, assume
+			# there is no recovery.
+			if grep -s -E -q '(resync|recovery|reshape) *=' /proc/mdstat
+			then
+				incomplete=`grep / /sys/block/md*/md/sync_completed 2> /dev/null | sed '/^ *\([0-9]*\) \/ \1/d'`
+				[ -n "$incomplete" ] &&
+					die "resync or recovery is happening!"
+			fi
+		;;
+		wait )
+			p=$(cat /proc/sys/dev/raid/speed_limit_max)
+			echo 2000000 > /proc/sys/dev/raid/speed_limit_max
+			sleep 0.1
+			while grep -E -q '(resync|recovery|reshape|check|repair) *=' /proc/mdstat ||
+				grep -v idle > /dev/null /sys/block/md*/md/sync_action
+			do sleep 0.5;
+			done
+			echo $p > /proc/sys/dev/raid/speed_limit_max
+		;;
+		state )
+			grep -s -q "blocks.*\[$2\]\$" /proc/mdstat ||
+				die "state $2 not found!"
+			sleep 0.5
+		;;
+		bitmap )
+			grep -s -q bitmap /proc/mdstat ||
+				die "no bitmap found in /proc/mdstat"
+		;;
+		nobitmap )
+			grep -s -q "bitmap" /proc/mdstat &&
+				die "bitmap present in /proc/mdstat"
+		;;
+		readonly )
+			grep -s -q "read-only" /proc/mdstat ||
+				die "array is not read-only!"
+		;;
+		inactive )
+			grep -s -q "inactive" /proc/mdstat ||
+				die "array is not inactive!"
+		;;
+		* )
+			die "check $1 is unknown!"
+	esac
 }
 
-no_errors() {
-  if [ -s $targetdir/stderr ]
-  then echo Bad errors from mdadm: ; cat $targetdir/stderr; exit 2;
-  fi
-}
 # basic device test
-
 testdev() {
-   udevadm settle
-   dev=$1
-   cnt=$2
-   dvsize=$3
-   chunk=$4
-   if [ -z "$5" ]; then
-      mkfs.ext3 -F -j $dev > /dev/null 2>&1 && fsck -fn $dev >&2
-   fi
-   dsize=$[dvsize/chunk]
-   dsize=$[dsize*chunk]
-   rasize=$[dsize*2*cnt]
-   # rasize is in sectors
-   if [ -n "$DEV_ROUND_K" ]; then
-      rasize=$[rasize/DEV_ROUND_K/2]
-      rasize=$[rasize*DEV_ROUND_K*2]
-   fi
-   if [ `/sbin/blockdev --getsize $dev` -eq 0 ]; then sleep 2 ; fi
-   _sz=`/sbin/blockdev --getsize $dev`
-   if [ $rasize -lt $_sz -o $[rasize*4/5] -gt $_sz ]
-   then
-     echo "ERROR: size is wrong for $dev: $cnt * $dvsize (chunk=$chunk) = $rasize, not $_sz"
-     exit 1
-   fi
-}
-
-fast_sync() {
-  echo 200000 > /proc/sys/dev/raid/speed_limit_max
+# add the necessary checking when received object file, such as testdev /dev/md0
+# it would be created one regular file if /dev/md0 doesn't pull up, the rest testing
+# scripts would be affected.
+	[ -f $1 ] && rm -f $1
+	[ -b $1 ] || die "$1 doesn't exist!"
+	udevadm settle
+	dev=$1
+	cnt=$2
+	dvsize=$3
+	chunk=$4
+	if [ -z "$5" ]; then
+		mkfs.ext3 -F -j $dev > /dev/null 2>&1 && fsck -fn $dev >&2
+	fi
+	dsize=$[dvsize/chunk]
+	dsize=$[dsize*chunk]
+	rasize=$[dsize*2*cnt]
+	# rasize is in sectors
+	if [ -n "$DEV_ROUND_K" ]; then
+		rasize=$[rasize/DEV_ROUND_K/2]
+		rasize=$[rasize*DEV_ROUND_K*2]
+	fi
+	[ `/sbin/blockdev --getsize $dev` -eq 0 ] && sleep 2
+	_sz=`/sbin/blockdev --getsize $dev`
+	[ $rasize -lt $_sz -o $[rasize*4/5] -gt $_sz ] &&
+		die "size is wrong for $dev: $cnt * $dvsize (chunk=$chunk) = $rasize, not $_sz"
+
+# sometimes the above command would return non-0
+	return 0
 }
 
 rotest() {
-  dev=$1
-  fsck -fn $dev >&2
+	dev=$1
+	fsck -fn $dev >&2
 }
 
 do_test() {
-  _script=$1
-  _basename=`basename $_script`
-  if [ -f "$_script" ]
-  then
-    rm -f $targetdir/stderr
-    # stop all arrays, just incase some script left an array active.
-    $mdadm -Ssq 2> /dev/null
-    mdadm --zero $devlist 2> /dev/null
-    mdadm --zero $devlist 2> /dev/null
-    # this might have been reset: restore the default.
-    echo 2000 > /proc/sys/dev/raid/speed_limit_max
-    # source script in a subshell, so it has access to our
-    # namespace, but cannot change it.
-    echo -ne "$_script... "
-    if ( set -ex ; . $_script ) &> $targetdir/log
-    then
-      echo "succeeded"
-      _fail=0
-    else
-      log=log
-      cat $targetdir/stderr >> $targetdir/log
-      echo "=======================dmesg=================" >> $targetdir/log
-      dmesg | tail -n 200 >> $targetdir/log
-      if [ $exitonerror == 0 ]; then
-	  log=log-`basename $_script`
-	  mv $targetdir/log $logdir/$log
-      fi
-      echo "FAILED - see $logdir/$log for details"
-      _fail=1
-    fi
-    if [ "$savelogs" == "1" ]; then
-      cp $targetdir/log $logdir/$_basename.log
-    fi
-    if [ "$_fail" == "1" -a "$exitonerror" == "1" ]; then
-      exit 1
-    fi
-  fi
+	_script=$1
+	_basename=`basename $_script`
+	if [ -f "$_script" ]
+	then
+		rm -f $targetdir/stderr
+		# stop all arrays, just incase some script left an array active.
+		$mdadm -Ssq 2> /dev/null
+		mdadm --zero $devlist 2> /dev/null
+		# this might have been reset: restore the default.
+		echo 2000 > /proc/sys/dev/raid/speed_limit_max
+		# source script in a subshell, so it has access to our
+		# namespace, but cannot change it.
+		echo -ne "$_script... "
+		if ( set -ex ; . $_script ) &> $targetdir/log
+		then
+# put the dmesg checking here, the following key-words shouldn't appeared during testing.
+			dmesg | grep -i "error\|call trace\|segfault" &&
+				die "dmesg printed error when testing $_basename!"
+			echo "succeeded"
+			_fail=0
+		else
+			log=log-$_basename
+			cat $targetdir/stderr >> $targetdir/log
+			log_save fail
+			mv $targetdir/log $logdir/$log
+			echo "FAILED - see $logdir/$log for details"
+			_fail=1
+		fi
+		[ "$savelogs" == "1" ] &&
+			cp $targetdir/log $logdir/$_basename.log
+		[ "$_fail" == "1" -a "$exitonerror" == "1" ] && exit 1
+	fi
+
+	return 0
 }
 
+# just a recommend.
 do_help() {
-  echo "Usage: $0 [options]"
-  echo " Options:"
-  echo "    --tests=<test1,test2,..>    Comma separated list of tests to run"
-  echo "    --disable-multipath         Disable any tests involving multipath"
-  echo "    --disable-integrity         Disable slow tests of RAID[56] consistency"
-  echo "    --logdir=<directory>        Directory to save logfiles in"
-  echo "    --save-logs                 Save all logs in <logdir>"
-  echo "    --keep-going                Don't stop on error, ie. run all tests"
-  echo "    --dev=[loop|lvm|ram]        Use loop devices (default), LVM, or RAM disk"
-  echo "    --volgroup=<name>           LVM volume group for LVM test"
-  echo "    setup                       Setup test environment and exit"
-  echo "    cleanup                     Cleanup test environment"
-  echo "    <prefix>                    Run tests with <prefix>"
+	cat <<-EOF
+	Usage: $0 [options]
+	Options:
+		--tests=<test1,test2,..>    Comma separated list of tests to run
+		--disable-multipath         Disable any tests involving multipath
+		--disable-integrity         Disable slow tests of RAID[56] consistency
+		--logdir=<directory>        Directory to save logfiles in
+		--save-logs                 Save all logs in <logdir>
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
-  for i in $*
-  do
-    case $i in
-    [0-9]*)
-      prefix=$i
-      ;;
-    setup)
-      echo "mdadm test environment setup"
-      do_setup
-      trap 0; exit 0
-      ;;
-    cleanup)
-      cleanup
-      exit 0
-      ;;
-    --tests=*)
-      TESTLIST=`expr "x$i" : 'x[^=]*=\(.*\)' | sed -e 's/,/ /g'`
-      ;;
-    --logdir=*)
-      logdir=`expr "x$i" : 'x[^=]*=\(.*\)'`
-      ;;
-    --save-logs)
-      savelogs=1
-      ;;
-    --keep-going | --no-error)
-      exitonerror=0
-      ;;
-    --disable-multipath)
-      unset MULTIPATH
-      ;;
-    --disable-integrity)
-      unset INTEGRITY
-      ;;
-    --dev=loop)
-      DEVTYPE=loop
-      ;;
-    --dev=lvm)
-      DEVTYPE=lvm
-      ;;
-    --dev=ram)
-      DEVTYPE=ram
-      ;;
-    --volgroup=*)
-      LVM_VOLGROUP=`expr "x$i" : 'x[^=]*=\(.*\)'`
-      ;;
-    --help)
-      do_help
-      exit 0;
-      ;;
-    -*)
-      echo " $0: Unknown argument: $i"
-      do_help
-      exit 0;
-      ;;
-    esac
-done
+	for i in $*
+	do
+		case $i in
+			[0-9]* )
+				prefix=$i
+			;;
+			setup )
+				echo "mdadm test environment setup"
+				do_setup
+				trap 0; exit 0
+			;;
+			cleanup )
+				cleanup
+				exit 0
+			;;
+			--tests=* )
+				TESTLIST=`expr "x$i" : 'x[^=]*=\(.*\)' | sed -e 's/,/ /g'`
+			;;
+			--logdir=* )
+				logdir=`expr "x$i" : 'x[^=]*=\(.*\)'`
+			;;
+			--save-logs )
+				savelogs=1
+			;;
+			--keep-going | --no-error )
+				exitonerror=0
+			;;
+			--disable-multipath )
+				unset MULTIPATH
+			;;
+			--disable-integrity )
+				unset INTEGRITY
+			;;
+			--dev=loop )
+				DEVTYPE=loop
+			;;
+			--dev=lvm )
+				DEVTYPE=lvm
+			;;
+			--dev=ram )
+				DEVTYPE=ram
+			;;
+			--volgroup=* )
+				LVM_VOLGROUP=`expr "x$i" : 'x[^=]*=\(.*\)'`
+			;;
+			--help )
+				do_help
+			;;
+			-* )
+				echo " $0: Unknown argument: $i"
+				do_help
+		;;
+		esac
+	done
 }
 
-logdir=$targetdir
-parse_args $@
-
-do_setup
-mkdir -p $logdir
-
-if [ "$savelogs" == "1" ]; then
-  echo "Saving logs to $logdir"
-fi
+# draft the main func
+main() {
+	[ "X$(id -un)" != "Xroot" ] && {
+		echo "test: testing can only be done as 'root'."
+		exit 1
+	}
+	[ -x $mdadm -a -x "test" ] || {
+		echo "test: $mdadm or '$dir/test' isn't usable."
+		exit 1
+	}
+	[ -x raid6check ] || {
+		echo "test: please run 'make everything' before testing."
+		exit 1
+	}
+	mkdir -p $targetdir
+	mkdir -p $logdir
+	# such as the external bitmap only support the ext file system.
+	# users can modify the $targetdir path under ext3 mount point.
+	[[ $(df $targetdir -T) =~ ext ]] || {
+		echo "ensure that $targetdir mounted under ext[2,3,4] filesystem!"
+		exit 1
+	}
+	echo "Testing on linux-$(uname -r) kernel"
+	[ "$savelogs" == "1" ] &&
+		echo "Saving logs to $logdir"
+	# Check whether to run multipath tests
+	modprobe multipath 2> /dev/null
+	grep -s -q 'Personalities : .*multipath' /proc/mdstat &&
+		MULTIPATH="yes"
+	do_setup
+	if [ "x$TESTLIST" != "x" ]; then
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
+
+	exit 0
+}
 
-if [ "x$TESTLIST" != "x" ]; then
-  for script in $TESTLIST
-  do
-    do_test $testdir/$script
-  done
-else
-  for script in $testdir/$prefix $testdir/$prefix*[^~]
-  do
-    do_test $script
-  done
-fi
-exit 0
+parse_args $@
+main
-- 
2.6.6

