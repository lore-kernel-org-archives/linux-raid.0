From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH 08/19] clustermd_tests: add test case to test switching bitmap against cluster-raid10
Date: Fri,  2 Feb 2018 14:10:52 +0800
Message-ID: <1517551863-1511-9-git-send-email-zlliu@suse.com>
References: <1517551863-1511-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1517551863-1511-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, gqjiang@suse.com, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

01r10_Grow_bitmap-switch:
It tests switching bitmap during three modes include of
clustered, none and internal, this case is testing the
clustered raid10.

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 clustermd_tests/01r10_Grow_bitmap-switch | 51 ++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)
 create mode 100644 clustermd_tests/01r10_Grow_bitmap-switch

diff --git a/clustermd_tests/01r10_Grow_bitmap-switch b/clustermd_tests/01r10_Grow_bitmap-switch
new file mode 100644
index 0000000..1794719
--- /dev/null
+++ b/clustermd_tests/01r10_Grow_bitmap-switch
@@ -0,0 +1,51 @@
+#!/bin/bash
+
+mdadm -CR $md0 -l10 -b clustered --layout n2 -n2 $dev0 $dev1 --assume-clean
+ssh $NODE2 mdadm -A $md0 $dev0 $dev1
+check all nosync
+check all raid10
+check all bitmap
+check all state UU
+
+# switch 'clustered' bitmap to 'none', and then 'none' to 'internal'
+stop_md $NODE2 $md0
+mdadm --grow $md0 --bitmap=none
+[ $? -eq '0' ] ||
+	die "$NODE1: change bitmap 'clustered' to 'none' failed."
+mdadm -X $dev0 $dev1 &> /dev/null
+[ $? -eq '0' ] &&
+	die "$NODE1: bitmap still exists in member_disks."
+check all nobitmap
+mdadm --grow $md0 --bitmap=internal
+[ $? -eq '0' ] ||
+	die "$NODE1: change bitmap 'none' to 'internal' failed."
+sleep 1
+mdadm -X $dev0 $dev1 &> /dev/null
+[ $? -eq '0' ] ||
+	die "$NODE1: create 'internal' bitmap failed."
+check $NODE1 bitmap
+
+# switch 'internal' bitmap to 'none', and then 'none' to 'clustered'
+mdadm --grow $md0 --bitmap=none
+[ $? -eq '0' ] ||
+	die "$NODE1: change bitmap 'internal' to 'none' failed."
+mdadm -X $dev0 $dev1 &> /dev/null
+[ $? -eq '0' ] &&
+	die "$NODE1: bitmap still exists in member_disks."
+check $NODE1 nobitmap
+mdadm --grow $md0 --bitmap=clustered
+[ $? -eq '0' ] ||
+	die "$NODE1: change bitmap 'none' to 'clustered' failed."
+ssh $NODE2 mdadm -A $md0 $dev0 $dev1
+sleep 1
+for ip in $NODES
+do
+	ssh $ip "mdadm -X $dev0 $dev1 | grep -q 'Cluster name'" ||
+		die "$ip: create 'clustered' bitmap failed."
+done
+check all bitmap
+check all state UU
+check all dmesg
+stop_md all $md0
+
+exit 0
-- 
2.6.6

