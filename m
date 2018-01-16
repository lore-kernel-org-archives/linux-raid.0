From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH 8/8] mdadm/clustermd_tests: add test case to test grow_resize cluster-raid10
Date: Tue, 16 Jan 2018 17:45:09 +0800
Message-ID: <1516095909-12968-9-git-send-email-zlliu@suse.com>
References: <1516095909-12968-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1516095909-12968-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

01r10_Grow_resize:
1. Create clustered raid10 with smaller size, then resize the
mddev to max size, finally change back to smaller size.
2. Create clustered raid10 with smaller chunk-size, then resize
it to larger, and trigger reshape.

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 clustermd_tests/01r10_Grow_resize | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)
 create mode 100644 clustermd_tests/01r10_Grow_resize

diff --git a/clustermd_tests/01r10_Grow_resize b/clustermd_tests/01r10_Grow_resize
new file mode 100644
index 0000000..c69b785
--- /dev/null
+++ b/clustermd_tests/01r10_Grow_resize
@@ -0,0 +1,38 @@
+#!/bin/bash
+
+size=20000
+
+mdadm -CR $md0 -l10 -b clustered --layout n2 --size $size --chunk=64 -n2 $dev0 $dev1 --assume-clean
+ssh $NODE2 mdadm -A $md0 $dev0 $dev1
+check all nosync
+check all raid10
+check all bitmap
+check all state UU
+
+mdadm --grow $md0 --size max
+check $NODE1 resync
+check $NODE1 wait
+check all state UU
+
+mdadm --grow $md0 --size $size
+check all nosync
+check all state UU
+check all dmesg
+stop_md all $md0
+
+mdadm -CR $md0 -l10 -b clustered --layout n2 --chunk=64 -n2 $dev0 $dev1 --assume-clean
+ssh $NODE2 mdadm -A $md0 $dev0 $dev1
+check all nosync
+check all raid10
+check all bitmap
+check all state UU
+
+mdadm --grow $md0 --chunk=128
+check $NODE1 reshape
+check $NODE1 wait
+check all chunk 128
+check all state UU
+check all dmesg
+stop_md all $md0
+
+exit 0
-- 
2.6.6

