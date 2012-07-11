From: Jes.Sorensen@redhat.com
Subject: [PATCH] 07reshape5intr: Set speed_limit_min to be able to reduce resync speed below 1000
Date: Wed, 11 Jul 2012 09:53:06 +0200
Message-ID: <1341993186-8207-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

We need to set speed_limit_min accordingly, otherwise setting
speed_limit_max below 1000 will have no effect.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 tests/07reshape5intr |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tests/07reshape5intr b/tests/07reshape5intr
index 6a26bf0..71ef2c7 100644
--- a/tests/07reshape5intr
+++ b/tests/07reshape5intr
@@ -20,6 +20,7 @@ do
 
   mdadm -CR $md0 -amd -l5 -c $chunk -n$disks --assume-clean $devs
   mdadm $md0 --add $dev6
+  echo 20 > /proc/sys/dev/raid/speed_limit_min
   echo 20 > /proc/sys/dev/raid/speed_limit_max
   mdadm --grow $md0 -n $[disks+1]
   check reshape
@@ -27,6 +28,7 @@ do
   mdadm --stop $md0
   mdadm --assemble $md0 $devs $dev6
   check reshape
+  echo 1000 > /proc/sys/dev/raid/speed_limit_min
   echo 2000 > /proc/sys/dev/raid/speed_limit_max
   check wait
   echo check > /sys/block/md0/md/sync_action
-- 
1.7.1

