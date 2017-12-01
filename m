From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH 10/13] mdadm/test: add new test 02r10grow-resize
Date: Fri,  1 Dec 2017 17:48:11 +0800
Message-ID: <1512121694-18168-11-git-send-email-zlliu@suse.com>
References: <1512121694-18168-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1512121694-18168-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: jsorensen@fb.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

This case mainly tested the resize feature
of raid10.

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 tests/02r10grow-resize | 103 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 103 insertions(+)
 create mode 100644 tests/02r10grow-resize

diff --git a/tests/02r10grow-resize b/tests/02r10grow-resize
new file mode 100644
index 0000000..d376a83
--- /dev/null
+++ b/tests/02r10grow-resize
@@ -0,0 +1,103 @@
+
+# Create some raid10 arrays and test resize
+devs="$dev0 $dev1 $dev2 $dev3"
+for metadata in 0.90 1.2
+do
+	for chunk in 64 128
+	do
+		for lo in n2 n3 o2 o3
+		do
+			mdadm -CR -l raid10 -e $metadata -b internal --chunk=$chunk --layout $lo --size $[size/2] --raid-disks 4 $md0 $devs
+			check resync
+			check wait
+			check raid10
+			check state UUUU
+
+			mdadm --grow $md0 --size max
+			check resync
+			check wait
+			check raid10
+			check state UUUU
+
+			mdadm --grow $md0 --size $(expr $chunk - 1)
+			[ $? -eq 0 ] && exit 1
+
+			mdadm --grow $md0 --size $[size/2]
+			check nosync
+			check raid10
+			check state UUUU
+
+			mdadm -S $md0
+		done
+	done
+done
+
+# doesn't support to resize raid10 based on far mode
+for metadata in 1.0 1.1
+do
+	for lo in f2 f3
+	do
+		mdadm -CR -l raid10 -e $metadata -b internal --chunk=64 --layout $lo --size $[size/2] --raid-disks 4 $md0 $devs
+		check resync
+		check wait
+		check raid10
+		check state UUUU
+
+		mdadm --grow $md0 --size max
+		[ $? -eq 0 ] && exit 1
+
+		mdadm --grow $md0 --size 63
+		[ $? -eq '0' ] && exit 1
+
+		mdadm --grow $md0 --size 256
+		[ $? -eq '0' ] && exit 1
+
+		mdadm -S $md0
+	done
+done
+
+# doesn't support to resize raid10 based-on external bitmap
+bm=$targetdir/bm
+[ -f $bm ] && rm $bm
+mdadm -CR $md0 --level raid10 --metadata=1.1 -b $bm --chunk=128 --raid-disks 4 --size $[size/2] $dev1 $dev2 $dev3 $dev4
+check wait
+check raid10
+check state UUUU
+
+mdadm --grow $md0 --size max
+[ $? -eq '0' ] && exit 1
+
+mdadm --grow $md0 --size 127
+[ $? -eq '0' ] && exit 1
+
+mdadm --grow $md0 --size 256
+[ $? -eq '0' ] && exit 1
+
+rm $bm
+mdadm -S $md0
+
+# same again with version 1.1 superblock
+mdadm -CR $md0 --level raid10 --metadata=1.1 --chunk=128 --raid-disks 4 --size $[size/2] $dev1 $dev2 $dev3 $dev4
+check wait
+check raid10
+check state UUUU
+
+mdadm --grow $md0 --size max
+check resync
+check wait
+check raid10
+check state UUUU
+testdev $md0 2 $[mdsize1_l] 128
+
+mdadm --grow $md0 --size 127
+[ $? -eq 0 ] && exit 1
+
+mdadm --grow $md0 --size $[size/2]
+check nosync
+check raid10
+check state UUUU
+testdev $md0 2 $[size/2] 128
+
+mdadm -S $md0
+
+exit 0
-- 
1.8.5.6

