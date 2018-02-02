From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH 09/19] clustermd_tests: add test case to test grow_add against cluster-raid1
Date: Fri,  2 Feb 2018 14:10:53 +0800
Message-ID: <1517551863-1511-10-git-send-email-zlliu@suse.com>
References: <1517551863-1511-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1517551863-1511-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, gqjiang@suse.com, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

01r1_Grow_add: It contains 3 kinds of growing array.
1. 2 active disk in md array, grow and add new disk into array.
2. 2 active and 1 spare disk in md array, grow and add new disk
   into array.
3. 2 active and 1 spare disk in md array, grow the device-number
   and make spare disk as active disk in array.

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 clustermd_tests/01r1_Grow_add | 68 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)
 create mode 100644 clustermd_tests/01r1_Grow_add

diff --git a/clustermd_tests/01r1_Grow_add b/clustermd_tests/01r1_Grow_add
new file mode 100644
index 0000000..5706114
--- /dev/null
+++ b/clustermd_tests/01r1_Grow_add
@@ -0,0 +1,68 @@
+#!/bin/bash
+
+mdadm -CR $md0 -l1 -b clustered -n2 $dev0 $dev1 --assume-clean
+ssh $NODE2 mdadm -A $md0 $dev0 $dev1
+check all nosync
+check all raid1
+check all bitmap
+check all state UU
+check all dmesg
+mdadm --grow $md0 --raid-devices=3 --add $dev2
+sleep 0.3
+grep recovery /proc/mdstat
+if [ $? -eq '0' ]
+then
+	check $NODE1 wait
+else
+	check $NODE2 recovery
+	check $NODE2 wait
+fi
+check all state UUU
+check all dmesg
+stop_md all $md0
+
+mdadm -CR $md0 -l1 -b clustered -n2 -x1 $dev0 $dev1 $dev2 --assume-clean
+ssh $NODE2 mdadm -A $md0 $dev0 $dev1 $dev2
+check all nosync
+check all raid1
+check all bitmap
+check all spares 1
+check all state UU
+check all dmesg
+mdadm --grow $md0 --raid-devices=3 --add $dev3
+sleep 0.3
+grep recovery /proc/mdstat
+if [ $? -eq '0' ]
+then
+	check $NODE1 wait
+else
+	check $NODE2 recovery
+	check $NODE2 wait
+fi
+check all state UUU
+check all dmesg
+stop_md all $md0
+
+mdadm -CR $md0 -l1 -b clustered -n2 -x1 $dev0 $dev1 $dev2 --assume-clean
+ssh $NODE2 mdadm -A $md0 $dev0 $dev1 $dev2
+check all nosync
+check all raid1
+check all bitmap
+check all spares 1
+check all state UU
+check all dmesg
+mdadm --grow $md0 --raid-devices=3
+sleep 0.3
+grep recovery /proc/mdstat
+if [ $? -eq '0' ]
+then
+	check $NODE1 wait
+else
+	check $NODE2 recovery
+	check $NODE2 wait
+fi
+check all state UUU
+check all dmesg
+stop_md all $md0
+
+exit 0
-- 
2.6.6

