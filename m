From: Jes.Sorensen@redhat.com
Subject: [PATCH 4/4] Move setup code to a function and introduce matching cleanup argument
Date: Fri, 25 May 2012 17:24:08 +0200
Message-ID: <1337959448-5299-5-git-send-email-Jes.Sorensen@redhat.com>
References: <1337959448-5299-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1337959448-5299-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: dledford@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 test |   60 +++++++++++++++++++++++++++++++++++-------------------------
 1 files changed, 35 insertions(+), 25 deletions(-)

diff --git a/test b/test
index 8e06ae2..9532ea7 100755
--- a/test
+++ b/test
@@ -68,33 +68,35 @@ cleanup() {
 	done
 }
 
-trap cleanup 0 1 2 3 15
+do_setup() {
+  trap cleanup 0 1 2 3 15
 
-devlist=
-for d in 0 1 2 3 4 5 6 7 8 9 10 11 12
-do
-   sz=$size
-   if [ $d -gt 7 ]; then sz=$ddfsize ; fi
-   [ -f $targetdir/mdtest$d ] || dd if=/dev/zero of=$targetdir/mdtest$d count=$sz bs=1K > /dev/null 2>&1
-   [ -b /dev/loop$d ] || mknod /dev/loop$d b 7 $d
-   if [ $d -eq 7 ]
-   then
-     losetup /dev/loop$d $targetdir/mdtest6 # for multipath use
-   else
-     losetup /dev/loop$d $targetdir/mdtest$d
-   fi
-   eval dev$d=/dev/loop$d
-   eval file$d=$targetdir/mdtest$d
-   eval devlist=\"\$devlist \$dev$d\"
+  devlist=
+  for d in 0 1 2 3 4 5 6 7 8 9 10 11 12
+  do
+    sz=$size
+    if [ $d -gt 7 ]; then sz=$ddfsize ; fi
+    [ -f $targetdir/mdtest$d ] || dd if=/dev/zero of=$targetdir/mdtest$d count=$sz bs=1K > /dev/null 2>&1
+    [ -b /dev/loop$d ] || mknod /dev/loop$d b 7 $d
+    if [ $d -eq 7 ]
+    then
+      losetup /dev/loop$d $targetdir/mdtest6 # for multipath use
+    else
+      losetup /dev/loop$d $targetdir/mdtest$d
+    fi
+    eval dev$d=/dev/loop$d
+    eval file$d=$targetdir/mdtest$d
+    eval devlist=\"\$devlist \$dev$d\"
    #" <-- add this quote to un-confuse vim syntax highlighting
-done
-path0=$dev6
-path1=$dev7
+  done
+  path0=$dev6
+  path1=$dev7
 
-ulimit -c unlimited
-[ -f /proc/mdstat ] || modprobe md_mod
-echo 2000 > /proc/sys/dev/raid/speed_limit_max
-echo 0 > /sys/module/md_mod/parameters/start_ro
+  ulimit -c unlimited
+  [ -f /proc/mdstat ] || modprobe md_mod
+  echo 2000 > /proc/sys/dev/raid/speed_limit_max
+  echo 0 > /sys/module/md_mod/parameters/start_ro
+}
 
 # mdadm always adds --quiet, and we want to see any unexpected messages
 mdadm() {
@@ -231,7 +233,7 @@ do_test() {
     if [ "$savelogs" == "1" ]; then
       cp $targetdir/log $logdir/$_basename.log
     fi
-    if [ "$_fail" == "1" -a $"exitonerror" == "1" ]; then
+    if [ "$_fail" == "1" -a "$exitonerror" == "1" ]; then
       exit 1
     fi
   fi
@@ -246,6 +248,7 @@ do_help() {
   echo "    --save-logs                 Save all logs in <logdir>"
   echo "    --no-error                  Don't stop on error, ie. run all tests"
   echo "    setup                       Setup test environment and exit"
+  echo "    cleanup                     Cleanup test environment"
   echo "    <prefix>                    Run tests with <prefix>"
 }
 
@@ -258,8 +261,13 @@ parse_args() {
       ;;
     setup)
       echo "mdadm test environment setup"
+      do_setup
       trap 0; exit 0
       ;;
+    cleanup)
+      cleanup
+      exit 0
+      ;;
     --tests=*)
       TESTLIST=`expr "x$i" : 'x[^=]*=\(.*\)' | sed -e 's/,/ /g'`
       ;;
@@ -296,6 +304,8 @@ done
 
 parse_args $@
 
+do_setup
+
 if [ "$savelogs" == "1" ]; then
   echo "Saving logs to $logdir"
 fi
-- 
1.7.1

