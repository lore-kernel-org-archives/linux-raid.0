From: Xiao Ni <xni@redhat.com>
Subject: [PATCH -v2 1/1] mdadm/test: Add one test case for raid5 reshape
Date: Mon, 17 Jul 2017 17:27:07 +0800
Message-ID: <1500283627-15195-1-git-send-email-xni@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: jes.sorensen@gmail.com
List-Id: linux-raid.ids

This case trys to allow raid5 reshape to use backwards direction.
It changes chunksize after reshape and stop the raid. Then start
the raid again.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 tests/02r5grow | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/tests/02r5grow b/tests/02r5grow
index 386e82e..64c5599 100644
--- a/tests/02r5grow
+++ b/tests/02r5grow
@@ -34,3 +34,16 @@ check nosync
 sh tests/testdev $md0 3 $[size/2] 128
 
 mdadm -S $md0
+
+# create a raid5 array and change the chunk
+mdadm -CR $md0 --level raid5 --metadata=1.1 --chunk=32 --raid-disks 3 --size $[size/2] $dev1 $dev2 $dev3
+check wait
+check state UUU
+
+mdadm $md0 --grow --chunk=64
+check reshape
+check wait
+
+mdadm -S $md0
+mdadm -As
+check state UUU
-- 
2.7.4

