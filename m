From: Jes.Sorensen@redhat.com
Subject: [PATCH 1/4] Add support for saving log files in test script
Date: Fri, 25 May 2012 17:24:05 +0200
Message-ID: <1337959448-5299-2-git-send-email-Jes.Sorensen@redhat.com>
References: <1337959448-5299-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1337959448-5299-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: dledford@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

--logdir= specifies where to save, if different from default, and
--save-logs tells test to save all log files.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 test |   42 ++++++++++++++++++++++++++++++++++++------
 1 files changed, 36 insertions(+), 6 deletions(-)

diff --git a/test b/test
index 7882586..c7eb069 100755
--- a/test
+++ b/test
@@ -16,6 +16,10 @@ then
    echo >&2 "test: $mdadm isn't usable."
 fi
 
+testdir="tests"
+logdir="$testdir/logs"
+logsave=0
+
 # Check whether to run multipath tests
 modprobe multipath 2> /dev/null
 if grep -s 'Personalities : .*multipath' > /dev/null /proc/mdstat ; then
@@ -204,6 +208,7 @@ rotest() {
 
 do_test() {
   _script=$1
+  _basename=`basename $_script`
   if [ -f "$_script" ]
   then
     rm -f $targetdir/stderr
@@ -215,8 +220,17 @@ do_test() {
     # namespace, but cannot change it.
     echo -ne "$_script... "
     if ( set -ex ; . $_script )  2> $targetdir/log
-    then echo "succeeded"
-    else echo "FAILED - see $targetdir/log for details"
+    then
+      echo "succeeded"
+      _fail=0
+    else
+      echo "FAILED - see $targetdir/log for details"
+      _fail=1
+    fi
+    if [ "$savelogs" == "1" ]; then
+      cp $targetdir/log $logdir/$_basename.log
+    fi
+    if [ "$_fail" == "1" ]; then
       exit 1
     fi
   fi
@@ -224,7 +238,7 @@ do_test() {
 
 do_help() {
   echo "Usage: "
-  echo " $0 [--tests=<test1,test2,..>] [--disable-multipath] [setup] [prefix]"
+  echo " $0 [--tests=<test1,test2,..>] [--disable-multipath] [--logdir] [--save-logs] [setup] [prefix]"
 }
 
 parse_args() {
@@ -241,6 +255,18 @@ parse_args() {
     --tests=*)
       TESTLIST=`expr "x$i" : 'x[^=]*=\(.*\)' | sed -e 's/,/ /g'`
       ;;
+    --logdir=*)
+      logdir=`expr "x$i" : 'x[^=]*=\(.*\)'`
+      ;;
+    --save-logs)
+      savelogs=1
+      if [ ! -d $logdir ] ; then
+        mkdir $logdir
+        if [ $? -ne 0 ] ; then
+	  exit 1;
+	fi
+      fi
+      ;;
     --disable-multipath)
       unset MULTIPATH
       ;;
@@ -259,13 +285,17 @@ done
 
 parse_args $@
 
+if [ "$savelogs" == "1" ]; then
+  echo "Saving logs to $logdir"
+fi
+
 if [ "x$TESTLIST" != "x" ]; then
-  for script in $TESTLIST
+  for script in $testdir/$TESTLIST
   do
-    do_test tests/$script
+    do_test $script
   done
 else
-  for script in tests/$prefix tests/$prefix*[^~]
+  for script in $testdir/$prefix $testdir/$prefix*[^~]
   do
     do_test $script
   done
-- 
1.7.1

