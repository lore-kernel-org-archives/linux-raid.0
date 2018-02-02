From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH 17/19] clustermd_tests: add test case to test switch-resync against cluster-raid10
Date: Fri,  2 Feb 2018 14:11:01 +0800
Message-ID: <1517551863-1511-18-git-send-email-zlliu@suse.com>
References: <1517551863-1511-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1517551863-1511-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, gqjiang@suse.com, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

03r10_switch-resync:
Create new array, 1 node is doing resync and other node would keep PENDING,
stop the array in resync node, other node would take it over and continue
to complete the resync.

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 clustermd_tests/03r10_switch-resync | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)
 create mode 100644 clustermd_tests/03r10_switch-resync

diff --git a/clustermd_tests/03r10_switch-resync b/clustermd_tests/03r10_switch-resync
new file mode 100644
index 0000000..127c569
--- /dev/null
+++ b/clustermd_tests/03r10_switch-resync
@@ -0,0 +1,18 @@
+#!/bin/bash
+
+mdadm -CR $md0 -l10 -b clustered --layout n2 -n2 $dev0 $dev1
+ssh $NODE2 mdadm -A $md0 $dev0 $dev1
+check $NODE1 resync
+check $NODE2 PENDING
+stop_md $NODE1 $md0
+check $NODE2 resync
+check $NODE2 wait
+mdadm -A $md0 $dev0 $dev1
+check all raid10
+check all bitmap
+check all nosync
+check all state UU
+check all dmesg
+stop_md all $md0
+
+exit 0
-- 
2.6.6

