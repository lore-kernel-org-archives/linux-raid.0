From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH 10/19] clustermd_tests: add test case to test manage_add against cluster-raid1
Date: Fri,  2 Feb 2018 14:10:54 +0800
Message-ID: <1517551863-1511-11-git-send-email-zlliu@suse.com>
References: <1517551863-1511-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1517551863-1511-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, gqjiang@suse.com, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

02r1_Manage_add: it covers testing 2 scenarios against manage_add.
1. 2 active disks in md array, set 1 disk 'fail' and 'remove' it
   from array, then add 1 pure disk into array.
2. 2 active disks in array, add 1 new disk into array directly, now
   the 'add' in equal to 'add-spare'.

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 clustermd_tests/02r1_Manage_add | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)
 create mode 100644 clustermd_tests/02r1_Manage_add

diff --git a/clustermd_tests/02r1_Manage_add b/clustermd_tests/02r1_Manage_add
new file mode 100644
index 0000000..ab2751c
--- /dev/null
+++ b/clustermd_tests/02r1_Manage_add
@@ -0,0 +1,33 @@
+#!/bin/bash
+
+mdadm -CR $md0 -l1 -b clustered -n2 $dev0 $dev1 --assume-clean
+ssh $NODE2 mdadm -A $md0 $dev0 $dev1
+check all nosync
+check all raid1
+check all bitmap
+check all state UU
+check all dmesg
+mdadm --manage $md0 --fail $dev0 --remove $dev0
+mdadm --zero $dev2
+mdadm --manage $md0 --add $dev2
+sleep 0.3
+check $NODE1 recovery
+check $NODE1 wait
+check all state UU
+check all dmesg
+stop_md all $md0
+
+mdadm -CR $md0 -l1 -b clustered -n2 $dev0 $dev1 --assume-clean
+ssh $NODE2 mdadm -A $md0 $dev0 $dev1
+check all nosync
+check all raid1
+check all bitmap
+check all state UU
+check all dmesg
+mdadm --manage $md0 --add $dev2
+check all spares 1
+check all state UU
+check all dmesg
+stop_md all $md0
+
+exit 0
-- 
2.6.6

