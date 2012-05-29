From: Jes.Sorensen@redhat.com
Subject: [PATCH 2/2] New tests testing removal of internal bitmaps
Date: Tue, 29 May 2012 17:09:59 +0200
Message-ID: <1338304199-6047-3-git-send-email-Jes.Sorensen@redhat.com>
References: <1338304199-6047-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1338304199-6047-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: dledford@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

To match the add-bitmap tests, here is a set of tests checking the
removal of bitmaps.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 tests/05r1-remove-internalbitmap     |   18 ++++++++++++++++++
 tests/05r1-remove-internalbitmap-v1a |   18 ++++++++++++++++++
 tests/05r1-remove-internalbitmap-v1b |   18 ++++++++++++++++++
 tests/05r1-remove-internalbitmap-v1c |   18 ++++++++++++++++++
 4 files changed, 72 insertions(+)
 create mode 100644 tests/05r1-remove-internalbitmap
 create mode 100644 tests/05r1-remove-internalbitmap-v1a
 create mode 100644 tests/05r1-remove-internalbitmap-v1b
 create mode 100644 tests/05r1-remove-internalbitmap-v1c

diff --git a/tests/05r1-remove-internalbitmap b/tests/05r1-remove-internalbitmap
new file mode 100644
index 0000000..4e7728c
--- /dev/null
+++ b/tests/05r1-remove-internalbitmap
@@ -0,0 +1,18 @@
+# 
+# create a raid1 with bitmap, remove the bitmap and verify it is still
+# gone when re-assembling the array
+#
+mdadm --create --run $md0 --metadata=0.9 --level=1 -n2 --bitmap internal --bitmap-chunk=4 --delay=1 $dev1 $dev2
+check wait
+check bitmap
+testdev $md0 1 $mdsize1b 64
+mdadm -Gb none $md0
+check nobitmap
+testdev $md0 1 $mdsize1b 64
+mdadm -S $md0
+
+# Re-assemble the array and verify the bitmap is still present
+mdadm --assemble $md0 $dev1 $dev2
+check nobitmap
+testdev $md0 1 $mdsize1b 64
+mdadm -S $md0
diff --git a/tests/05r1-remove-internalbitmap-v1a b/tests/05r1-remove-internalbitmap-v1a
new file mode 100644
index 0000000..93c7730
--- /dev/null
+++ b/tests/05r1-remove-internalbitmap-v1a
@@ -0,0 +1,18 @@
+# 
+# create a raid1 with bitmap, remove the bitmap and verify it is still
+# gone when re-assembling the array
+#
+mdadm --create --run $md0 --metadata=1.0 --level=1 -n2 --bitmap internal --bitmap-chunk=4 --delay=1 $dev1 $dev2
+check wait
+check bitmap
+testdev $md0 1 $mdsize1b 64
+mdadm -Gb none $md0
+check nobitmap
+testdev $md0 1 $mdsize1b 64
+mdadm -S $md0
+
+# Re-assemble the array and verify the bitmap is still present
+mdadm --assemble $md0 $dev1 $dev2
+check nobitmap
+testdev $md0 1 $mdsize1b 64
+mdadm -S $md0
diff --git a/tests/05r1-remove-internalbitmap-v1b b/tests/05r1-remove-internalbitmap-v1b
new file mode 100644
index 0000000..705c8ee
--- /dev/null
+++ b/tests/05r1-remove-internalbitmap-v1b
@@ -0,0 +1,18 @@
+# 
+# create a raid1 with bitmap, remove the bitmap and verify it is still
+# gone when re-assembling the array
+#
+mdadm --create --run $md0 --metadata=1.1 --level=1 -n2 --bitmap internal --bitmap-chunk=4 --delay=1 $dev1 $dev2
+check wait
+check bitmap
+testdev $md0 1 $mdsize1b 64
+mdadm -Gb none $md0
+check nobitmap
+testdev $md0 1 $mdsize1b 64
+mdadm -S $md0
+
+# Re-assemble the array and verify the bitmap is still present
+mdadm --assemble $md0 $dev1 $dev2
+check nobitmap
+testdev $md0 1 $mdsize1b 64
+mdadm -S $md0
diff --git a/tests/05r1-remove-internalbitmap-v1c b/tests/05r1-remove-internalbitmap-v1c
new file mode 100644
index 0000000..6a14d96
--- /dev/null
+++ b/tests/05r1-remove-internalbitmap-v1c
@@ -0,0 +1,18 @@
+# 
+# create a raid1 with bitmap, remove the bitmap and verify it is still
+# gone when re-assembling the array
+#
+mdadm --create --run $md0 --metadata=1.2 --level=1 -n2 --bitmap internal --bitmap-chunk=4 --delay=1 $dev1 $dev2
+check wait
+check bitmap
+testdev $md0 1 $mdsize1b 64
+mdadm -Gb none $md0
+check nobitmap
+testdev $md0 1 $mdsize1b 64
+mdadm -S $md0
+
+# Re-assemble the array and verify the bitmap is still present
+mdadm --assemble $md0 $dev1 $dev2
+check nobitmap
+testdev $md0 1 $mdsize1b 64
+mdadm -S $md0
-- 
1.7.10.2

