From: Azat Khuzhin <a3at.mail@gmail.com>
Subject: [PATCH] Since changing number of devices in RAID10 is possible fix man and add a test (RFC)
Date: Sat,  3 Feb 2018 20:00:06 +0300
Message-ID: <20180203170006.5750-1-a3at.mail@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Azat Khuzhin <a3at.mail@gmail.com>, NeilBrown <neilb@suse.com>, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

It requires patch from, otherwise it fails anyway:
  "mdadm/grow: adding a test to ensure resize was required"
  https://www.spinics.net/lists/raid/msg59743.html

Since: 19ceb16dafb7df98ff90298008d4488dc93b370a ("Grow: add raid10
reshape.") # mdadm mdadm-3.2.5-120-g19ceb16
Since: 3ea7daa5d7fde47cd41f4d56c2deb949114da9d6 ("md/raid10: add reshape
support")  # linux v3.4-rc5-15-g3ea7daa5d7fd
Tested-on: linux 4.13+

Signed-off-by: Azat Khuzhin <a3at.mail@gmail.com>
Cc: NeilBrown <neilb@suse.com>
Cc: Zhilong Liu <zlliu@suse.com>
---
Any thoughts?

 mdadm.8.in      |  2 +-
 tests/02r10grow | 32 ++++++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+), 1 deletion(-)
 create mode 100644 tests/02r10grow

diff --git a/mdadm.8.in b/mdadm.8.in
index f0fd1fc..62da7b1 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -123,7 +123,7 @@ missing, spare, or failed drives, so there is nothing to monitor.
 Grow (or shrink) an array, or otherwise reshape it in some way.
 Currently supported growth options including changing the active size
 of component devices and changing the number of active devices in
-Linear and RAID levels 0/1/4/5/6,
+Linear and RAID levels 0/1/4/5/6/10,
 changing the RAID level between 0, 1, 5, and 6, and between 0 and 10,
 changing the chunk size and layout for RAID 0,4,5,6,10 as well as adding or
 removing a write-intent bitmap and changing the array's consistency policy.
diff --git a/tests/02r10grow b/tests/02r10grow
new file mode 100644
index 0000000..0b177fe
--- /dev/null
+++ b/tests/02r10grow
@@ -0,0 +1,32 @@
+
+# create a 4-disk raid10 array, make it 8-disk array.
+#
+# This SHOULD fail:
+# - before mdadm 3.3 and linux 3.5
+# - with metadata v0.90
+#
+# This also fails:
+# - with metadata 1.0 with "mdadm: Insufficient head-space for reshape on /dev/loop1" error
+
+m=2
+cm=1
+
+for metadata in 1.1 1.2; do
+    # 4 disks
+    mdadm -CR $md0 --metadata $metadata --level raid10 --raid-disks 4 $dev1 $dev2 $dev3 $dev4
+    check wait
+    check state UUUU
+    check raid10
+    testdev $md0 $m $mdsize1 $[512*cm]
+
+    # 8 disks
+    mdadm $md0 --add $dev8 $dev9 $dev10 $dev11
+    mdadm $md0 --grow --raid-devices 8
+    check wait
+    check state UUUUUUUU
+    check raid10
+    testdev $md0 $m $[mdsize1*2] $[512*cm]
+
+
+    mdadm -S $md0
+done
-- 
2.16.1

