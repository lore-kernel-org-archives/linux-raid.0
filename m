From: Jes.Sorensen@redhat.com
Subject: [PATCH 2/4] Add --no-error argument to 'test'
Date: Fri, 25 May 2012 17:24:06 +0200
Message-ID: <1337959448-5299-3-git-send-email-Jes.Sorensen@redhat.com>
References: <1337959448-5299-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1337959448-5299-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: dledford@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This allows the test suite to run to completion even if one test
fails.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 test |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/test b/test
index c7eb069..a0561ab 100755
--- a/test
+++ b/test
@@ -19,6 +19,7 @@ fi
 testdir="tests"
 logdir="$testdir/logs"
 logsave=0
+exitonerror=1
 
 # Check whether to run multipath tests
 modprobe multipath 2> /dev/null
@@ -230,7 +231,7 @@ do_test() {
     if [ "$savelogs" == "1" ]; then
       cp $targetdir/log $logdir/$_basename.log
     fi
-    if [ "$_fail" == "1" ]; then
+    if [ "$_fail" == "1" -a $"exitonerror" == "1" ]; then
       exit 1
     fi
   fi
@@ -238,7 +239,7 @@ do_test() {
 
 do_help() {
   echo "Usage: "
-  echo " $0 [--tests=<test1,test2,..>] [--disable-multipath] [--logdir] [--save-logs] [setup] [prefix]"
+  echo " $0 [--tests=<test1,test2,..>] [--disable-multipath] [--logdir] [--save-logs] [--no-error] [setup] [prefix]"
 }
 
 parse_args() {
@@ -267,6 +268,9 @@ parse_args() {
 	fi
       fi
       ;;
+    --no-error)
+      exit_on_error=0
+      ;;
     --disable-multipath)
       unset MULTIPATH
       ;;
-- 
1.7.1

