From: Jes.Sorensen@redhat.com
Subject: [PATCH 1/2] New tests testing the addition of bitmaps
Date: Tue, 29 May 2012 17:09:58 +0200
Message-ID: <1338304199-6047-2-git-send-email-Jes.Sorensen@redhat.com>
References: <1338304199-6047-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1338304199-6047-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: dledford@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This set of tests verifies that it is possible to add an internal
bitmap to an existing array, and that the device can be written to
after the bitmap is added. This should catch cases such as the one
fixed by 4474ca42e2577563a919fd3ed782e2ec55bf11a2

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 tests/05r1-add-internalbitmap     |   20 ++++++++++++++++++++
 tests/05r1-add-internalbitmap-v1a |   20 ++++++++++++++++++++
 tests/05r1-add-internalbitmap-v1b |   20 ++++++++++++++++++++
 tests/05r1-add-internalbitmap-v1c |   20 ++++++++++++++++++++
 4 files changed, 80 insertions(+)
 create mode 100644 tests/05r1-add-internalbitmap
 create mode 100644 tests/05r1-add-internalbitmap-v1a
 create mode 100644 tests/05r1-add-internalbitmap-v1b
 create mode 100644 tests/05r1-add-internalbitmap-v1c

diff --git a/tests/05r1-add-internalbitmap b/tests/05r1-add-internalbitmap
new file mode 100644
index 0000000..80ce9f5
--- /dev/null
+++ b/tests/05r1-add-internalbitmap
@@ -0,0 +1,20 @@
+# 
+# create a raid1 without any bitmap, add the bitmap and then write to
+# the device. This should catch the case where the bitmap is created
+# but not reloaded correctly, such as the case fixed by
+# 4474ca42e2577563a919fd3ed782e2ec55bf11a2
+#
+mdadm --create --run $md0 --metadata=0.9 --level=1 -n2 --delay=1 $dev1 $dev2
+check wait
+check nobitmap
+testdev $md0 1 $mdsize1b 64
+mdadm -Gb internal --bitmap-chunk=4 $md0
+check bitmap
+testdev $md0 1 $mdsize1b 64
+mdadm -S $md0
+
+# Re-assemble the array and verify the bitmap is still present
+mdadm --assemble $md0 $dev1 $dev2
+check bitmap
+testdev $md0 1 $mdsize1b 64
+mdadm -S $md0
diff --git a/tests/05r1-add-internalbitmap-v1a b/tests/05r1-add-internalbitmap-v1a
new file mode 100644
index 0000000..b7c80cd
--- /dev/null
+++ b/tests/05r1-add-internalbitmap-v1a
@@ -0,0 +1,20 @@
+# 
+# create a raid1 without any bitmap, add the bitmap and then write to
+# the device. This should catch the case where the bitmap is created
+# but not reloaded correctly, such as the case fixed by
+# 4474ca42e2577563a919fd3ed782e2ec55bf11a2
+#
+mdadm --create --run $md0 --metadata=1.0 --level=1 -n2 --delay=1 $dev1 $dev2
+check wait
+check nobitmap
+testdev $md0 1 $mdsize1b 64
+mdadm -Gb internal --bitmap-chunk=4 $md0
+check bitmap
+testdev $md0 1 $mdsize1b 64
+mdadm -S $md0
+
+# Re-assemble the array and verify the bitmap is still present
+mdadm --assemble $md0 $dev1 $dev2
+check bitmap
+testdev $md0 1 $mdsize1b 64
+mdadm -S $md0
diff --git a/tests/05r1-add-internalbitmap-v1b b/tests/05r1-add-internalbitmap-v1b
new file mode 100644
index 0000000..b077fa7
--- /dev/null
+++ b/tests/05r1-add-internalbitmap-v1b
@@ -0,0 +1,20 @@
+# 
+# create a raid1 without any bitmap, add the bitmap and then write to
+# the device. This should catch the case where the bitmap is created
+# but not reloaded correctly, such as the case fixed by
+# 4474ca42e2577563a919fd3ed782e2ec55bf11a2
+#
+mdadm --create --run $md0 --metadata=1.1 --level=1 -n2 --delay=1 $dev1 $dev2
+check wait
+check nobitmap
+testdev $md0 1 $mdsize1b 64
+mdadm -Gb internal --bitmap-chunk=4 $md0
+check bitmap
+testdev $md0 1 $mdsize1b 64
+mdadm -S $md0
+
+# Re-assemble the array and verify the bitmap is still present
+mdadm --assemble $md0 $dev1 $dev2
+check bitmap
+testdev $md0 1 $mdsize1b 64
+mdadm -S $md0
diff --git a/tests/05r1-add-internalbitmap-v1c b/tests/05r1-add-internalbitmap-v1c
new file mode 100644
index 0000000..7b39784
--- /dev/null
+++ b/tests/05r1-add-internalbitmap-v1c
@@ -0,0 +1,20 @@
+# 
+# create a raid1 without any bitmap, add the bitmap and then write to
+# the device. This should catch the case where the bitmap is created
+# but not reloaded correctly, such as the case fixed by
+# 4474ca42e2577563a919fd3ed782e2ec55bf11a2
+#
+mdadm --create --run $md0 --metadata=1.2 --level=1 -n2 --delay=1 $dev1 $dev2
+check wait
+check nobitmap
+testdev $md0 1 $mdsize1b 64
+mdadm -Gb internal --bitmap-chunk=4 $md0
+check bitmap
+testdev $md0 1 $mdsize1b 64
+mdadm -S $md0
+
+# Re-assemble the array and verify the bitmap is still present
+mdadm --assemble $md0 $dev1 $dev2
+check bitmap
+testdev $md0 1 $mdsize1b 64
+mdadm -S $md0
-- 
1.7.10.2

