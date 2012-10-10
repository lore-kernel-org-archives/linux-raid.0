From: Gilles Espinasse <g.esp@free.fr>
Subject: [PATCH] Fix tests sh too many arguments warnings
Date: Wed, 10 Oct 2012 13:38:15 +0200
Message-ID: <1349869095-26167-1-git-send-email-g.esp@free.fr>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, neilb@suse.de
Cc: Gilles Espinasse <g.esp@free.fr>
List-Id: linux-raid.ids

Signed-off-by: Gilles Espinasse <g.esp@free.fr>

Add quotes on if [ $sum != $sum1 ]
Fix 2 typo /sh1sum/sha1sum/ /matc /match /
---
 tests/01r5integ    |    6 +++---
 tests/01raid6integ |   10 +++++-----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/tests/01r5integ b/tests/01r5integ
index 714a57f..97a71f3 100644
--- a/tests/01r5integ
+++ b/tests/01r5integ
@@ -1,7 +1,7 @@
 
 # Check integrity of raid5 in degraded mode
 # Create a 4 disk raid5, create a filesystem and
-# sh1sum it with each device failed
+# sha1sum it with each device failed
 
 for layout in ls rs la ra
 do
@@ -16,9 +16,9 @@ do
     mdadm $md0 -r $i
     blockdev --flushbufs $md0
     sum1=`sha1sum $md0`
-    if [ $sum != $sum1 ]
+    if [ "$sum" != "$sum1" ]
     then
-     echo $sum does not matc $sum1 with $i missing
+     echo $sum does not match $sum1 with $i missing
      exit 1
     fi
     mdadm $md0 -a $i
diff --git a/tests/01raid6integ b/tests/01raid6integ
index 245b0da..7123e2b 100644
--- a/tests/01raid6integ
+++ b/tests/01raid6integ
@@ -1,7 +1,7 @@
 
 # Check integrity of raid6 in degraded modes
 # Create a 5 disk raid6, dump some data to it, then
-# sh1sum it with different pairs of devices failed
+# sha1sum it with different pairs of devices failed
 
 layouts='ls rs la ra'
 lv=`uname -r`
@@ -25,9 +25,9 @@ do
     mdadm $md0 -r $second
     blockdev --flushbufs $md0
     sum1=`sha1sum $md0`
-    if [ $sum != $sum1 ]
+    if [ "$sum" != "$sum1" ]
     then
-      echo $sum does not matc $sum1 with $second missing
+      echo $sum does not match $sum1 with $second missing
       exit 1
     fi
     for first in $totest
@@ -36,9 +36,9 @@ do
        mdadm $md0 -r $first
        blockdev --flushbufs $md0
        sum1=`sha1sum $md0`
-       if [ $sum != $sum1 ]
+       if [ "$sum" != "$sum1" ]
        then
-         echo $sum does not matc $sum1 with $first and $second missing
+         echo $sum does not match $sum1 with $first and $second missing
          exit 1
        fi
        mdadm $md0 -a $first
-- 
1.7.2.5

