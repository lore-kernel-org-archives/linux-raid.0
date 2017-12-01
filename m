From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH 06/13] mdadm/test: redraft the 00raid6 test case
Date: Fri,  1 Dec 2017 17:48:07 +0800
Message-ID: <1512121694-18168-7-git-send-email-zlliu@suse.com>
References: <1512121694-18168-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1512121694-18168-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: jsorensen@fb.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

make it cover different metadata and bitmap,
do more basic checking during testing.

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 tests/00raid6 | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/tests/00raid6 b/tests/00raid6
index 6977af9..4ea8fee 100644
--- a/tests/00raid6
+++ b/tests/00raid6
@@ -1,16 +1,21 @@
 
 # create a simple raid6 set
+bmf=$targetdir/bmf
 
-mdadm -CfR $md0 -e0.90 -l 6 -n4 $dev0 $dev1 $dev2 $dev3
-check resync ; check raid6
-testdev $md0 2 $mdsize0 512
-mdadm -S $md0
-
-# now with version-1 superblock
-mdadm -CR $md0 -e1 --level=raid6 -n5 $dev0 $dev1 $dev2 $dev3 $dev4
-check resync ; check raid6
-testdev $md0 3 $mdsize1 512
-mdadm -S $md0
-
+for bm in $bmf internal none
+do
+	for metadata in 0.90 1.0 1.1 1.2 default
+	do
+		[ "$bm" == "$bmf" -a -f "$bmf" ] && rm $bmf
+		mdadm -CfR $md0 -l6 -b $bm -e $metadata -n4 $dev0 $dev1 $dev2 $dev3
+		check resync
+		check wait
+		check raid6
+		check state UUUU
+		testdev $md0 2 $mdsize1 512
+		mdadm -S $md0
+	done
+done
+rm $bmf
 
 exit 0
-- 
1.8.5.6

