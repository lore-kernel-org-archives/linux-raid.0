From: mwilck@arcor.de
Subject: [PATCH 6/6] tests/10ddf-geometry: new unit test
Date: Fri, 19 Jul 2013 21:04:15 +0200
Message-ID: <1374260655-5788-7-git-send-email-mwilck@arcor.de>
References: <1374260655-5788-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1374260655-5788-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

Test various RAID geometries, creation and deletion of subarrays
---
 tests/10ddf-geometry |   82 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 82 insertions(+), 0 deletions(-)
 create mode 100644 tests/10ddf-geometry

diff --git a/tests/10ddf-geometry b/tests/10ddf-geometry
new file mode 100644
index 0000000..75f5730
--- /dev/null
+++ b/tests/10ddf-geometry
@@ -0,0 +1,82 @@
+#
+# Test various RAID geometries, creation and deletion of subarrays
+#
+
+assert_fail() {
+    if mdadm "$@"; then
+       echo mdadm "$@" must fail
+       return 1
+    else
+       return 0
+    fi	
+}
+
+assert_kill() {
+    local dev=$1 n=$2
+    mdadm -S $dev
+    mdadm --kill-subarray=$n /dev/md/ddf0
+    if mdadm -Dbs | grep -q $dev; then
+        echo >&2 $dev should be deleted
+        return 1
+    fi
+    return 0
+}
+
+set -e
+mdadm -CR /dev/md/ddf0 -e ddf -n 6 $dev8 $dev9 $dev10 $dev11 $dev12 $dev13
+
+# RAID1 geometries
+# Use different sizes to make offset calculation harder
+mdadm -CR l1s -l1 -n2 /dev/md/ddf0 -z 8000
+mdadm -CR l1m -l1 -n3 $dev8 $dev9 $dev10 -z 10000
+assert_fail -CR badl1 -l1 -n4 /dev/md/ddf0
+
+# RAID10 geometries
+assert_fail -CR badl10 -l10 -n3 /dev/md/ddf0
+assert_fail -CR badl10 -l10 -n5 /dev/md/ddf0
+assert_fail -CR badl10 -l10 -n4 -pn3 /dev/md/ddf0
+mdadm -CR l10_2 -l10 -n6 -pn2 /dev/md/ddf0 -z 5000
+mdadm -CR l10_3 -l10 -n6 -pn3 /dev/md/ddf0 -z 5000
+
+assert_fail -CR l10_2 -l10 -n6 -pn2 /dev/md/ddf0 -z 5000
+assert_kill /dev/md/l10_2 2
+# gone now, must be able to create it again
+mdadm -CR l10_2 -l10 -n6 -pn2 /dev/md/ddf0 -z 5000
+
+# Now stop and reassemble
+mdadm -Ss
+mdadm -A /dev/md/ddf0 $dev8 $dev9 $dev10 $dev11 $dev12 $dev13
+
+# Same as above, on inactive container
+assert_fail -CR l10_3 -l10 -n6 -pn2 /dev/md/ddf0 -z 5000
+# Kill subarray without having started anything (no mdmon)
+mdadm --kill-subarray=3 /dev/md/ddf0
+mdadm -I /dev/md/ddf0
+mdadm -CR l10_3 -l10 -n6 -pn3 /dev/md/ddf0 -z 5000
+
+assert_kill /dev/md/l10_2 2
+assert_kill /dev/md/l10_3 3
+
+# RAID5 geometries
+mdadm -CR l5la -l5 -n3 --layout=ddf-N-restart /dev/md/ddf0 -z 5000 
+mdadm -CR l5ra -l5 -n3 --layout=ddf-zero-restart /dev/md/ddf0 -z 5000
+mdadm -CR l5ls -l5 -n3 --layout=ddf-N-continue /dev/md/ddf0 -z 5000
+assert_fail -CR l5rs -l5 -n3 -prs /dev/md/ddf0 -z 5000 
+
+# Stop and reassemble
+mdadm -Ss
+mdadm -A /dev/md/ddf0 $dev8 $dev9 $dev10 $dev11 $dev12 $dev13
+mdadm -I /dev/md/ddf0
+
+assert_kill /dev/md/l5la 2
+assert_kill /dev/md/l5ls 4
+assert_kill /dev/md/l5ra 3
+
+# RAID6 geometries
+assert_fail -CR l6la -l6 -n3 -pla /dev/md/ddf0 -z 5000 
+assert_fail -CR l6rs -l5 -n4 -prs /dev/md/ddf0 -z 5000 
+mdadm -CR l6la -l6 -n4 --layout=ddf-N-restart /dev/md/ddf0 -z 5000 
+mdadm -CR l6ra -l6 -n4 --layout=ddf-zero-restart $dev8 $dev9 $dev10 $dev11 -z 5000
+mdadm -CR l6ls -l6 -n4 --layout=ddf-N-continue $dev13 $dev8 $dev9 $dev12 -z 5000
+
+mdadm -Ss
-- 
1.7.1
