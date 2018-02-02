From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH 13/19] clustermd_tests: add test case to test manage_add-spare against cluster-raid10
Date: Fri,  2 Feb 2018 14:10:57 +0800
Message-ID: <1517551863-1511-14-git-send-email-zlliu@suse.com>
References: <1517551863-1511-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1517551863-1511-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, gqjiang@suse.com, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

02r10_Manage_add-spare: it has 2 scenarios against manage_add-spare.
1. 2 active disks in md array, using add-spare to add spare disk.
2. 2 active disks and 1 spare in array, add-spare 1 new disk into array,
   then check spares.

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 clustermd_tests/02r10_Manage_add-spare | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)
 create mode 100644 clustermd_tests/02r10_Manage_add-spare

diff --git a/clustermd_tests/02r10_Manage_add-spare b/clustermd_tests/02r10_Manage_add-spare
new file mode 100644
index 0000000..9924aa8
--- /dev/null
+++ b/clustermd_tests/02r10_Manage_add-spare
@@ -0,0 +1,30 @@
+#!/bin/bash
+
+mdadm -CR $md0 -l10 -b clustered --layout n2 -n2 $dev0 $dev1 --assume-clean
+ssh $NODE2 mdadm -A $md0 $dev0 $dev1
+check all nosync
+check all raid10
+check all bitmap
+check all state UU
+check all dmesg
+mdadm --manage $md0 --add-spare $dev2
+check all spares 1
+check all state UU
+check all dmesg
+stop_md all $md0
+
+mdadm -CR $md0 -l10 -b clustered --layout n2 -n2 -x1 $dev0 $dev1 $dev2 --assume-clean
+ssh $NODE2 mdadm -A $md0 $dev0 $dev1 $dev2
+check all nosync
+check all raid10
+check all bitmap
+check all spares 1
+check all state UU
+check all dmesg
+mdadm --manage $md0 --add-spare $dev3
+check all spares 2
+check all state UU
+check all dmesg
+stop_md all $md0
+
+exit 0
-- 
2.6.6

