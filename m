From: mwilck@arcor.de
Subject: [PATCH 7/9] tests/10ddf-fail-create-race: test handling of fail/create race
Date: Tue,  6 Aug 2013 23:38:01 +0200
Message-ID: <1375825083-7856-3-git-send-email-mwilck@arcor.de>
References: <52016A06.8070400@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52016A06.8070400@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

If a disk fails and simulaneously a new array is created, a race
condition may arise because the meta data on disk doesn't reflect
the disk failure yet. This is a test for that case.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 tests/10ddf-fail-create-race |   66 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 66 insertions(+), 0 deletions(-)
 create mode 100644 tests/10ddf-fail-create-race

diff --git a/tests/10ddf-fail-create-race b/tests/10ddf-fail-create-race
new file mode 100644
index 0000000..505636c
--- /dev/null
+++ b/tests/10ddf-fail-create-race
@@ -0,0 +1,66 @@
+# This test creates a RAID1, fails a disk, and immediately
+# (simultaneously) creates a new array. This tests for a possible
+# race where the meta data reflecting the disk failure may not
+# be written when the 2nd array is created.
+. tests/env-ddf-template
+
+mdadm --zero-superblock $dev8 $dev9 $dev10 $dev11 $dev12 $dev13
+
+mdadm -CR $container -e ddf -l container -n 2 $dev11 $dev12
+#$dir/mdadm -CR $member0 -l raid1 -n 2 $container -z 10000  >/tmp/mdmon.txt 2>&1
+mdadm -CR $member0 -l raid1 -n 2 $container -z 10000
+check wait
+fail0=$dev11
+mdadm --fail $member0 $fail0 &
+
+# The test can succeed two ways: 
+# 1) mdadm -C member1 fails - in this case the meta data
+# was already on disk when the create attempt was made
+# 2) mdadm -C succeeds in the first place (meta data not on disk yet),
+# but mdmon detects the problem and sets the disk faulty.
+
+if mdadm -CR $member1 -l raid1 -n 2 $container; then
+
+   echo create should have failed / race condition?
+   
+   check wait
+   set -- $(get_raiddisks $member0)
+   d0=$1
+   ret=0
+   if [ $1 = $fail0 -o $2 = $fail0 ]; then
+       ret=1
+   else 
+       set -- $(get_raiddisks $member1)
+       if [ $1 = $fail0 -o $2 = $fail0 ]; then
+	   ret=1
+       fi
+   fi
+   if [ $ret -eq 1 ]; then
+       echo ERROR: failed disk $fail0 is still a RAID member
+       echo $member0: $(get_raiddisks $member0)
+       echo $member1: $(get_raiddisks $member1)
+   fi
+   tmp=$(mktemp /tmp/mdest-XXXXXX)
+   mdadm -E $d0 >$tmp
+   if [ x$(grep -c 'state\[[01]\] : Degraded' $tmp) != x2 ]; then
+       echo ERROR: non-degraded array found
+       mdadm -E $d0
+       ret=1
+   fi
+   if ! grep -q '^  *0  *[0-9a-f]\{8\} .*Offline, Failed' $tmp; then
+       echo ERROR: disk 0 not marked as failed in meta data
+       mdadm -E $d0
+       ret=1
+   fi
+   rm -f $tmp
+else
+   ret=0
+fi
+
+[ -f /tmp/mdmon.txt ] && {
+    cat /tmp/mdmon.txt
+    rm -f /tmp/mdmon.txt
+}
+
+[ $ret -eq 0 ]
+
-- 
1.7.1
