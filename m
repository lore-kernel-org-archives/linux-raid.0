From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH 08/13] mdadm/test: redraft 02r5grow and rename it as 02r5grow-resize
Date: Fri,  1 Dec 2017 17:48:09 +0800
Message-ID: <1512121694-18168-9-git-send-email-zlliu@suse.com>
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
 tests/02r5grow        | 53 --------------------------------
 tests/02r5grow-resize | 85 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 85 insertions(+), 53 deletions(-)
 delete mode 100644 tests/02r5grow
 create mode 100644 tests/02r5grow-resize

diff --git a/tests/02r5grow b/tests/02r5grow
deleted file mode 100644
index bb9bd6d..0000000
--- a/tests/02r5grow
+++ /dev/null
@@ -1,53 +0,0 @@
-
-
-# create a small raid5 array, make it larger.  Then make it smaller
-
-mdadm -CR $md0 -e0.90 --level raid5 --chunk=64 --raid-disks 3 --size $[size/2] $dev1 $dev2 $dev3
-check wait
-check state UUU
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
-mdadm -CR $md0 --level raid5 --metadata=1.1 --chunk=128 --raid-disks 4 --size $[size/2] $dev1 $dev2 $dev3 $dev4
-check wait
-check state UUUU
-testdev $md0 3 $[size/2] 128
-
-mdadm --grow $md0 --size max
-check resync
-check wait
-testdev $md0 3 $[mdsize1_l] 128
-
-mdadm --grow $md0 --size $[size/2]
-check nosync
-sh tests/testdev $md0 3 $[size/2] 128
-
-mdadm -S $md0
-
-# create a raid5 array and change the chunk
-mdadm -CR $md0 --level raid5 --metadata=1.1 --chunk=32 --raid-disks 3 --size $[size/2] $dev1 $dev2 $dev3
-check wait
-check state UUU
-check chunk 32
-
-mdadm $md0 --grow --chunk=64
-check reshape
-check wait
-check chunk 64
-
-mdadm -S $md0
-mdadm -A $md0 $dev1 $dev2 $dev3
-check state UUU
-check chunk 64
-mdadm -S $md0
diff --git a/tests/02r5grow-resize b/tests/02r5grow-resize
new file mode 100644
index 0000000..0f381b7
--- /dev/null
+++ b/tests/02r5grow-resize
@@ -0,0 +1,85 @@
+
+# create a small raid5 array, make it larger.  Then make it smaller
+mdadm -CR $md0 -e0.90 --level raid5 --chunk=64 --raid-disks 3 --size $[size/2] $dev1 $dev2 $dev3
+check wait
+check state UUU
+testdev $md0 2 $[size/2] 32
+
+mdadm --grow $md0 --size max
+check resync
+check wait
+check raid5
+check state UUU
+testdev $md0 2 $mdsize0 32
+
+# resize the component_size less than chunk_size
+mdadm --grow $md0 --size 63
+[ $? -eq '0' ] && exit 1
+
+mdadm --grow $md0 --size $[size/2]
+check nosync
+check raid5
+check state UUU
+testdev $md0 2 $[size/2] 32
+
+mdadm -S $md0
+
+# same again with version 1.1 superblock
+mdadm -CR $md0 --level raid5 --metadata=1.1 --chunk=128 --raid-disks 4 --size $[size/2] $dev1 $dev2 $dev3 $dev4
+check wait
+check state UUUU
+check raid5
+testdev $md0 3 $[size/2] 128
+
+mdadm --grow $md0 --size max
+check resync
+check wait
+check raid5
+check state UUUU
+testdev $md0 3 $[mdsize1_l] 128
+
+# resize the component_size less than chunk_size
+mdadm --grow $md0 --size 127
+[ $? -eq '0' ] && exit 1
+
+mdadm --grow $md0 --size $[size/2]
+check nosync
+check raid5
+check state UUUU
+testdev $md0 3 $[size/2] 128
+
+mdadm -S $md0
+
+# doesn't support to resize raid5 based-on external bitmap
+bm=$targetdir/bm
+[ -f $bm ] && rm $bm
+mdadm -CR $md0 --level raid5 --metadata=1.1 -b $bm --chunk=128 --raid-disks 4 --size $[size/2] $dev1 $dev2 $dev3 $dev4
+check wait
+check raid5
+check state UUUU
+testdev $md0 3 $[size/2] 128
+
+mdadm --grow $md0 --size max
+[ $? -eq '0' ] && exit 1
+
+rm $bm
+mdadm -S $md0
+
+# create a raid5 array and change the chunk
+mdadm -CR $md0 --level raid5 --metadata=1.1 --chunk=32 --raid-disks 3 --size $[size/2] $dev1 $dev2 $dev3
+check wait
+check state UUU
+check chunk 32
+
+mdadm $md0 --grow --chunk=64
+check reshape
+check wait
+check chunk 64
+
+mdadm -S $md0
+mdadm -A $md0 $dev1 $dev2 $dev3
+check state UUU
+check chunk 64
+mdadm -S $md0
+
+exit 0
-- 
1.8.5.6

