From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH 19/19] clustermd_tests: add test case to test switch-recovery against cluster-raid10
Date: Fri,  2 Feb 2018 14:11:03 +0800
Message-ID: <1517551863-1511-20-git-send-email-zlliu@suse.com>
References: <1517551863-1511-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1517551863-1511-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, gqjiang@suse.com, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

03r10_switch-recovery:
Create new array with 2 active and 1 spare disk, set 1 active disk as 'fail',
it triggers recovery and the spare disk would replace the failure disk, then
stop the array in doing recovery node, the other node would take it over and
continue to complete the recovery.

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 clustermd_tests/03r10_switch-recovery | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)
 create mode 100644 clustermd_tests/03r10_switch-recovery

diff --git a/clustermd_tests/03r10_switch-recovery b/clustermd_tests/03r10_switch-recovery
new file mode 100644
index 0000000..867388d
--- /dev/null
+++ b/clustermd_tests/03r10_switch-recovery
@@ -0,0 +1,21 @@
+#!/bin/bash
+
+mdadm -CR $md0 -l10 -b clustered --layout n2 -n2 -x1 $dev0 $dev1 $dev2 --assume-clean
+ssh $NODE2 mdadm -A $md0 $dev0 $dev1 $dev2
+check all nosync
+check all raid10
+check all bitmap
+check all spares 1
+check all state UU
+check all dmesg
+mdadm --manage $md0 --fail $dev0
+sleep 0.2
+check $NODE1 recovery
+stop_md $NODE1 $md0
+check $NODE2 recovery
+check $NODE2 wait
+check $NODE2 state UU
+check all dmesg
+stop_md $NODE2 $md0
+
+exit 0
-- 
2.6.6

