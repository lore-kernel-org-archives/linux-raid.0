From: raz ben yehuda <raziebe@gmail.com>
Subject: Subject: [PATCH 006/009]: raid1: chunk size check in run
Date: Tue, 19 May 2009 19:04:14 +0300
Message-ID: <1242749054.3293.53.camel@raz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux raid <linux-raid@vger.kernel.org>, Neil Brown <neilb@suse.de>
Cc: yaron <yaronp@bitband.com>, ofer <ofer@bitband.com>
List-Id: linux-raid.ids

have raid1 check chunk size in run method instead of in md
 raid1.c |    9 +++++++++
 1 file changed, 9 insertions(+)
Signed-off-by: raziebe@gmail.com
---
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 2c8d9e6..8609506 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1942,6 +1942,15 @@ static int run(mddev_t *mddev)
 		       mdname(mddev), mddev->level);
 		goto out;
 	}
+	/*
+	 * chunk-size has to be a power of 2
+	 */
+	if ((1 << ffz(~mddev->chunk_size)) != mddev->chunk_size) {
+		printk(KERN_ERR "%s chunk_size of %d not valid\n",
+			mdname(mddev),
+			mddev->chunk_size);
+		return -EINVAL;
+	}
 	if (mddev->reshape_position != MaxSector) {
 		printk("raid1: %s: reshape_position set but not supported\n",
 		       mdname(mddev));


