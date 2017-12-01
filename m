From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH 05/13] mdadm/test: redraft the 00raid5 test case
Date: Fri,  1 Dec 2017 17:48:06 +0800
Message-ID: <1512121694-18168-6-git-send-email-zlliu@suse.com>
References: <1512121694-18168-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1512121694-18168-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: jsorensen@fb.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

make it cover different layout, bitmap and
metadata versions, and cover resync/recover
features.

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 tests/00raid5 | 51 ++++++++++++++++++++++++++-------------------------
 1 file changed, 26 insertions(+), 25 deletions(-)

diff --git a/tests/00raid5 b/tests/00raid5
index b2b7a97..b891694 100644
--- a/tests/00raid5
+++ b/tests/00raid5
@@ -1,33 +1,34 @@
 
 # create a simple raid5 set
 
-mdadm -CfR $md0 -e 0.90 -l 5 -n3 $dev0 $dev1 $dev2
-check resync
-testdev $md0 2 $mdsize0 512
-mdadm -S $md0
+bmf=$targetdir/bmf
 
-# now with version-1 superblock
-mdadm -CR $md0 -e1 --level=raid5 -n4 $dev0 $dev1 $dev2 $dev3
-check recovery
-testdev $md0 3 $mdsize1 512
-mdadm -S $md0
-
-# now same again with explicit layout
-
-for lo in la ra left-symmetric right-symmetric
+for bm in $bmf internal none
 do
-
-  mdadm -CfR $md0  -l 5 -p $lo -n3 $dev0 $dev1 $dev2
-  check resync ; check raid5
-  testdev $md0 2 $mdsize1 512
-  mdadm -S $md0
-
-  # now with version-1 superblock
-  mdadm -CR $md0 -e1 --level=raid5 --layout $lo -n4 $dev0 $dev1 $dev2 $dev3
-  check recovery ; check raid5
-  testdev $md0 3 $mdsize1 512
-  mdadm -S $md0
-
+	for metadata in 0.90 1.0 1.1 1.2 default
+	do
+		for lo in la ra left-symmetric right-symmetric
+		do
+			[ "$bm" == "$bmf" -a -f "$bmf" ] && rm $bmf
+			mdadm -CfR $md0 -e $metadata -b $bm -l5 --layout $lo -n3 $dev0 $dev1 $dev2
+			check resync
+			check raid5
+			check wait
+			check state UUU
+			testdev $md0 2 $mdsize1 512
+			mdadm -S $md0
+
+			[ "$bm" == "$bmf" -a -f "$bmf" ] && rm $bmf
+			mdadm -CR $md0 -e $metadata -b $bm --level=raid5 --layout $lo -n4 $dev0 $dev1 $dev2 $dev3
+			check recovery
+			check raid5
+			check wait
+			check state UUUU
+			testdev $md0 3 $mdsize1 512
+			mdadm -S $md0
+		done
+	done
 done
+[ -f "$bmf" ] && rm $bmf
 
 exit 0
-- 
1.8.5.6

