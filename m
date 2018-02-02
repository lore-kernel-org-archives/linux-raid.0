From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH 15/19] clustermd_tests: add test case to test manage_re-add against cluster-raid10
Date: Fri,  2 Feb 2018 14:10:59 +0800
Message-ID: <1517551863-1511-16-git-send-email-zlliu@suse.com>
References: <1517551863-1511-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1517551863-1511-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, gqjiang@suse.com, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

02r10_Manage_re-add:
2 active disk in array, set 1 disk 'fail' and 'remove' it from array,
then re-add the disk back to array and triggers recovery.

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 clustermd_tests/02r10_Manage_re-add | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)
 create mode 100644 clustermd_tests/02r10_Manage_re-add

diff --git a/clustermd_tests/02r10_Manage_re-add b/clustermd_tests/02r10_Manage_re-add
new file mode 100644
index 0000000..2288a00
--- /dev/null
+++ b/clustermd_tests/02r10_Manage_re-add
@@ -0,0 +1,18 @@
+#!/bin/bash
+
+mdadm -CR $md0 -l10 -b clustered --layout n2 -n2 $dev0 $dev1 --assume-clean
+ssh $NODE2 mdadm -A $md0 $dev0 $dev1
+check all nosync
+check all raid10
+check all bitmap
+check all state UU
+check all dmesg
+mdadm --manage $md0 --fail $dev0 --remove $dev0
+mdadm --manage $md0 --re-add $dev0
+check $NODE1 recovery
+check all wait
+check all state UU
+check all dmesg
+stop_md all $md0
+
+exit 0
-- 
2.6.6

