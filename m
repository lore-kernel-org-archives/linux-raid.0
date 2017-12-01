From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH 03/13] mdadm/test: redraft the 00raid1 test case
Date: Fri,  1 Dec 2017 17:48:04 +0800
Message-ID: <1512121694-18168-4-git-send-email-zlliu@suse.com>
References: <1512121694-18168-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1512121694-18168-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: jsorensen@fb.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

Make it cover different metadata version and
bitmap.

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 tests/00raid1 | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/tests/00raid1 b/tests/00raid1
index c93465d..939205f 100644
--- a/tests/00raid1
+++ b/tests/00raid1
@@ -2,17 +2,29 @@
 # create a simple mirror
 # test version0, version1, and no super
 # test resync and recovery.
+bmf=$targetdir/bmf
 
-mdadm -CR $md0 -l 1 -n2 $dev0 $dev1
-check resync
-check raid1
-testdev $md0 1 $mdsize1a 64
-mdadm -S $md0
+for bm in $bmf internal none
+do
+	for metadata in 0.90 1.0 1.1 1.2 default
+	do
+		[ "$bm" == "$bmf" -a -f "$bmf" ] && rm $bmf
+		mdadm -CR $md0 -l 1 -n2 -b $bm -e $metadata $dev0 $dev1
+		check resync
+		check raid1
+		check wait
+		testdev $md0 1 $mdsize1a 64
+		mdadm -S $md0
+	done
+done
+[ -f "$bmf"] && rm $bmf
 
 # now with version-0.90 superblock, spare
 mdadm -CR $md0 -e0.90 --level=raid1 -n3 -x2 $dev0 missing missing $dev1 $dev2
 check recovery
 check raid1
+check wait
+check state UUU
 testdev $md0 1 $mdsize0 64
 mdadm -S $md0
 
@@ -30,5 +42,4 @@ check nosync
 testdev $md0 1 $size 1
 mdadm -S $md0
 
-
 exit 0
-- 
1.8.5.6

