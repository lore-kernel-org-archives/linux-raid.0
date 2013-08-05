From: mwilck@arcor.de
Subject: [PATCH 5/5] test: allow LVM volumes or RAM disks as test devices
Date: Mon,  5 Aug 2013 22:37:51 +0200
Message-ID: <1375735071-9160-5-git-send-email-mwilck@arcor.de>
References: <1375735071-9160-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1375735071-9160-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

Allow other device types for testing; this allows to test on
a larger variety of devices.

Option --dev=[loop|lvm|ram] selects loop device (default), lvm,
and ram disk, respecively. To use RAM disks with DDF,
the kernel parameter ramdisk_size=65536 must be used.
For LVM, use --volgroup=<vg> to specify the name of the volume
group in which the test LVs will be created.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 test |   69 +++++++++++++++++++++++++++++++++++++++++++++++++++++------------
 1 files changed, 56 insertions(+), 13 deletions(-)

diff --git a/test b/test
index 8e8d1df..1e89788 100755
--- a/test
+++ b/test
@@ -29,6 +29,8 @@ if grep -s 'Personalities : .*multipath' > /dev/null /proc/mdstat ; then
     MULTIPATH="yes"
 fi
 INTEGRITY=yes
+DEVTYPE=loop
+LVM_VOLGROUP=mdtest
 
 # make sure to test local mdmon, not system one
 export MDADM_NO_SYSTEMCTL=1
@@ -67,11 +69,21 @@ config=/tmp/mdadm.conf
 cleanup() {
 	udevadm settle
 	$mdadm -Ssq 2> /dev/null
-	for d in 0 1 2 3 4 5 6 7  8 9 10 11 12 13
-	do
+        case $DEVTYPE in
+        loop)	
+	  for d in 0 1 2 3 4 5 6 7  8 9 10 11 12 13
+	  do
 	    losetup -d /dev/loop$d ; # rm -f $targetdir/mdtest$d
 	    rm -f /dev/disk/by-path/loop*
-	done
+	  done
+          ;;
+        lvm)
+	  for d in 0 1 2 3 4 5 6 7  8 9 10 11 12 13
+	  do
+	    eval "lvremove --quiet -f \$dev$d"
+	  done
+          ;;
+        esac
 }
 
 ctrl_c() {
@@ -87,16 +99,33 @@ do_setup() {
   do
     sz=$size
     if [ $d -gt 7 ]; then sz=$ddfsize ; fi
-    [ -f $targetdir/mdtest$d ] || dd if=/dev/zero of=$targetdir/mdtest$d count=$sz bs=1K > /dev/null 2>&1
-    [ -b /dev/loop$d ] || mknod /dev/loop$d b 7 $d
-    if [ $d -eq 7 ]
-    then
-      losetup /dev/loop$d $targetdir/mdtest6 # for multipath use
-    else
-      losetup /dev/loop$d $targetdir/mdtest$d
-    fi
-    eval dev$d=/dev/loop$d
-    eval file$d=$targetdir/mdtest$d
+    case $DEVTYPE in
+    loop)	
+      [ -f $targetdir/mdtest$d ] || dd if=/dev/zero of=$targetdir/mdtest$d count=$sz bs=1K > /dev/null 2>&1
+      [ -b /dev/loop$d ] || mknod /dev/loop$d b 7 $d
+      if [ $d -eq 7 ]
+      then
+        losetup /dev/loop$d $targetdir/mdtest6 # for multipath use
+      else
+        losetup /dev/loop$d $targetdir/mdtest$d
+      fi
+      eval dev$d=/dev/loop$d
+      eval file$d=$targetdir/mdtest$d
+      ;;
+    lvm)
+      unset MULTIPATH
+      eval dev$d=/dev/mapper/${LVM_VOLGROUP}-mdtest$d
+      if ! lvcreate --quiet -L ${sz}K -n mdtest$d $LVM_VOLGROUP; then
+	  trap '' 0 # make sure lvremove is not called
+	  eval echo error creating \$dev$d
+	  exit 129
+      fi
+      ;;
+    ram)
+      unset MULTIPATH
+      eval dev$d=/dev/ram$d
+      ;;
+    esac
     eval devlist=\"\$devlist \$dev$d\"
     eval devlist$d=\"\$devlist\"
    #" <-- add this quote to un-confuse vim syntax highlighting
@@ -279,6 +308,8 @@ do_help() {
   echo "    --logdir=<directory>        Directory to save logfiles in"
   echo "    --save-logs                 Save all logs in <logdir>"
   echo "    --keep-going                Don't stop on error, ie. run all tests"
+  echo "    --dev=[loop|lvm|ram]        Use loop devices (default), LVM, or RAM disk"
+  echo "    --volgroup=<name>           LVM volume group for LVM test"
   echo "    setup                       Setup test environment and exit"
   echo "    cleanup                     Cleanup test environment"
   echo "    <prefix>                    Run tests with <prefix>"
@@ -324,6 +355,18 @@ parse_args() {
     --disable-integrity)
       unset INTEGRITY
       ;;
+    --dev=loop)
+      DEVTYPE=loop
+      ;;
+    --dev=lvm)
+      DEVTYPE=lvm
+      ;;
+    --dev=ram)
+      DEVTYPE=ram
+      ;;
+    --volgroup=*)
+      LVM_VOLGROUP=`expr "x$i" : 'x[^=]*=\(.*\)'`
+      ;;
     --help)
       do_help
       exit 0;
-- 
1.7.1
