From: raz ben yehuda <raziebe@gmail.com>
Subject: Subject:[PATCH 013:013]: kconfig:add raid0 a reshape option
Date: Wed, 17 Jun 2009 01:00:39 +0300
Message-ID: <1245189639.3478.119.camel@raz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux raid <linux-raid@vger.kernel.org>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 36e0675..c028d88 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -118,6 +118,19 @@ config MD_RAID10
 
 	  If unsure, say Y.
 
+config MD_RAID0_RESHAPE
+	bool "Support adding drives to a raid-0 array.(EXPERIMENTAL)"
+	depends on MD_RAID0 && EXPERIMENTAL
+	default n
+	---help---
+	  A RAID-0 set can be expanded by adding extra drives. This
+	  requires "restriping" .
+	  You will need mdadm version 2.6.x or later to use this.
+	  The mdadm usage is e.g.
+	       mdadm --grow /dev/md0 --raid-disks=6
+	  Note: The array can only be expanded.
+	  If unsure, say N.
+
 config MD_RAID456
 	tristate "RAID-4/RAID-5/RAID-6 mode"
 	depends on BLK_DEV_MD




