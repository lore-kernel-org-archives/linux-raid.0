From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH 09/13] mdadm/test: redraft 02r6grow and rename it as 02r6grow-resize
Date: Fri,  1 Dec 2017 17:48:10 +0800
Message-ID: <1512121694-18168-10-git-send-email-zlliu@suse.com>
References: <1512121694-18168-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1512121694-18168-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: jsorensen@fb.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

add checking "component_size > chunk_size"
add checking resize doesn't support with external-file bitmap.
add some basic checking.

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 tests/02r6grow        | 36 ---------------------------
 tests/02r6grow-resize | 69 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 69 insertions(+), 36 deletions(-)
 delete mode 100644 tests/02r6grow
 create mode 100644 tests/02r6grow-resize

diff --git a/tests/02r6grow b/tests/02r6grow
deleted file mode 100644
index 759e627..0000000
--- a/tests/02r6grow
+++ /dev/null
@@ -1,36 +0,0 @@
-
-
-# create a small raid6 array, make it larger.  Then make it smaller
-
-mdadm -CR $md0 -e 0.90 --level raid6 --chunk=64 --raid-disks 4 --size $[size/2] $dev1 $dev2 $dev3 $dev4
-check wait
-check state UUUU
-testdev $md0 2 $[size/2] 32
-
-mdadm --grow $md0 --size max
-check resync
-check wait
-testdev $md0 2 $mdsize0 32
-
-mdadm --grow $md0 --size $[size/2]
-check nosync
-testdev $md0 2 $[size/2] 32
-
-mdadm -S $md0
-
-# same again with version 1.1 superblock
-mdadm -CR $md0 --level raid6 --metadata=1.1 --chunk=128 --raid-disks 4 --size $[size/2] $dev1 $dev2 $dev3 $dev4
-check wait
-check state UUUU
-testdev $md0 2 $[size/2] 128
-
-mdadm --grow $md0 --size max
-check resync
-check wait
-testdev $md0 2 $[mdsize1_l] 128
-
-mdadm --grow $md0 --size $[size/2]
-check nosync
-testdev $md0 2 $[size/2] 128
-
-mdadm -S $md0
diff --git a/tests/02r6grow-resize b/tests/02r6grow-resize
new file mode 100644
index 0000000..c5c3301
--- /dev/null
+++ b/tests/02r6grow-resize
@@ -0,0 +1,69 @@
+
+
+# create a small raid6 array, make it larger.  Then make it smaller
+mdadm -CR $md0 -e 0.90 --level raid6 --chunk=64 --raid-disks 4 --size $[size/2] $dev1 $dev2 $dev3 $dev4
+check wait
+check raid6
+check state UUUU
+testdev $md0 2 $[size/2] 32
+
+mdadm --grow $md0 --size max
+check resync
+check wait
+check raid6
+check state UUUU
+testdev $md0 2 $mdsize0 32
+
+# resize the component_size less than chunk_size
+mdadm --grow $md0 --size 63
+[ $? -eq '0' ] && exit 1
+
+mdadm --grow $md0 --size $[size/2]
+check nosync
+check raid6
+check state UUUU
+testdev $md0 2 $[size/2] 32
+
+mdadm -S $md0
+
+# same again with version 1.1 superblock
+mdadm -CR $md0 --level raid6 --metadata=1.1 --chunk=128 --raid-disks 4 --size $[size/2] $dev1 $dev2 $dev3 $dev4
+check wait
+check raid6
+check state UUUU
+testdev $md0 2 $[size/2] 128
+
+mdadm --grow $md0 --size max
+check resync
+check wait
+check raid6
+check state UUUU
+testdev $md0 2 $[mdsize1_l] 128
+
+# resize the component_size less than chunk_size
+mdadm --grow $md0 --size 127
+[ $? -eq '0' ] && exit 1
+
+mdadm --grow $md0 --size $[size/2]
+check nosync
+check raid6
+check state UUUU
+testdev $md0 2 $[size/2] 128
+
+mdadm -S $md0
+
+# doesn't support to resize raid6 based-on external bitmap
+bm=$targetdir/bm
+[ -f $bm ] && rm $bm
+mdadm -CR $md0 --level raid6 --metadata=1.1 -b $bm --chunk=128 --raid-disks 4 --size $[size/2] $dev1 $dev2 $dev3 $dev4
+check wait
+check raid6
+check state UUUU
+
+mdadm --grow $md0 --size max
+[ $? -eq '0' ] && exit 1
+
+rm $bm
+mdadm -S $md0
+
+exit 0
-- 
1.8.5.6

