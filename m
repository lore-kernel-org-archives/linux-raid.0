From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH 07/13] mdadm/test: redraft the 00raid10 test case
Date: Fri,  1 Dec 2017 17:48:08 +0800
Message-ID: <1512121694-18168-8-git-send-email-zlliu@suse.com>
References: <1512121694-18168-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1512121694-18168-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: jsorensen@fb.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

make it cover different bitmap, metadata and
"near, far, offset" layouts.

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 tests/00raid10 | 41 +++++++++++++++++++++++++++++------------
 1 file changed, 29 insertions(+), 12 deletions(-)

diff --git a/tests/00raid10 b/tests/00raid10
index 796b970..9929ee7 100644
--- a/tests/00raid10
+++ b/tests/00raid10
@@ -1,18 +1,35 @@
 
 # Create some raid10 arrays, all with 6 devices and one spare
 devs="$dev0 $dev1 $dev2 $dev3 $dev4 $dev5 $dev6"
+bmf=$targetdir/bm
 
-for lo in n2 n3 f2 f3
+for bm in $bmf internal none
 do
- cm=1
- case $lo in
-   f2 ) m=3 cm=2;;
-   f3 ) m=2 cm=3;;
-   n2 ) m=3;;
-   n3 ) m=2;;
- esac
- mdadm --create --run --level=raid10 --layout $lo --raid-disks 6 -x 1 $md0 $devs
- check resync ; check raid10
- testdev $md0 $m $mdsize1 $[512*cm]
- mdadm -S $md0
+	for metadata in 0.90 1.1 1.2 default
+	do
+		for lo in n2 n3 f2 f3 o2 o3
+		do
+			cm=1
+			case $lo in
+				f2 ) m=3 cm=2;;
+				f3 ) m=2 cm=3;;
+				n2 ) m=3;;
+				n3 ) m=2;;
+				o3 ) m=2;;
+				o2 ) m=3;;
+			esac
+			[ "$bm" == "$bmf" -a -f $bmf ] && rm $bmf
+			mdadm --create --run --level=raid10 -e $metadata -b $bm --layout $lo --raid-disks 6 -x 1 $md0 $devs
+			check resync
+			check raid10
+			check wait
+			check state UUUUUU
+			check spares 1
+			testdev $md0 $m $mdsize1 $[512*cm]
+			mdadm -S $md0
+		done
+	done
 done
+[ -f $bmf ] && rm $bmf
+
+exit 0
-- 
1.8.5.6

