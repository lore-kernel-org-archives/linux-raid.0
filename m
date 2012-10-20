From: Gilles Espinasse <g.esp@free.fr>
Subject: [PATCH 1/3] Align FAILED to test name to be parsable
Date: Sat, 20 Oct 2012 18:03:22 +0200
Message-ID: <1350749002-5445-1-git-send-email-g.esp@free.fr>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, neilb@suse.de
Cc: Gilles Espinasse <g.esp@free.fr>
List-Id: linux-raid.ids

Signed-off-by: Gilles Espinasse <g.esp@free.fr>

So 'grep FAILED log' is now meaningfull.
Let both stdout and sderr be displayed after a failed test
---
 test |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/test b/test
index 9340afe..2bb482c 100755
--- a/test
+++ b/test
@@ -222,12 +222,13 @@ do_test() {
     # source script in a subshell, so it has access to our
     # namespace, but cannot change it.
     echo -ne "$_script... "
-    if ( set -ex ; . $_script )  2> $targetdir/log
+    if ( set -ex ; . $_script ) &> $targetdir/log
     then
       echo "succeeded"
       _fail=0
     else
-      echo "FAILED - see $targetdir/log for details"
+      echo "FAILED"
+      cat $targetdir/log
       _fail=1
     fi
     if [ "$savelogs" == "1" ]; then
-- 
1.7.2.5

