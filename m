From: Fam Zheng <famz@redhat.com>
Subject: [PATCH v2 09/12] md: Generate uevent after attribute available
Date: Thu, 30 Jun 2016 09:59:50 +0800
Message-ID: <20160630015953.6888-10-famz@redhat.com>
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
 drivers/md/md.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 1391c72..dcd09ea 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5055,7 +5055,7 @@ static int md_alloc(dev_t dev, char *name)
 	 * through to md_open, so make sure it doesn't get too far
 	 */
 	mutex_lock(&mddev->open_mutex);
-	add_disk(disk, true);
+	add_disk(disk, false);
 
 	error = kobject_init_and_add(&mddev->kobj, &md_ktype,
 				     &disk_to_dev(disk)->kobj, "%s", "md");
@@ -5070,6 +5070,7 @@ static int md_alloc(dev_t dev, char *name)
 	if (mddev->kobj.sd &&
 	    sysfs_create_group(&mddev->kobj, &md_bitmap_group))
 		printk(KERN_DEBUG "pointless warning\n");
+	disk_gen_uevents(disk);
 	mutex_unlock(&mddev->open_mutex);
  abort:
 	mutex_unlock(&disks_mutex);
-- 
2.9.0
