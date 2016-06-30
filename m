From: Fam Zheng <famz@redhat.com>
Subject: [PATCH v2 11/12] mtd: Generate uevent after attribute available
Date: Thu, 30 Jun 2016 09:59:52 +0800
Message-ID: <20160630015953.6888-12-famz@redhat.com>
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
 drivers/mtd/mtd_blkdevs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index ab3bc22..6848141 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -436,13 +436,14 @@ int add_mtd_blktrans_dev(struct mtd_blktrans_dev *new)
 	if (new->readonly)
 		set_disk_ro(gd, 1);
 
-	add_disk(gd, true);
+	add_disk(gd, false);
 
 	if (new->disk_attributes) {
 		ret = sysfs_create_group(&disk_to_dev(gd)->kobj,
 					new->disk_attributes);
 		WARN_ON(ret);
 	}
+	disk_gen_uevents(gd);
 	return 0;
 error4:
 	blk_cleanup_queue(new->rq);
-- 
2.9.0
