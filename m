From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH 04/13] mdadm/test: redraft 00raid4 test case
Date: Fri,  1 Dec 2017 17:48:05 +0800
Message-ID: <1512121694-18168-5-git-send-email-zlliu@suse.com>
References: <1512121694-18168-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1512121694-18168-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: jsorensen@fb.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

make it cover different metadata and bitmap.

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 tests/00raid4 | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/tests/00raid4 b/tests/00raid4
index 00a14f2..36606b0 100644
--- a/tests/00raid4
+++ b/tests/00raid4
@@ -1,16 +1,30 @@
 
 # create a simple raid4 set
+bmf=$targetdir/bmf
 
-mdadm -CfR $md0 -l 4 -n3 $dev0 $dev1 $dev2
-check resync ; check raid[45]
-testdev $md0 2 $mdsize1 512
-mdadm -S $md0
+for bm in $bmf internal none
+do
+	for metadata in 0.90 1.0 1.1 1.2 default
+	do
+		[ "$bm" == "$bmf" -a -f "$bmf" ] && rm $bmf
+		mdadm -CfR $md0 -l 4 -b $bm -e $metadata -n3 $dev0 $dev1 $dev2
+		check resync
+		check raid4
+		check wait
+		check state UUU
+		testdev $md0 2 $mdsize1 512
+		mdadm -S $md0
+	done
+done
+rm $bmf
 
 # now with version-1 superblock
 mdadm -CR $md0 -e1 --level=raid4 -n4 $dev0 $dev1 $dev2 $dev3
-check recovery; check raid[45]
+check recovery
+check raid4
+check wait
+check state UUUU
 testdev $md0 3 $mdsize1 512
 mdadm -S $md0
 
-
 exit 0
-- 
1.8.5.6

