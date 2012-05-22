From: Jes.Sorensen@redhat.com
Subject: [PATCH 2/2] Add command line argument parsing to 'test' sript
Date: Tue, 22 May 2012 18:55:30 +0200
Message-ID: <1337705730-7335-3-git-send-email-Jes.Sorensen@redhat.com>
References: <1337705730-7335-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1337705730-7335-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This adds more generic command line argument parsing to the test
script. It also introduces a couple of new options, while preserving
the old '<prefix>' and 'setup' arguments. The new options are
--disable-multipath and --tests=<test1>,<test2>,...

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 test |   88 ++++++++++++++++++++++++++++++++++++++++++++++++-----------------
 1 files changed, 65 insertions(+), 23 deletions(-)

diff --git a/test b/test
index 0679983..9428b20 100755
--- a/test
+++ b/test
@@ -8,9 +8,6 @@ then echo >&2 "test: testing can only be done as 'root'."
 fi
 
 prefix='[0-9][0-9]'
-if [ -n "$1" ]
-then prefix=$1
-fi
 
 dir=`pwd`
 mdadm=$dir/mdadm
@@ -94,10 +91,6 @@ ulimit -c unlimited
 echo 2000 > /proc/sys/dev/raid/speed_limit_max
 echo 0 > /sys/module/md_mod/parameters/start_ro
 
-if [ " $1" = " setup" ]
-then trap 0 ; exit 0
-fi
-
 # mdadm always adds --quiet, and we want to see any unexpected messages
 mdadm() {
     rm -f $targetdir/stderr
@@ -209,23 +202,72 @@ rotest() {
   fsck -fn $dev >&2
 }
 
-for script in tests/$prefix tests/$prefix*[^~]
-do
-  if [ -f "$script" ]
+do_test() {
+  _script=$1
+  if [ -f "$_script" ]
   then
-   rm -f $targetdir/stderr
-   # stop all arrays, just incase some script left an array active.
-   $mdadm -Ssq 2> /dev/null
-   mdadm --zero $devlist 2> /dev/null
-   mdadm --zero $devlist 2> /dev/null
-   # source script in a subshell, so it has access to our
-   # namespace, but cannot change it.
-   echo -ne "$script... "
-   if ( set -ex ; . $script )  2> $targetdir/log
-   then echo "succeeded"
-   else echo "FAILED - see $targetdir/log for details"
-       exit 1
-   fi
+    rm -f $targetdir/stderr
+    # stop all arrays, just incase some script left an array active.
+    $mdadm -Ssq 2> /dev/null
+    mdadm --zero $devlist 2> /dev/null
+    mdadm --zero $devlist 2> /dev/null
+    # source script in a subshell, so it has access to our
+    # namespace, but cannot change it.
+    echo -ne "$_script... "
+    if ( set -ex ; . $_script )  2> $targetdir/log
+    then echo "succeeded"
+    else echo "FAILED - see $targetdir/log for details"
+      exit 1
+    fi
   fi
+}
+
+do_help() {
+  echo "Usage: "
+  echo " $0 [--tests=<test1,test2,..>] [--disable-multipath] [setup] [prefix]"
+}
+
+parse_args() {
+  for i in $*
+  do
+    case $i in
+    [0-9][0-9])
+      prefix=$i
+      ;;      
+    setup)
+      echo "mdadm test environment setup"
+      trap 0; exit 0
+      ;;
+    --tests=*)
+      TESTLIST=`expr "x$i" : 'x[^=]*=\(.*\)' | sed -e 's/,/ /g'`
+      ;;
+    --disable-multipath)
+      unset MULTIPATH
+      ;;
+    --help)
+      do_help
+      exit 0;
+      ;;
+    -*)
+      echo " $0: Unknown argument: $i"
+      do_help
+      exit 0;
+      ;;
+    esac
 done
+}
+
+parse_args $@
+
+if [ "x$TESTLIST" != "x" ]; then
+  for script in $TESTLIST
+  do
+    do_test tests/$script
+  done
+else
+  for script in tests/$prefix tests/$prefix*[^~]
+  do
+    do_test $script
+  done
+fi
 exit 0
-- 
1.7.7.6

