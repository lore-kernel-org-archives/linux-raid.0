From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH 5/8] mdadm/clustermd_tests: add test case to test creating cluster-raid1
Date: Tue, 16 Jan 2018 17:45:06 +0800
Message-ID: <1516095909-12968-6-git-send-email-zlliu@suse.com>
References: <1516095909-12968-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1516095909-12968-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

00r1_Create: It contains 4 scenarios of creating clustered raid1.
1. General creating, master node does resync and slave node does
   Pending.
2. Creating clustered raid1 with --assume-clean parameter.
3. Creating clustered raid1 with spare disk.
4. Creating clustered raid1 with --name.

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 clustermd_tests/00r1_Create | 50 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)
 create mode 100644 clustermd_tests/00r1_Create

diff --git a/clustermd_tests/00r1_Create b/clustermd_tests/00r1_Create
new file mode 100644
index 0000000..709bb7b
--- /dev/null
+++ b/clustermd_tests/00r1_Create
@@ -0,0 +1,50 @@
+#!/bin/bash
+
+mdadm -CR $md0 -l1 -b clustered -n2 $dev0 $dev1
+ssh $NODE2 mdadm -A $md0 $dev0 $dev1
+check $NODE1 resync
+check $NODE2 PENDING
+check all wait
+check all raid1
+check all bitmap
+check all nosync
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
+stop_md all $md0
+
+name=tstmd
+mdadm -CR $md0 -l1 -b clustered -n2 $dev0 $dev1 --name=$name --assume-clean
+ssh $NODE2 mdadm -A $md0 $dev0 $dev1
+check all nosync
+check all raid1
+check all bitmap
+check all state UU
+for ip in $NODE1 $NODE2
+do
+	ssh $ip "mdadm -D $md0 | grep 'Name' | grep -q $name"
+	[ $? -ne '0' ] &&
+		die "$ip: check --name=$name failed."
+done
+check all dmesg
+stop_md all $md0
+
+exit 0
-- 
2.6.6

