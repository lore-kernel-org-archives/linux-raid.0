From: Fam Zheng <famz@redhat.com>
Subject: [PATCH v2 10/12] mmc: Generate uevent after attribute available
Date: Thu, 30 Jun 2016 09:59:51 +0800
Message-ID: <20160630015953.6888-11-famz@redhat.com>
References: <20160630015953.6888-1-famz@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160630015953.6888-1-famz@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Jens Axboe <axboe@kernel.dk>, "Ed L. Cashin" <ed.cashin@acm.org>, Jiri Kosina <jikos@kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Shaohua Li <shli@kernel.org>, Ulf Hansson <ulf.hansson@linaro.org>, David Woodhouse <dwmw2@infradead.org>, Brian Norris <computersforpeace@gmail.com>, Keith Busch <keith.busch@intel.com>, linuxppc-dev@lists.ozlabs.org, linux-block@vger.kernel.org, virtualization@lists.linux-foundation.org, linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org, Christoph Hellwig <hch@infradead.org>, famz@redhat.com
List-Id: linux-raid.ids

It is documented that KOBJ_ADD should be generated after the object's
attributes and children are ready.  We can achieve this with the new
disk_gen_uevents interface.

Signed-off-by: Fam Zheng <famz@redhat.com>
---
 drivers/mmc/card/block.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 94cf51e..4007106 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -2457,7 +2457,7 @@ static int mmc_add_disk(struct mmc_blk_data *md)
 	int ret;
 	struct mmc_card *card = md->queue.card;
 
-	add_disk(md->disk, true);
+	add_disk(md->disk, false);
 	md->force_ro.show = force_ro_show;
 	md->force_ro.store = force_ro_store;
 	sysfs_attr_init(&md->force_ro.attr);
@@ -2466,6 +2466,7 @@ static int mmc_add_disk(struct mmc_blk_data *md)
 	ret = device_create_file(disk_to_dev(md->disk), &md->force_ro);
 	if (ret)
 		goto force_ro_fail;
+	disk_gen_uevents(md->disk);
 
 	if ((md->area_type & MMC_BLK_DATA_AREA_BOOT) &&
 	     card->ext_csd.boot_ro_lockable) {
-- 
2.9.0
