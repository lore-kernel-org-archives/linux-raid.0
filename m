From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH] Spare migration tests
Date: Thu, 25 Nov 2010 10:14:06 +0000
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F010BF92E70@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Czarnowska, Anna" <anna.czarnowska@intel.com>
List-Id: linux-raid.ids

From 68d46ad8e78838c14bc736af328b5c7ad87b7f34 Mon Sep 17 00:00:00 2001
From: Anna Czarnowska <anna.czarnowska@intel.com>
Date: Thu, 25 Nov 2010 11:11:06 +0100
Subject: [PATCH] Spare migration tests
Cc: linux-raid@vger.kernel.org, Williams, Dan J <dan.j.williams@intel.com>, Ciechanowski, Ed <ed.ciechanowski@intel.com>

This is a series of tests checking if mdadm Monitor migrates spares
according to rules in /etc/mdadm.conf defined by POLICY lines.

Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
signed-off-by: Marcin Labun <marcin.labun@intel.com>
---
 test                        |    1 +
 tests/11spare-migration     |  383 +++++++++++++++++++++++++++++++++++++++++++
 tests/env-11spare-migration |    9 +
 tests/utils                 |  192 ++++++++++++++++++++++
 4 files changed, 585 insertions(+), 0 deletions(-)
 create mode 100644 tests/11spare-migration
 create mode 100644 tests/env-11spare-migration
 create mode 100644 tests/utils

diff --git a/test b/test
index a31ad40..6c61146 100644
--- a/test
+++ b/test
@@ -54,6 +54,7 @@ cleanup() {
        for d in 0 1 2 3 4 5 6 7  8 9 10 11 12
        do
            losetup -d /dev/loop$d ; # rm -f $targetdir/mdtest$d
+          rm -f /dev/disk/by-path/loop*
         done
 }

diff --git a/tests/11spare-migration b/tests/11spare-migration
new file mode 100644
index 0000000..7f9f3d7
--- /dev/null
+++ b/tests/11spare-migration
@@ -0,0 +1,383 @@
+# Set of tests for autorebuild functionality using mdadm -F
+# To be able to test ddf one must have all loop devices of bigger size, with the ones
+# above number 7 bigger again by any amount (this is not changed for now as it
+# could affect other tests)
+
+. tests/utils
+set -ex
+verbose="yes"
+sleeptime=10
+
+# if listfailed=yes then don't exit if test failed due to wrong
+# spare-migration and just print a list at the end. Other errors still
+# stop the test.
+# if listfailed=no then exit on first failure
+listfailed="yes"
+
+# start Monitor, set monitorpid
+# uses global scan variable
+# all parameters are numbers of devices to be monitored. only used when $scan="no"
+# eg. monitor 0 1 will start monitoring of containers c0, c1 and subarrays v0, v1
+monitor(){
+       [ -z $monitorpid ] || return
+       if [ "$scan" == "yes" ]; then
+               $mdadm -F -d 1 --scan --mail root@localhost &
+               monitorpid=$!
+               return
+       fi
+       unset mddevs
+       while [ -n "$1" ]
+       do
+               eval container=\$c$1
+               eval volumes=\$v$1
+               mddevs="$mddevs /dev/$container"
+               if [ "$container" != "$volumes" ]; then
+                       for vol in $volumes; do
+                               mddevs="$mddevs /dev/$vol"
+                       done
+               fi
+               shift
+       done
+       if [ -n "$mddevs" ]; then
+               if [ "$verbose" != "yes" ]; then
+                       $mdadm -F -d 1 $mddevs >&2 &
+                       monitorpid=$!
+               else
+                       $mdadm -F -t -d 1 $mddevs &
+                       monitorpid=$!
+               fi
+       fi
+       [ "$verbose" != "yes" ] || echo $mddevs $monitorpid
+}
+
+test1()
+{
+dsc "Test 1: Common domain, add disk to one container and fail first one in another container, spare should be moved"
+setupdevs 0 0 1 $platform
+setupdevs 1 3 4 $platform
+# create config file with arrays and common domain
+createconfig a
+createconfig domain-$platform $platform spare 0 1 2 3 4
+monitor 0 1
+mdadm -a /dev/$c1 $dev2
+mdadm --fail /dev/$v0 $dev0
+# check that spare loop2 was moved from container c1 to container c0
+chksparemoved $c1 $c0 $dev2
+tidyup
+}
+
+test1a()
+{
+dsc "Test 1a: Common domain, add disk to one container and fail second one in another container, spare should be moved"
+setupdevs 0 0 1 $platform
+setupdevs 1 3 4 $platform
+createconfig a
+createconfig domain-$platform $platform spare 0 1 2 3 4
+monitor 0 1
+mdadm -a /dev/$c1 $dev2
+mdadm --fail /dev/$v0 $dev1
+# check that spare loop2 was moved from container c1 to container c0
+chksparemoved $c1 $c0 $dev2
+tidyup
+}
+
+test2()
+{
+dsc "Test 2: Common domain, fail disk in one container and add one to another container, spare should be moved"
+setupdevs 0 0 1 $platform
+setupdevs 1 3 4 $platform
+createconfig a
+createconfig domain-$platform $platform spare 0 1 2 3 4
+monitor 0 1
+mdadm --fail /dev/$v0 $dev1
+mdadm -a /dev/$c1 $dev2
+chksparemoved $c1 $c0 $dev2
+tidyup
+}
+
+test3()
+{
+dsc "Test 3: Two domains, fail a disk in one domain, add a disk to another domain, the spare should not be moved"
+setupdevs 0 0 1 $platform
+setupdevs 1 3 4 $platform
+# create config file with 2 domains
+createconfig a
+createconfig domain-$platform"1" $platform spare 0 1 2
+createconfig domain-$platform"2" $platform spare 3 4 5
+monitor 0 1
+mdadm --fail /dev/$v0 $dev1
+mdadm -a /dev/$c1 $dev5
+chksparemoved $c1 $c0 $dev5 n
+tidyup
+}
+
+test4()
+{
+dsc "Test 4: One domain holds one container, fail a disk in domain, and add disk to a container not described by domain, spare loop5 should not be moved"
+setupdevs 0 0 1 $platform
+setupdevs 1 3 4 $platform
+createconfig a
+createconfig domain-$platform $platform spare 0 1 2
+monitor 0 1
+mdadm --fail /dev/$v0 $dev1
+mdadm -a /dev/$c1 $dev5
+chksparemoved $c1 $c0 $dev5 n
+tidyup
+}
+
+test5()
+{
+dsc "Test 5: Two domains, two containers in each domain"
+setupdevs 0 0 1 $platform
+setupdevs 1 3 4 $platform
+setupdevs 2 5 6 $platform
+setupdevs 3 7 8 $platform
+# 2 and 9 for spares
+createconfig a
+createconfig domain-$platform"1" $platform spare 0 1 2 3 4
+createconfig domain-$platform"2" $platform spare 5 6 7 8 9
+monitor 0 1 2 3
+test5a
+test5b
+test5c
+tidyup
+}
+
+test5a()
+{
+dsc "Test 5a: Two containers in each domain, add spare loop2 to domain1 and fail disk in the other domain, the spare should not be moved"
+mdadm -a /dev/$c0 $dev2
+mdadm --fail /dev/$v2 $dev5
+chksparemoved $c0 $c2 $dev2 n
+}
+
+test5b()
+{
+dsc "Test 5b: Fail disk in the same domain but different container, spare loop2 should be moved"
+mdadm --fail /dev/$v1 $dev3
+chksparemoved $c0 $c1 $dev2
+}
+
+test5c()
+{
+dsc "Test 5c: Add spare loop9 to different container in domain with degraded array, spare should be moved"
+mdadm -a /dev/$c3 $dev9
+chksparemoved $c3 $c2 $dev9
+}
+
+test6()
+{
+dsc "Test 6: One domain has two containers, fail a disk in one container, there is a spare in other container too small to use for rebuild"
+setupdevs 0 0 1 $platform
+setupdevs 1 8 9 $platform
+# all devices in one domain
+createconfig a
+createconfig domain-$platform $platform spare 0 1 2 8 9
+monitor 0 1
+mdadm -a /dev/$c0 $dev2
+mdadm --fail /dev/$v1 $dev8
+chksparemoved $c0 $c1 $dev2 n
+tidyup
+}
+
+test7()
+{
+dsc "Test 7: One domain, add small spare to container, fail disk in array, spare not used, add suitable spare to other container, spare should be moved"
+setupdevs 0 0 1 $platform
+setupdevs 1 8 9 $platform
+createconfig a
+createconfig domain-$platform $platform spare 0 1 2 8 9 10
+monitor 0 1
+mdadm -a /dev/$c1 $dev2
+mdadm --fail /dev/$v1 $dev8
+mdadm -a /dev/$c0 $dev10
+chksparemoved $c0 $c1 $dev10
+tidyup
+}
+
+
+test7a()
+{
+dsc "Test 7a: Small spare in parent, suitable one in other container, $dev2 in $c1 is not in common domain"
+setupdevs 0 0 1 $platform
+setupdevs 1 8 9 $platform
+#all $platform devices in one domain
+createconfig a
+createconfig domain-$platform"1" $platform spare 0 1 8 9 10
+createconfig domain-$platform"2" $platform spare 2
+monitor 0 1
+mdadm -a /dev/$c1 $dev2
+chkspare $c1 $dev2
+mdadm --fail /dev/$v1 $dev8
+mdadm -a /dev/$c0 $dev10
+chksparemoved $c0 $c1 $dev10
+tidyup
+}
+
+test8()
+{
+# ddf does not have getinfo_super_disks implemented so skip this test
+return
+dsc "Test 8: imsm and ddf - spare should not be migrated"
+setupdevs 0 10 11 imsm
+setupdevs 1 8 9 ddf
+createconfig a
+createconfig domain0 noplatform spare 8 9 10 11 12
+monitor 0 1
+mdadm -a /dev/$c1 $dev12
+mdadm --fail /dev/$v0 $dev10
+chksparemoved $c1 $c0 $dev12 n
+tidyup
+}
+
+test9()
+{
+dsc "Test 9: imsm and native 1.2 - spare should not be shared"
+setupdevs 0 10 11 imsm
+setupdevs 1 8 9 1.2
+createconfig a
+createconfig domain0 noplatform spare 8 9 10 11 12
+monitor 0 1
+mdadm -a /dev/$c1 $dev12
+mdadm --fail /dev/$v0 $dev10
+chksparemoved $c1 $c0 $dev12 n
+tidyup
+}
+
+test10()
+{
+dsc "Test 10: Two arrays on the same devices in container"
+setupdevs 0 0 1 $platform 10000
+setupdevs 1 3 4 $platform
+createconfig a
+createconfig domain-$platform $platform spare 0 1 2 3 4 5
+monitor 0 1
+mdadm -a /dev/$c1 $dev2
+mdadm --fail /dev/md/sub0_ $dev0
+chksparemoved $c1 $c0 $dev2
+if [ $failed -eq 0 ]; then
+# now fail the spare and see if we get another one
+       mdadm --fail /dev/md/sub0_ $dev2
+       mdadm -a /dev/$c1 $dev5
+       chksparemoved $c1 $c0 $dev5
+fi
+tidyup
+}
+
+test11()
+{
+dsc "Test 11: Failed spare from other container should not be used"
+setupdevs 0 0 1 $platform
+setupdevs 1 3 4 $platform
+createconfig a
+createconfig domain-$platform $platform spare 0 1 2 3 4
+monitor 0 1
+mdadm -a /dev/$c1 $dev2
+mdadm --fail /dev/$v1 $dev3
+#wait until recovery finishes so no degraded array in c1
+check wait
+mdadm --fail /dev/$v0 $dev0
+chksparemoved $c1 $c0 $dev3 n
+tidyup
+}
+
+test12()
+{
+dsc "Test 12: Only one spare should be taken for rebuild, second not needed"
+setupdevs 0 0 1 $platform
+setupdevs 1 3 4 $platform
+createconfig a
+createconfig domain-$platform $platform spare 0 1 2 3 4 5
+monitor 0 1
+mdadm -a /dev/$c1 $dev2
+mdadm -a /dev/$c1 $dev5
+mdadm --fail /dev/$v0 $dev0
+sleep $sleeptime
+chkarray $dev2 n
+sc1=$c
+chkarray $dev5 n
+sc2=$c
+[ "$sc1" != "$sc2" ] || err "both spares in the same container $sc1"
+tidyup
+}
+
+test13()
+{
+dsc "Test 13: Common domain, two containers, fail a disk in container, action is below spare, the spare should not be moved"
+setupdevs 0 0 1 $platform
+setupdevs 1 4 5 $platform
+# same domain but different action on 4 5 6
+createconfig a
+createconfig domain-$platform $platform spare 0 1
+createconfig domain-$platform $platform include 4 5 6
+monitor 0 1
+mdadm -a /dev/$c1 $dev6
+mdadm --fail /dev/$v0 $dev0
+chksparemoved $c1 $c0 $d6 n
+tidyup
+}
+
+test14()
+{
+dsc "Test 14: One domain, small array on big disks, check if small spare is accepted"
+setupdevs 0 8 9 $platform 10000 1
+setupdevs 1 0 1 $platform
+createconfig a
+createconfig domain-$platform $platform spare 0 1 2 8 9
+monitor 0 1
+mdadm -a /dev/$c1 $dev2
+mdadm --fail /dev/$v0 $dev9
+chksparemoved $c1 $c0 $d2
+tidyup
+}
+
+try()
+{
+test1
+test1a
+test2
+test3
+test4
+test5
+test6
+if [ "$platform" != "1.2" ]; then
+# this is because we can't have a small spare added to native array
+    test7
+    test7a
+fi
+test8
+test9
+if [ "$platform" != "1.2" ]; then
+# we can't create two subarrays on the same devices for native (without
+# partitions)
+    test10
+fi
+test11
+test12
+test13
+test14
+}
+
+try_failed()
+{
+platform="1.2"
+scan="no"
+test5
+test9
+test13
+scan="yes"
+test9
+}
+
+#try_failed
+
+for scan in no yes; do
+       for platform in 1.2 imsm; do
+               try
+       done
+done
+
+[ $listfailed == "no" ] || [ -z $flist ] || echo -e "\n FAILED TESTS: $flist"
+
+#cat $targetdir/log
+rm -f /dev/disk/by-path/loop*
diff --git a/tests/env-11spare-migration b/tests/env-11spare-migration
new file mode 100644
index 0000000..851ae91
--- /dev/null
+++ b/tests/env-11spare-migration
@@ -0,0 +1,9 @@
+setup_env() {
+       export IMSM_DEVNAME_AS_SERIAL=1
+       export IMSM_TEST_OROM=1
+       }
+
+reset_env() {
+       unset IMSM_DEVNAME_AS_SERIAL
+       unset IMSM_TEST_OROM
+}
diff --git a/tests/utils b/tests/utils
new file mode 100644
index 0000000..f9e7977
--- /dev/null
+++ b/tests/utils
@@ -0,0 +1,192 @@
+# set of functions used to test policy framework with assemble, incremental and Monitor
+
+set +e
+#create links to be able to use domains
+for d in 0 1 2 3 4 5 6 7 8 9 10 11 12
+do
+       eval ln -s \$dev$d /dev/disk/by-path/loop$d
+       eval d$d="loop$d"
+       eval mdadm --zero-superblock \$dev$d
+done
+
+devices="/dev/loop[0-9] /dev/loop10 /dev/loop11 /dev/loop12"
+
+# on failure print out few things before exit
+# uses testdsc and platform global variables
+err(){
+       echo >&2 "ERROR: $*"
+       cat /etc/mdadm.conf >&2 || true
+       cat /proc/mdstat >&2
+       [ -z "$testdsc" ] || { echo >&2 $platform: $testdsc "- failed"; }
+       ps -e | grep mdadm >&2 || true
+       if [ $listfailed == "yes" ]; then
+               [ "$verbose" != "yes" ] || echo ---FAILED---
+               flist="$flist \n $platform $testdsc"
+               failed=1
+       else
+               exit 1
+       fi
+}
+
+# set test description
+dsc(){
+       failed=0
+       testdsc="$*"
+       [ "$verbose" != "yes" ] || echo $testdsc
+}
+
+killmonitor(){
+       [ -z "$monitorpid" ] || { kill -9 $monitorpid; unset monitorpid; }
+}
+
+tidyup(){
+       killmonitor
+       mdadm -Ss || true
+       mdadm -Ss
+       mdadm --zero-superblock $devices || true
+       udevadm settle
+       rm -f /etc/mdadm.conf
+}
+
+trap tidyup 0 1 2 3 15
+
+# create a RAID 1 array or container and subarray(s) on 2 disks
+# if platform not specified imsm is used
+# if subsize is given, first subarray is created with given size and second one on remaining space
+ccv(){
+       # mddevno used to name created array
+       local mddevno="$1"
+       # numbers of devices to be used in array
+       local devno1="$2"
+       local devno2="$3"
+       local platform="$4"
+       local subsize="$5"
+       local onearray="$6"
+       [ -n "$platform" ] || platform="imsm"
+       if [ "$platform" == "imsm" ] || [ "$platform" == "ddf" ]; then
+               eval mdadm -CR /dev/md/con$mddevno -e $platform -n 2 \$dev$devno1 \$dev$devno2
+               udevadm settle
+               [ -z "$subsize" ] || eval mdadm -CR sub$mddevno"_" -l 1 -n 2 /dev/md/con$mddevno -z $subsize
+               [ -n "$onearray" ] || eval mdadm -CR sub$mddevno -l 1 -n 2 /dev/md/con$mddevno
+       else
+               [ -z "$subsize" ] || sizepar="-z $subsize"
+               eval mdadm -CR arr$mddevno -e $platform -l 1 -n 2 \$dev$devno1 \$dev$devno2 $sizepar
+               unset sizepar
+       fi
+}
+
+# get container and subarray using given device from mdstat
+# sets global variables c and v
+getarray(){
+       local devname=`basename $1`
+       local platformtype=`grep -A 1 $devname /proc/mdstat | awk '/active/ {getline; print $4 }' | awk -F ":" 'END {print $1}'`
+       c=`grep "inactive.*$devname" /proc/mdstat | awk -F " " '{print $1}'`
+       v=`grep " active.*$devname" /proc/mdstat | awk -F " " '{print $1}'`
+       [ "$platformtype" == "external" ] || c=$v
+}
+
+# check if given device belongs to any container and subarray
+# if $2 given then only container checked
+chkarray(){
+       local devname="$1"
+       local subcheck="$2"
+       getarray $devname
+       [ -n "$c" ] || err "$devname not in any container"
+       [ -n "$subcheck" ] || [ -n "$v" ] || err " $devname not in subarray"
+}
+
+# test if two devices in the same container/subarray
+# $1 $2 - devices
+# $3 don't check subarrays, only containers
+tst(){
+       local device1=`basename $1`
+       local device2=`basename $2`
+       local subcheck="$3"
+       chkarray $device1 $subcheck
+       local x="$c"
+       local y="$v"
+       chkarray $device2 $subcheck
+       [ "$c" == "$x" ] || err "$device1 and $device2 not in the same container"
+       [ -n "$subcheck" ] || [ "$v" == "$y" ] || err "$device1 and $device2 not in the same subarray"
+}
+
+# same as tst, just use numbers of devices instead of names as parameters
+dtst(){
+       local devno1="$1"
+       local devno2="$2"
+       local subcheck="$3"
+       eval tst \$dev$devno1 \$dev$devno2 $subcheck
+}
+
+# create containers/subarrays, check if created properly,
+# set global variables c$mddevno v$mddevno, usually c0=md127, v0=md126 , etc.
+setupdevs(){
+       local mddevno="$1"
+       local devno1="$2"
+       local devno2="$3"
+       local p="$4"
+       local subsize="$5"
+       local onearray="$6"
+       [ -n "$p" ] || p=$platform
+       ccv $mddevno $devno1 $devno2 $p $subsize $onearray
+       dtst $devno1 $devno2
+       eval c$mddevno=\"$c\"
+       eval v$mddevno=\"$v\"
+}
+
+# check if given spare in container
+# usage: chkspare container spare [n]  (n if spare shouldn't be in container)
+chkspare(){
+       local container=`basename $1`
+       local spare=$2
+       local expected=$3
+       getarray $spare
+       [ -n "$expected" ] || expected="y"
+       if [ "$expected" == "y" ]; then
+               [ "$c" == "$container" ] || err "$spare not in container $container"
+       else
+               [ "$c" != "$container" ] || err "$spare in container $container"
+       fi
+}
+
+#check if spare was moved from one container to another
+# args: from_container to_container spare [yn]
+# n when spare should remain in original container
+chksparemoved(){
+       sleep $sleeptime
+       from_container="$1"
+       to_container="$2"
+       spare="$3"
+       expected="$4"
+       [ -n "$expected" ] || expected="y"
+       notexpected="n"; [ "$expected" == "y" ] || notexpected="y"
+       chkspare $from_container $spare $notexpected
+       [ $failed -eq 1 ] || chkspare $to_container $spare $expected
+}
+
+
+# for domains defined through policy
+createconfig(){
+conf=/etc/mdadm.conf
+if [ "$1" != "a" ]; then
+{
+       domain=$1
+       metadata=$2
+       action=$3
+       while [ -n "$4" ]; do
+               echo="policy domain=$domain"
+               [ "$metadata" == "noplatform" ] ||  echo="$echo metadata=$metadata"
+               echo="$echo path=loop$4"
+               echo="$echo action=$action"
+               echo "$echo"
+               shift
+       done
+} >> $conf
+else
+{
+       echo "DEVICES $devlist /dev/md1*"
+       mdadm -Ebs
+} >  $conf
+fi
+#[ "$verbose" != "yes" ] || cat /etc/mdadm.conf | grep policy || true
+}
--
1.7.1

---------------------------------------------------------------------
Intel Technology Poland sp. z o.o.
z siedziba w Gdansku
ul. Slowackiego 173
80-298 Gdansk

Sad Rejonowy Gdansk Polnoc w Gdansku, 
VII Wydzial Gospodarczy Krajowego Rejestru Sadowego, 
numer KRS 101882

NIP 957-07-52-316
Kapital zakladowy 200.000 zl

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

