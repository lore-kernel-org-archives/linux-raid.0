From: Xiao Ni <xni@redhat.com>
Subject: [mdadm PATCH 1/1] mdadm/test: Add one test case for raid5 reshape
Date: Thu, 13 Jul 2017 17:14:19 +0800
Message-ID: <1499937259-16791-1-git-send-email-xni@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: jes.sorensen@gmail.com, shli@kernel.org
List-Id: linux-raid.ids

This case trys to allow raid5 reshape to use backwards direction.
It changes chunksize after reshape and stop the raid. Then start
the raid again.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 tests/02r5grow | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tests/02r5grow b/tests/02r5grow
index 386e82e..14d05d6 100644
--- a/tests/02r5grow
+++ b/tests/02r5grow
@@ -34,3 +34,15 @@ check nosync
 sh tests/testdev $md0 3 $[size/2] 128
 
 mdadm -S $md0
+
+# create a raid5 array and change the chunk
+mdadm -CR $md0 --level raid5 --metadata=1.1 --chunk=32 --raid-disks 3 --size $[size/2] $dev1 $dev2 $dev3
+check wait
+check state UUU
+
+mdadm $md0 --grow --chunk=64
+mdadm --wait $md0
+
+mdadm -S $md0
+mdadm -As
+mdadm -Ss
-- 
2.7.4

