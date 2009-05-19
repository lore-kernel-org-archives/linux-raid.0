From: raz ben yehuda <raziebe@gmail.com>
Subject: Subject: [PATCH 008/009]: raid5: chunk size check in run
Date: Tue, 19 May 2009 19:07:43 +0300
Message-ID: <1242749263.3293.67.camel@raz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux raid <linux-raid@vger.kernel.org>, Neil Brown <neilb@suse.de>
Cc: yaron <yaronp@bitband.com>, ofer <ofer@bitband.com>
List-Id: linux-raid.ids

have raid5 check chunk size in run method instead of in md
 raid5.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)
Signed-Off-by:raziebe@gmail.com
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index e4608d6..0c688ee 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4452,7 +4452,15 @@ static int run(mddev_t *mddev)
 	raid5_conf_t *conf;
 	int working_disks = 0;
 	mdk_rdev_t *rdev;
-
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
 		/* Check that we can continue the reshape.
 		 * Currently only disks can change, it must


