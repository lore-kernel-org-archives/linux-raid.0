From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH v5 1/8] md: Introduce md_stop_all_writes()
Date: Mon,  2 Oct 2017 15:52:11 -0700
Message-ID: <20171002225218.18548-2-bart.vanassche@wdc.com>
References: <20171002225218.18548-1-bart.vanassche@wdc.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171002225218.18548-1-bart.vanassche@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, =Oleksandr Natalenko <oleksandr@natalenko.name>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Bart Van Assche <bart.vanassche@wdc.com>, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-raid.ids

Introduce md_stop_all_writes() because the next patch will add
a second caller for this function. Rename md_notifier into
md_reboot_notifier to avoid that the name of this notifier will
become confusing due to the next patch. This patch does not
change any functionality.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/md/md.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 0ff1bbf6c90e..3f7426120a3b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8935,8 +8935,7 @@ int rdev_clear_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
 }
 EXPORT_SYMBOL_GPL(rdev_clear_badblocks);
 
-static int md_notify_reboot(struct notifier_block *this,
-			    unsigned long code, void *x)
+static void md_stop_all_writes(void)
 {
 	struct list_head *tmp;
 	struct mddev *mddev;
@@ -8960,11 +8959,17 @@ static int md_notify_reboot(struct notifier_block *this,
 	 */
 	if (need_delay)
 		mdelay(1000*1);
+}
+
+static int md_notify_reboot(struct notifier_block *this,
+			    unsigned long code, void *x)
+{
+	md_stop_all_writes();
 
 	return NOTIFY_DONE;
 }
 
-static struct notifier_block md_notifier = {
+static struct notifier_block md_reboot_notifier = {
 	.notifier_call	= md_notify_reboot,
 	.next		= NULL,
 	.priority	= INT_MAX, /* before any real devices */
@@ -9001,7 +9006,7 @@ static int __init md_init(void)
 	blk_register_region(MKDEV(mdp_major, 0), 1UL<<MINORBITS, THIS_MODULE,
 			    md_probe, NULL, NULL);
 
-	register_reboot_notifier(&md_notifier);
+	register_reboot_notifier(&md_reboot_notifier);
 	raid_table_header = register_sysctl_table(raid_root_table);
 
 	md_geninit();
@@ -9241,7 +9246,7 @@ static __exit void md_exit(void)
 
 	unregister_blkdev(MD_MAJOR,"md");
 	unregister_blkdev(mdp_major, "mdp");
-	unregister_reboot_notifier(&md_notifier);
+	unregister_reboot_notifier(&md_reboot_notifier);
 	unregister_sysctl_table(raid_table_header);
 
 	/* We cannot unload the modules while some process is
-- 
2.14.1
