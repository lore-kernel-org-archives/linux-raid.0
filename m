From: Jes.Sorensen@redhat.com
Subject: [PATCH 1/1] raid0: Disable discard per default due to performance uncertainty
Date: Tue, 23 Jun 2015 20:26:13 -0400
Message-ID: <1435105573-1373-2-git-send-email-Jes.Sorensen@redhat.com>
References: <1435105573-1373-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1435105573-1373-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Some SSDs handle discard requests badly (very slowly). As an example,
mkfs.xfs on a RAID0 array with 4KB chunk size, constructed from Intel
SSDSC2BF18 180GB SSDs, can jump from 1.2secs to 43mins.

There is no reliable way to easily determine whether a device handles
discard at decent speed, and we cannot just benchmark it since it will
destroy data on the drive.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/md/raid0.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 4f19837..cc8c3c3 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -25,6 +25,11 @@
 #include "raid0.h"
 #include "raid5.h"
 
+static bool devices_discard_performance = false;
+module_param(devices_discard_performance, bool, 0644);
+MODULE_PARM_DESC(devices_discard_performance,
+		 "Set to Y if all devices in each array handles discard requests at proper speed");
+
 static int raid0_congested(struct mddev *mddev, int bits)
 {
 	struct r0conf *conf = mddev->private;
@@ -277,6 +282,21 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 		blk_queue_io_opt(mddev->queue,
 				 (mddev->chunk_sectors << 9) * mddev->raid_disks);
 
+		/* Unfortunately, some devices have awful discard performance,
+		 * especially for small sized requests. This is particularly
+		 * bad for RAID0 with a small chunk size resulting in a small
+		 * DISCARD requests hitting the underlaying drives.
+		 * Only allow DISCARD if the sysadmin confirms that all devices
+		 * in use can handle small DISCARD requests at reasonable speed,
+		 * by setting a module parameter.
+		 */
+		if (!devices_discard_performance) {
+			if (discard_supported) {
+				pr_info("md/raid0: discard support disabled due to performance uncertainty.\n");
+				pr_info("Set raid0.devices_discard_performance=Y to override.\n");
+			}
+			discard_supported = false;
+		}
 		if (!discard_supported)
 			queue_flag_clear_unlocked(QUEUE_FLAG_DISCARD, mddev->queue);
 		else
-- 
2.4.3

