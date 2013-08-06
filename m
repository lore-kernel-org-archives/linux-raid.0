From: mwilck@arcor.de
Subject: [PATCH 6/9] tests/10ddf-fail-spare: more sophisticated result checks
Date: Tue,  6 Aug 2013 23:38:00 +0200
Message-ID: <1375825083-7856-2-git-send-email-mwilck@arcor.de>
References: <52016A06.8070400@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52016A06.8070400@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

This test can succeed two ways, depending on timing.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 tests/10ddf-fail-spare |   83 ++++++++++++++++++++++++++++++++++++++----------
 1 files changed, 66 insertions(+), 17 deletions(-)

diff --git a/tests/10ddf-fail-spare b/tests/10ddf-fail-spare
index 60e8110..262fda4 100644
--- a/tests/10ddf-fail-spare
+++ b/tests/10ddf-fail-spare
@@ -1,37 +1,86 @@
-# sanity check array creation
+# Test suggested by Albert Pauw: Create, fail one disk, have mdmon
+# activate the spare,
+# then run create again. Shouldn't use the failed disk for Create,
 . tests/env-ddf-template
 
+tmp=$(mktemp /tmp/mdtest-XXXXXX)
+rm -f $tmp
+
 mdadm --zero-superblock $dev8 $dev9 $dev10 $dev11 $dev12 $dev13
 mdadm -CR $container -e ddf -l container -n 5 $dev8 $dev9 $dev10 $dev11 $dev12
 
-mdadm -CR $member0 -l raid1 -n 2 $container >/tmp/mdmon.txt 2>&1
+mdadm -CR $member0 -l raid1 -n 2 $container
 #$dir/mdadm -CR $member0 -l raid1 -n 2 $container >/tmp/mdmon.txt 2>&1
 
 check wait
 
 set -- $(get_raiddisks $member0)
 fail0=$1
-mdadm -f $member0 $fail0
+mdadm --fail $member0 $fail0
 
-# need to sleep shortly here, to give monitor some time to active the spare
-sleep 0.5
+# To make sure the spare is activated, we may have to sleep
+# 2s has always been enough for me
+sleep 2
 check wait
 
+# This test can succeed both ways - if spare was activated
+# before new array was created, we see only member 0.
+# otherwise, we see both, adn member0 is degraded because the
+# new array grabbed the spare
+# which case occurs depends on the sleep time above.
+ret=0
 if mdadm -CR $member1 -l raid5 -n 3 $container; then
-   echo error: create should have failed
-   set -- $(get_raiddisks $member0)
-   d0=$1
+   # Creation successful - must have been quicker than spare activation
+    
+   check wait
    set -- $(get_raiddisks $member1)
+   if [ $1 = $fail0 -o $2 = $fail0 -o $3 = $fail0 ]; then
+       echo ERROR: $member1 must not contain $fail0: $@
+       ret=1
+   fi
    d1=$1
-   cat /proc/mdstat
-   mdadm -E $d0
-   mdadm -E $d1
-   mdadm -E $fail0
-   rv=1
-#   cat /tmp/mdmon.txt
+   mdadm -E $d1 >$tmp
+   if ! grep -q 'state\[1\] : Optimal, Consistent' $tmp; then
+       echo ERROR: member 1 should be optimal in meta data
+       ret=1
+   fi
+   state0=Degraded
 else
-   rv=0
+   # Creation unsuccessful - spare was used for member 0
+   state0=Optimal
+fi
+
+# need to delay a little bit, sometimes the meta data aren't
+# up-to-date yet
+sleep 0.5
+set -- $(get_raiddisks $member0)
+if [ $1 = $fail0 -o $2 = $fail0 ]; then
+    echo ERROR: $member0 must not contain $fail0: $@
+    ret=1
 fi
+d0=$1
+
+[ -f $tmp ] || mdadm -E $d0 >$tmp
+
+if ! grep -q 'state\[0\] : '$state0', Consistent' $tmp; then
+    echo ERROR: member 0 should be $state0 in meta data
+    ret=1
+fi
+if ! grep -q 'Offline, Failed' $tmp; then
+    echo ERROR: Failed disk expected in meta data
+    ret=1
+fi
+if [ $ret -eq 1 ]; then
+    cat /proc/mdstat
+    mdadm -E $d0
+    mdadm -E $d1
+    mdadm -E $fail0
+fi
+
+[ -f /tmp/mdmon.txt ] && {
+    cat /tmp/mdmon.txt
+    rm -f /tmp/mdmon.txt
+}
 
-#  rm -f /tmp/mdmon.txt
-exit $rv
+rm -f $tmp
+[ $ret -eq 0 ]
-- 
1.7.1
