From: Fam Zheng <famz@redhat.com>
Subject: [PATCH v2 01/12] genhd: Add "gen_uevent" parameter to add_disk
Date: Thu, 30 Jun 2016 09:59:42 +0800
Message-ID: <20160630015953.6888-2-famz@redhat.com>
References: <20160630015953.6888-1-famz@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20160630015953.6888-1-famz@redhat.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: linux-kernel@vger.kernel.org
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, "Michael S. Tsirkin" <mst@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, linux-nvme@lists.infradead.org, virtualization@lists.linux-foundation.org, Keith Busch <keith.busch@intel.com>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Christoph Hellwig <hch@infradead.org>, Shaohua Li <shli@kernel.org>, Nitin Gupta <ngupta@vflare.org>, famz@redhat.com, Jiri Kosina <jikos@kernel.org>, linux-block@vger.kernel.org, "Ed L. Cashin" <ed.cashin@acm.org>, Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>, linux-mmc@vger.kernel.org, Minchan Kim <minchan@kernel.org>, linux-mtd@lists.infradead.org, Brian Norris <computersforpeace@gmail.com>, linuxppc-dev@lists.ozlabs.org
List-Id: linux-raid.ids

The parameter will be used to control whether add_disk should generate
the KOBJ_ADD uevent already.

Signed-off-by: Fam Zheng <famz@redhat.com>
---
 arch/m68k/emu/nfblock.c                     | 2 +-
 arch/powerpc/sysdev/axonram.c               | 2 +-
 arch/um/drivers/ubd_kern.c                  | 2 +-
 arch/xtensa/platforms/iss/simdisk.c         | 2 +-
 block/genhd.c                               | 3 ++-
 drivers/block/DAC960.c                      | 2 +-
 drivers/block/amiflop.c                     | 2 +-
 drivers/block/aoe/aoeblk.c                  | 2 +-
 drivers/block/ataflop.c                     | 2 +-
 drivers/block/brd.c                         | 4 ++--
 drivers/block/cciss.c                       | 2 +-
 drivers/block/drbd/drbd_main.c              | 2 +-
 drivers/block/floppy.c                      | 2 +-
 drivers/block/hd.c                          | 2 +-
 drivers/block/loop.c                        | 2 +-
 drivers/block/mg_disk.c                     | 2 +-
 drivers/block/mtip32xx/mtip32xx.c           | 2 +-
 drivers/block/nbd.c                         | 2 +-
 drivers/block/null_blk.c                    | 2 +-
 drivers/block/osdblk.c                      | 2 +-
 drivers/block/paride/pcd.c                  | 2 +-
 drivers/block/paride/pd.c                   | 2 +-
 drivers/block/paride/pf.c                   | 2 +-
 drivers/block/pktcdvd.c                     | 2 +-
 drivers/block/ps3disk.c                     | 2 +-
 drivers/block/ps3vram.c                     | 2 +-
 drivers/block/rbd.c                         | 2 +-
 drivers/block/rsxx/dev.c                    | 2 +-
 drivers/block/skd_main.c                    | 2 +-
 drivers/block/sunvdc.c                      | 2 +-
 drivers/block/swim.c                        | 2 +-
 drivers/block/swim3.c                       | 2 +-
 drivers/block/sx8.c                         | 2 +-
 drivers/block/umem.c                        | 2 +-
 drivers/block/virtio_blk.c                  | 2 +-
 drivers/block/xen-blkfront.c                | 2 +-
 drivers/block/xsysace.c                     | 2 +-
 drivers/block/z2ram.c                       | 2 +-
 drivers/block/zram/zram_drv.c               | 2 +-
 drivers/cdrom/gdrom.c                       | 2 +-
 drivers/ide/ide-cd.c                        | 2 +-
 drivers/ide/ide-gd.c                        | 2 +-
 drivers/lightnvm/core.c                     | 2 +-
 drivers/md/bcache/super.c                   | 4 ++--
 drivers/md/dm.c                             | 2 +-
 drivers/md/md.c                             | 2 +-
 drivers/memstick/core/ms_block.c            | 2 +-
 drivers/memstick/core/mspro_block.c         | 2 +-
 drivers/mmc/card/block.c                    | 2 +-
 drivers/mtd/mtd_blkdevs.c                   | 2 +-
 drivers/mtd/ubi/block.c                     | 2 +-
 drivers/nvdimm/blk.c                        | 2 +-
 drivers/nvdimm/btt.c                        | 2 +-
 drivers/nvdimm/pmem.c                       | 2 +-
 drivers/nvme/host/core.c                    | 2 +-
 drivers/s390/block/dasd_genhd.c             | 2 +-
 drivers/s390/block/dcssblk.c                | 2 +-
 drivers/s390/block/scm_blk.c                | 2 +-
 drivers/s390/block/xpram.c                  | 2 +-
 drivers/sbus/char/jsflash.c                 | 2 +-
 drivers/scsi/sd.c                           | 2 +-
 drivers/scsi/sr.c                           | 2 +-
 drivers/staging/lustre/lustre/llite/lloop.c | 2 +-
 include/linux/genhd.h                       | 2 +-
 64 files changed, 67 insertions(+), 66 deletions(-)

diff --git a/arch/m68k/emu/nfblock.c b/arch/m68k/emu/nfblock.c
index e9110b9..4252568 100644
--- a/arch/m68k/emu/nfblock.c
+++ b/arch/m68k/emu/nfblock.c
@@ -138,7 +138,7 @@ static int __init nfhd_init_one(int id, u32 blocks, u32 bsize)
 	set_capacity(dev->disk, (sector_t)blocks * (bsize / 512));
 	dev->disk->queue = dev->queue;
 
-	add_disk(dev->disk);
+	add_disk(dev->disk, true);
 
 	list_add_tail(&dev->list, &nfhd_list);
 
diff --git a/arch/powerpc/sysdev/axonram.c b/arch/powerpc/sysdev/axonram.c
index ff75d70..4efd69b 100644
--- a/arch/powerpc/sysdev/axonram.c
+++ b/arch/powerpc/sysdev/axonram.c
@@ -238,7 +238,7 @@ static int axon_ram_probe(struct platform_device *device)
 	set_capacity(bank->disk, bank->size >> AXON_RAM_SECTOR_SHIFT);
 	blk_queue_make_request(bank->disk->queue, axon_ram_make_request);
 	blk_queue_logical_block_size(bank->disk->queue, AXON_RAM_SECTOR_SIZE);
-	add_disk(bank->disk);
+	add_disk(bank->disk, true);
 
 	bank->irq_id = irq_of_parse_and_map(device->dev.of_node, 0);
 	if (bank->irq_id == NO_IRQ) {
diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
index 17e96dc..c2eea65 100644
--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -828,7 +828,7 @@ static int ubd_disk_register(int major, u64 size, int unit,
 
 	disk->private_data = &ubd_devs[unit];
 	disk->queue = ubd_devs[unit].queue;
-	add_disk(disk);
+	add_disk(disk, true);
 
 	*disk_out = disk;
 	return 0;
diff --git a/arch/xtensa/platforms/iss/simdisk.c b/arch/xtensa/platforms/iss/simdisk.c
index f58a4e6..59951a5 100644
--- a/arch/xtensa/platforms/iss/simdisk.c
+++ b/arch/xtensa/platforms/iss/simdisk.c
@@ -288,7 +288,7 @@ static int __init simdisk_setup(struct simdisk *dev, int which,
 	dev->gd->private_data = dev;
 	snprintf(dev->gd->disk_name, 32, "simdisk%d", which);
 	set_capacity(dev->gd, 0);
-	add_disk(dev->gd);
+	add_disk(dev->gd, true);
 
 	dev->procfile = proc_create_data(tmp, 0644, procdir, &fops, dev);
 	return 0;
diff --git a/block/genhd.c b/block/genhd.c
index 9f42526..8e1bfa1 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -575,13 +575,14 @@ exit:
 /**
  * add_disk - add partitioning information to kernel list
  * @disk: per-device partitioning information
+ * @gen_uevent: whether to generate the KOBJ_ADD uevent
  *
  * This function registers the partitioning information in @disk
  * with the kernel.
  *
  * FIXME: error handling
  */
-void add_disk(struct gendisk *disk)
+void add_disk(struct gendisk *disk, bool gen_uevent)
 {
 	struct backing_dev_info *bdi;
 	dev_t devt;
diff --git a/drivers/block/DAC960.c b/drivers/block/DAC960.c
index 811e11c..c18fc2c 100644
--- a/drivers/block/DAC960.c
+++ b/drivers/block/DAC960.c
@@ -3175,7 +3175,7 @@ DAC960_Probe(struct pci_dev *dev, const struct pci_device_id *entry)
 
   for (disk = 0; disk < DAC960_MaxLogicalDrives; disk++) {
         set_capacity(Controller->disks[disk], disk_size(Controller, disk));
-        add_disk(Controller->disks[disk]);
+        add_disk(Controller->disks[disk], true);
   }
   DAC960_CreateProcEntries(Controller);
   return 0;
diff --git a/drivers/block/amiflop.c b/drivers/block/amiflop.c
index 5fd50a2..c226b30 100644
--- a/drivers/block/amiflop.c
+++ b/drivers/block/amiflop.c
@@ -1738,7 +1738,7 @@ static int __init fd_probe_drives(void)
 		sprintf(disk->disk_name, "fd%d", drive);
 		disk->private_data = &unit[drive];
 		set_capacity(disk, 880*2);
-		add_disk(disk);
+		add_disk(disk, true);
 	}
 	if ((drives > 0) || (nomem == 0)) {
 		if (drives == 0)
diff --git a/drivers/block/aoe/aoeblk.c b/drivers/block/aoe/aoeblk.c
index ec9d861..e91c5f1 100644
--- a/drivers/block/aoe/aoeblk.c
+++ b/drivers/block/aoe/aoeblk.c
@@ -417,7 +417,7 @@ aoeblk_gdalloc(void *vp)
 
 	spin_unlock_irqrestore(&d->lock, flags);
 
-	add_disk(gd);
+	add_disk(gd, true);
 	aoedisk_add_sysfs(d);
 	aoedisk_add_debugfs(d);
 
diff --git a/drivers/block/ataflop.c b/drivers/block/ataflop.c
index 2104b1b..0feae71 100644
--- a/drivers/block/ataflop.c
+++ b/drivers/block/ataflop.c
@@ -1969,7 +1969,7 @@ static int __init atari_floppy_init (void)
 		if (!unit[i].disk->queue)
 			goto Enomem;
 		set_capacity(unit[i].disk, MAX_DISK_SIZE * 2);
-		add_disk(unit[i].disk);
+		add_disk(unit[i].disk, true);
 	}
 
 	blk_register_region(MKDEV(FLOPPY_MAJOR, 0), 256, THIS_MODULE,
diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index c04bd9b..7101343 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -552,7 +552,7 @@ static struct brd_device *brd_init_one(int i, bool *new)
 
 	brd = brd_alloc(i);
 	if (brd) {
-		add_disk(brd->brd_disk);
+		add_disk(brd->brd_disk, true);
 		list_add_tail(&brd->brd_list, &brd_devices);
 	}
 	*new = true;
@@ -620,7 +620,7 @@ static int __init brd_init(void)
 	/* point of no return */
 
 	list_for_each_entry(brd, &brd_devices, brd_list)
-		add_disk(brd->brd_disk);
+		add_disk(brd->brd_disk, true);
 
 	blk_register_region(MKDEV(RAMDISK_MAJOR, 0), 1UL << MINORBITS,
 				  THIS_MODULE, brd_probe, NULL, NULL);
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 63c2064..ab93075 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1973,7 +1973,7 @@ static int cciss_add_disk(ctlr_info_t *h, struct gendisk *disk,
 	/* allows the interrupt handler to start the queue */
 	wmb();
 	h->drv[drv_index]->queue = disk->queue;
-	add_disk(disk);
+	add_disk(disk, true);
 	return 0;
 
 cleanup_queue:
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 2ba1494..7c54597 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2820,7 +2820,7 @@ enum drbd_ret_code drbd_create_device(struct drbd_config_context *adm_ctx, unsig
 		goto out_idr_remove_vol;
 	}
 
-	add_disk(disk);
+	add_disk(disk, true);
 
 	/* inherit the connection state */
 	device->state.conn = first_connection(resource)->cstate;
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 84708a5..228e8f7 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4350,7 +4350,7 @@ static int __init do_floppy_init(void)
 		disks[drive]->private_data = (void *)(long)drive;
 		disks[drive]->flags |= GENHD_FL_REMOVABLE;
 		disks[drive]->driverfs_dev = &floppy_device[drive].dev;
-		add_disk(disks[drive]);
+		add_disk(disks[drive], true);
 	}
 
 	return 0;
diff --git a/drivers/block/hd.c b/drivers/block/hd.c
index 3abb121..6751c42 100644
--- a/drivers/block/hd.c
+++ b/drivers/block/hd.c
@@ -767,7 +767,7 @@ static int __init hd_init(void)
 
 	/* Let them fly */
 	for (drive = 0; drive < NR_HD; drive++)
-		add_disk(hd_gendisk[drive]);
+		add_disk(hd_gendisk[drive], true);
 
 	return 0;
 
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 1fa8cc2..3223a23 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1800,7 +1800,7 @@ static int loop_add(struct loop_device **l, int i)
 	disk->private_data	= lo;
 	disk->queue		= lo->lo_queue;
 	sprintf(disk->disk_name, "loop%d", i);
-	add_disk(disk);
+	add_disk(disk, true);
 	*l = lo;
 	return lo->lo_number;
 
diff --git a/drivers/block/mg_disk.c b/drivers/block/mg_disk.c
index 145ce2a..9def46b 100644
--- a/drivers/block/mg_disk.c
+++ b/drivers/block/mg_disk.c
@@ -1009,7 +1009,7 @@ static int mg_probe(struct platform_device *plat_dev)
 
 	set_capacity(host->gd, host->n_sectors);
 
-	add_disk(host->gd);
+	add_disk(host->gd, true);
 
 	return err;
 
diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 6053e46..2d09fae 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -4042,7 +4042,7 @@ skip_create_disk:
 	set_capacity(dd->disk, capacity);
 
 	/* Enable the block device and add it to /dev */
-	add_disk(dd->disk);
+	add_disk(dd->disk, true);
 
 	dd->bdev = bdget_disk(dd->disk, 0);
 	/*
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 6a48ed4..4d011c1 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -1089,7 +1089,7 @@ static int __init nbd_init(void)
 		disk->private_data = &nbd_dev[i];
 		sprintf(disk->disk_name, "nbd%d", i);
 		nbd_reset(&nbd_dev[i]);
-		add_disk(disk);
+		add_disk(disk, true);
 	}
 
 	return 0;
diff --git a/drivers/block/null_blk.c b/drivers/block/null_blk.c
index cab9759..bc4c495 100644
--- a/drivers/block/null_blk.c
+++ b/drivers/block/null_blk.c
@@ -740,7 +740,7 @@ static int null_add_dev(void)
 	disk->queue		= nullb->q;
 	strncpy(disk->disk_name, nullb->disk_name, DISK_NAME_LEN);
 
-	add_disk(disk);
+	add_disk(disk, true);
 
 done:
 	mutex_lock(&lock);
diff --git a/drivers/block/osdblk.c b/drivers/block/osdblk.c
index c2854a2..5a750e2 100644
--- a/drivers/block/osdblk.c
+++ b/drivers/block/osdblk.c
@@ -448,7 +448,7 @@ static int osdblk_init_disk(struct osdblk_device *osdev)
 
 	/* finally, announce the disk to the world */
 	set_capacity(disk, obj_size / 512ULL);
-	add_disk(disk);
+	add_disk(disk, true);
 
 	printk(KERN_INFO "%s: Added of size 0x%llx\n",
 		disk->disk_name, (unsigned long long)obj_size);
diff --git a/drivers/block/paride/pcd.c b/drivers/block/paride/pcd.c
index 9336236..9d03cbe 100644
--- a/drivers/block/paride/pcd.c
+++ b/drivers/block/paride/pcd.c
@@ -970,7 +970,7 @@ static int __init pcd_init(void)
 			register_cdrom(&cd->info);
 			cd->disk->private_data = cd;
 			cd->disk->queue = pcd_queue;
-			add_disk(cd->disk);
+			add_disk(cd->disk, true);
 		}
 	}
 
diff --git a/drivers/block/paride/pd.c b/drivers/block/paride/pd.c
index 78a39f7..da45f07 100644
--- a/drivers/block/paride/pd.c
+++ b/drivers/block/paride/pd.c
@@ -906,7 +906,7 @@ static int pd_detect(void)
 	for (unit = 0, disk = pd; unit < PD_UNITS; unit++, disk++) {
 		if (disk->gd) {
 			set_capacity(disk->gd, disk->capacity);
-			add_disk(disk->gd);
+			add_disk(disk->gd, true);
 			found = 1;
 		}
 	}
diff --git a/drivers/block/paride/pf.c b/drivers/block/paride/pf.c
index 7a7d977..9b7f885 100644
--- a/drivers/block/paride/pf.c
+++ b/drivers/block/paride/pf.c
@@ -989,7 +989,7 @@ static int __init pf_init(void)
 			continue;
 		disk->private_data = pf;
 		disk->queue = pf_queue;
-		add_disk(disk);
+		add_disk(disk, true);
 	}
 	return 0;
 }
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index d06c62e..00928406 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -2785,7 +2785,7 @@ static int pkt_setup_dev(dev_t dev, dev_t* pkt_dev)
 	disk->events = pd->bdev->bd_disk->events;
 	disk->async_events = pd->bdev->bd_disk->async_events;
 
-	add_disk(disk);
+	add_disk(disk, true);
 
 	pkt_sysfs_dev_new(pd);
 	pkt_debugfs_dev_new(pd);
diff --git a/drivers/block/ps3disk.c b/drivers/block/ps3disk.c
index 4b7e405..bd72d79 100644
--- a/drivers/block/ps3disk.c
+++ b/drivers/block/ps3disk.c
@@ -499,7 +499,7 @@ static int ps3disk_probe(struct ps3_system_bus_device *_dev)
 		 gendisk->disk_name, priv->model, priv->raw_capacity >> 11,
 		 get_capacity(gendisk) >> 11);
 
-	add_disk(gendisk);
+	add_disk(gendisk, true);
 	return 0;
 
 fail_cleanup_queue:
diff --git a/drivers/block/ps3vram.c b/drivers/block/ps3vram.c
index 56847fc..ab6acc5 100644
--- a/drivers/block/ps3vram.c
+++ b/drivers/block/ps3vram.c
@@ -780,7 +780,7 @@ static int ps3vram_probe(struct ps3_system_bus_device *dev)
 	dev_info(&dev->core, "%s: Using %lu MiB of GPU memory\n",
 		 gendisk->disk_name, get_capacity(gendisk) >> 11);
 
-	add_disk(gendisk);
+	add_disk(gendisk, true);
 	return 0;
 
 fail_cleanup_queue:
diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 81666a5..bee01ae 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -5158,7 +5158,7 @@ static int rbd_dev_device_setup(struct rbd_device *rbd_dev)
 	set_bit(RBD_DEV_FLAG_EXISTS, &rbd_dev->flags);
 	up_write(&rbd_dev->header_rwsem);
 
-	add_disk(rbd_dev->disk);
+	add_disk(rbd_dev->disk, true);
 	pr_info("%s: added with size 0x%llx\n", rbd_dev->disk->disk_name,
 		(unsigned long long) rbd_dev->mapping.size);
 
diff --git a/drivers/block/rsxx/dev.c b/drivers/block/rsxx/dev.c
index e1b8b70..b4dc913 100644
--- a/drivers/block/rsxx/dev.c
+++ b/drivers/block/rsxx/dev.c
@@ -230,7 +230,7 @@ int rsxx_attach_dev(struct rsxx_cardinfo *card)
 			set_capacity(card->gendisk, card->size8 >> 9);
 		else
 			set_capacity(card->gendisk, 0);
-		add_disk(card->gendisk);
+		add_disk(card->gendisk, true);
 
 		card->bdev_attached = 1;
 	}
diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c
index 910e065..a7de9bb 100644
--- a/drivers/block/skd_main.c
+++ b/drivers/block/skd_main.c
@@ -4693,7 +4693,7 @@ static int skd_bdev_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 static int skd_bdev_attach(struct skd_device *skdev)
 {
 	pr_debug("%s:%s:%d add_disk\n", skdev->name, __func__, __LINE__);
-	add_disk(skdev->disk);
+	add_disk(skdev->disk, true);
 	return 0;
 }
 
diff --git a/drivers/block/sunvdc.c b/drivers/block/sunvdc.c
index 4b911ed..c762c31 100644
--- a/drivers/block/sunvdc.c
+++ b/drivers/block/sunvdc.c
@@ -835,7 +835,7 @@ static int probe_disk(struct vdc_port *port)
 	       port->vdisk_size, (port->vdisk_size >> (20 - 9)),
 	       port->vio.ver.major, port->vio.ver.minor);
 
-	add_disk(g);
+	add_disk(g, true);
 
 	return 0;
 }
diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index b5afd49..c1ff0ee 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -858,7 +858,7 @@ static int swim_floppy_init(struct swim_priv *swd)
 		swd->unit[drive].disk->private_data = &swd->unit[drive];
 		swd->unit[drive].disk->queue = swd->queue;
 		set_capacity(swd->unit[drive].disk, 2880);
-		add_disk(swd->unit[drive].disk);
+		add_disk(swd->unit[drive].disk, true);
 	}
 
 	blk_register_region(MKDEV(FLOPPY_MAJOR, 0), 256, THIS_MODULE,
diff --git a/drivers/block/swim3.c b/drivers/block/swim3.c
index c264f2d..6940593 100644
--- a/drivers/block/swim3.c
+++ b/drivers/block/swim3.c
@@ -1240,7 +1240,7 @@ static int swim3_attach(struct macio_dev *mdev,
 	disk->flags |= GENHD_FL_REMOVABLE;
 	sprintf(disk->disk_name, "fd%d", index);
 	set_capacity(disk, 2880);
-	add_disk(disk);
+	add_disk(disk, true);
 
 	return 0;
 }
diff --git a/drivers/block/sx8.c b/drivers/block/sx8.c
index ba4bfe9..ed285f0 100644
--- a/drivers/block/sx8.c
+++ b/drivers/block/sx8.c
@@ -1333,7 +1333,7 @@ static void carm_fsm_task (struct work_struct *work)
 				struct gendisk *disk = port->disk;
 
 				set_capacity(disk, port->capacity);
-				add_disk(disk);
+				add_disk(disk, true);
 				activated++;
 			}
 
diff --git a/drivers/block/umem.c b/drivers/block/umem.c
index 7939b9f..5f6ed17 100644
--- a/drivers/block/umem.c
+++ b/drivers/block/umem.c
@@ -1098,7 +1098,7 @@ static int __init mm_init(void)
 		disk->private_data = &cards[i];
 		disk->queue = cards[i].queue;
 		set_capacity(disk, cards[i].mm_size << 1);
-		add_disk(disk);
+		add_disk(disk, true);
 	}
 
 	init_battery_timer();
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 42758b5..f3a59f9 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -733,7 +733,7 @@ static int virtblk_probe(struct virtio_device *vdev)
 
 	virtio_device_ready(vdev);
 
-	add_disk(vblk->disk);
+	add_disk(vblk->disk, true);
 	err = device_create_file(disk_to_dev(vblk->disk), &dev_attr_serial);
 	if (err)
 		goto out_del_disk;
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 2e6d1e9..175983a 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -2452,7 +2452,7 @@ static void blkfront_connect(struct blkfront_info *info)
 	for (i = 0; i < info->nr_rings; i++)
 		kick_pending_request_queues(&info->rinfo[i]);
 
-	add_disk(info->gd);
+	add_disk(info->gd, true);
 
 	info->is_ready = 1;
 }
diff --git a/drivers/block/xsysace.c b/drivers/block/xsysace.c
index c4328d9..7e060e0 100644
--- a/drivers/block/xsysace.c
+++ b/drivers/block/xsysace.c
@@ -1057,7 +1057,7 @@ static int ace_setup(struct ace_device *ace)
 	ace_revalidate_disk(ace->gd);
 
 	/* Make the sysace device 'live' */
-	add_disk(ace->gd);
+	add_disk(ace->gd, true);
 
 	return 0;
 
diff --git a/drivers/block/z2ram.c b/drivers/block/z2ram.c
index 968f9e5..91ccbfb 100644
--- a/drivers/block/z2ram.c
+++ b/drivers/block/z2ram.c
@@ -364,7 +364,7 @@ z2_init(void)
     sprintf(z2ram_gendisk->disk_name, "z2ram");
 
     z2ram_gendisk->queue = z2_queue;
-    add_disk(z2ram_gendisk);
+    add_disk(z2ram_gendisk, true);
     blk_register_region(MKDEV(Z2RAM_MAJOR, 0), Z2MINOR_COUNT, THIS_MODULE,
 				z2_find, NULL, NULL);
 
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 8fcad8b..d735513 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1287,7 +1287,7 @@ static int zram_add(void)
 		zram->disk->queue->limits.discard_zeroes_data = 0;
 	queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, zram->disk->queue);
 
-	add_disk(zram->disk);
+	add_disk(zram->disk, true);
 
 	ret = sysfs_create_group(&disk_to_dev(zram->disk)->kobj,
 				&zram_disk_attr_group);
diff --git a/drivers/cdrom/gdrom.c b/drivers/cdrom/gdrom.c
index 584bc31..25403ee 100644
--- a/drivers/cdrom/gdrom.c
+++ b/drivers/cdrom/gdrom.c
@@ -817,7 +817,7 @@ static int probe_gdrom(struct platform_device *devptr)
 	gd.toc = kzalloc(sizeof(struct gdromtoc), GFP_KERNEL);
 	if (!gd.toc)
 		goto probe_fail_toc;
-	add_disk(gd.disk);
+	add_disk(gd.disk, true);
 	return 0;
 
 probe_fail_toc:
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index ef907fd..39125d0 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1780,7 +1780,7 @@ static int ide_cd_probe(ide_drive_t *drive)
 	ide_cd_read_toc(drive, &sense);
 	g->fops = &idecd_ops;
 	g->flags |= GENHD_FL_REMOVABLE | GENHD_FL_BLOCK_EVENTS_ON_EXCL_WRITE;
-	add_disk(g);
+	add_disk(g, true);
 	return 0;
 
 out_free_disk:
diff --git a/drivers/ide/ide-gd.c b/drivers/ide/ide-gd.c
index 838996a..6a82457 100644
--- a/drivers/ide/ide-gd.c
+++ b/drivers/ide/ide-gd.c
@@ -417,7 +417,7 @@ static int ide_gd_probe(ide_drive_t *drive)
 	if (drive->dev_flags & IDE_DFLAG_REMOVABLE)
 		g->flags = GENHD_FL_REMOVABLE;
 	g->fops = &ide_gd_ops;
-	add_disk(g);
+	add_disk(g, true);
 	return 0;
 
 out_free_disk:
diff --git a/drivers/lightnvm/core.c b/drivers/lightnvm/core.c
index 160c1a6..392886c 100644
--- a/drivers/lightnvm/core.c
+++ b/drivers/lightnvm/core.c
@@ -843,7 +843,7 @@ static int nvm_create_target(struct nvm_dev *dev,
 	blk_queue_max_hw_sectors(tqueue, 8 * dev->ops->max_phys_sect);
 
 	set_capacity(tdisk, tt->capacity(targetdata));
-	add_disk(tdisk);
+	add_disk(tdisk, true);
 
 	t->type = tt;
 	t->disk = tdisk;
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index f5dbb4e..ecb401c 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -865,7 +865,7 @@ void bch_cached_dev_run(struct cached_dev *dc)
 		closure_sync(&cl);
 	}
 
-	add_disk(d->disk);
+	add_disk(d->disk, true);
 	bd_link_disk_holder(dc->bdev, dc->disk.disk);
 	/* won't show up in the uevent file, use udevadm monitor -e instead
 	 * only class / kset properties are persistent */
@@ -1228,7 +1228,7 @@ static int flash_dev_run(struct cache_set *c, struct uuid_entry *u)
 
 	bcache_device_attach(d, c, u - c->uuids);
 	bch_flash_dev_request_init(d);
-	add_disk(d->disk);
+	add_disk(d->disk, true);
 
 	if (kobject_add(&d->kobj, &disk_to_dev(d->disk)->kobj, "bcache"))
 		goto err;
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 1b2f962..ad48d4e 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2399,7 +2399,7 @@ static struct mapped_device *alloc_dev(int minor)
 	md->disk->queue = md->queue;
 	md->disk->private_data = md;
 	sprintf(md->disk->disk_name, "dm-%d", minor);
-	add_disk(md->disk);
+	add_disk(md->disk, true);
 	format_dev_t(md->name, MKDEV(_major, minor));
 
 	md->wq = alloc_workqueue("kdmflush", WQ_MEM_RECLAIM, 0);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 866825f..1391c72 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5055,7 +5055,7 @@ static int md_alloc(dev_t dev, char *name)
 	 * through to md_open, so make sure it doesn't get too far
 	 */
 	mutex_lock(&mddev->open_mutex);
-	add_disk(disk);
+	add_disk(disk, true);
 
 	error = kobject_init_and_add(&mddev->kobj, &md_ktype,
 				     &disk_to_dev(disk)->kobj, "%s", "md");
diff --git a/drivers/memstick/core/ms_block.c b/drivers/memstick/core/ms_block.c
index 3cd6815..9fe45ba 100644
--- a/drivers/memstick/core/ms_block.c
+++ b/drivers/memstick/core/ms_block.c
@@ -2163,7 +2163,7 @@ static int msb_init_disk(struct memstick_dev *card)
 		set_disk_ro(msb->disk, 1);
 
 	msb_start(card);
-	add_disk(msb->disk);
+	add_disk(msb->disk, true);
 	dbg("Disk added");
 	return 0;
 
diff --git a/drivers/memstick/core/mspro_block.c b/drivers/memstick/core/mspro_block.c
index 0fb27d3..cd4e16d 100644
--- a/drivers/memstick/core/mspro_block.c
+++ b/drivers/memstick/core/mspro_block.c
@@ -1255,7 +1255,7 @@ static int mspro_block_init_disk(struct memstick_dev *card)
 	set_capacity(msb->disk, capacity);
 	dev_dbg(&card->dev, "capacity set %ld\n", capacity);
 
-	add_disk(msb->disk);
+	add_disk(msb->disk, true);
 	msb->active = 1;
 	return 0;
 
diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index e62fde3..94cf51e 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -2457,7 +2457,7 @@ static int mmc_add_disk(struct mmc_blk_data *md)
 	int ret;
 	struct mmc_card *card = md->queue.card;
 
-	add_disk(md->disk);
+	add_disk(md->disk, true);
 	md->force_ro.show = force_ro_show;
 	md->force_ro.store = force_ro_store;
 	sysfs_attr_init(&md->force_ro.attr);
diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index 74ae243..ab3bc22 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -436,7 +436,7 @@ int add_mtd_blktrans_dev(struct mtd_blktrans_dev *new)
 	if (new->readonly)
 		set_disk_ro(gd, 1);
 
-	add_disk(gd);
+	add_disk(gd, true);
 
 	if (new->disk_attributes) {
 		ret = sysfs_create_group(&disk_to_dev(gd)->kobj,
diff --git a/drivers/mtd/ubi/block.c b/drivers/mtd/ubi/block.c
index ebf46ad..125716d 100644
--- a/drivers/mtd/ubi/block.c
+++ b/drivers/mtd/ubi/block.c
@@ -445,7 +445,7 @@ int ubiblock_create(struct ubi_volume_info *vi)
 	mutex_unlock(&devices_mutex);
 
 	/* Must be the last step: anyone can call file ops from now on */
-	add_disk(dev->gd);
+	add_disk(dev->gd, true);
 	dev_info(disk_to_dev(dev->gd), "created from ubi%d:%d(%s)",
 		 dev->ubi_num, dev->vol_id, vi->name);
 	return 0;
diff --git a/drivers/nvdimm/blk.c b/drivers/nvdimm/blk.c
index 495e06d9..0175c6c 100644
--- a/drivers/nvdimm/blk.c
+++ b/drivers/nvdimm/blk.c
@@ -294,7 +294,7 @@ static int nsblk_attach_disk(struct nd_namespace_blk *nsblk)
 	disk->flags		= GENHD_FL_EXT_DEVT;
 	nvdimm_namespace_disk_name(&nsblk->common, disk->disk_name);
 	set_capacity(disk, 0);
-	add_disk(disk);
+	add_disk(disk, true);
 
 	if (nsblk_meta_size(nsblk)) {
 		int rc = nd_integrity_init(disk, nsblk_meta_size(nsblk));
diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index 68a7c3c..4a54a92 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -1258,7 +1258,7 @@ static int btt_blk_init(struct btt *btt)
 	btt->btt_queue->queuedata = btt;
 
 	set_capacity(btt->btt_disk, 0);
-	add_disk(btt->btt_disk);
+	add_disk(btt->btt_disk, true);
 	if (btt_meta_size(btt)) {
 		int rc = nd_integrity_init(btt->btt_disk, btt_meta_size(btt));
 
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 608fc44..b23a946 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -304,7 +304,7 @@ static int pmem_attach_disk(struct device *dev,
 		return -ENOMEM;
 	nvdimm_badblocks_populate(to_nd_region(dev->parent), &pmem->bb, res);
 	disk->bb = &pmem->bb;
-	add_disk(disk);
+	add_disk(disk, true);
 	revalidate_disk(disk);
 
 	return 0;
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 1a51584..fd70894 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1462,7 +1462,7 @@ static void nvme_alloc_ns(struct nvme_ctrl *ctrl, unsigned nsid)
 	if (ns->type == NVME_NS_LIGHTNVM)
 		return;
 
-	add_disk(ns->disk);
+	add_disk(ns->disk, true);
 	if (sysfs_create_group(&disk_to_dev(ns->disk)->kobj,
 					&nvme_ns_attr_group))
 		pr_warn("%s: failed to create sysfs group for identification\n",
diff --git a/drivers/s390/block/dasd_genhd.c b/drivers/s390/block/dasd_genhd.c
index 31d544a..5db81d5 100644
--- a/drivers/s390/block/dasd_genhd.c
+++ b/drivers/s390/block/dasd_genhd.c
@@ -76,7 +76,7 @@ int dasd_gendisk_alloc(struct dasd_block *block)
 	gdp->queue = block->request_queue;
 	block->gdp = gdp;
 	set_capacity(block->gdp, 0);
-	add_disk(block->gdp);
+	add_disk(block->gdp, true);
 	return 0;
 }
 
diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index bed53c4..63a6fba 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -655,7 +655,7 @@ dcssblk_add_store(struct device *dev, struct device_attribute *attr, const char
 		goto put_dev;
 
 	get_device(&dev_info->dev);
-	add_disk(dev_info->gd);
+	add_disk(dev_info->gd, true);
 
 	switch (dev_info->segment_type) {
 		case SEG_TYPE_SR:
diff --git a/drivers/s390/block/scm_blk.c b/drivers/s390/block/scm_blk.c
index e6f54d3..c3110e0 100644
--- a/drivers/s390/block/scm_blk.c
+++ b/drivers/s390/block/scm_blk.c
@@ -531,7 +531,7 @@ int scm_blk_dev_setup(struct scm_blk_dev *bdev, struct scm_device *scmdev)
 
 	/* 512 byte sectors */
 	set_capacity(bdev->gendisk, scmdev->size >> 9);
-	add_disk(bdev->gendisk);
+	add_disk(bdev->gendisk, true);
 	return 0;
 
 out_queue:
diff --git a/drivers/s390/block/xpram.c b/drivers/s390/block/xpram.c
index 288f59a..e18c58c 100644
--- a/drivers/s390/block/xpram.c
+++ b/drivers/s390/block/xpram.c
@@ -377,7 +377,7 @@ static int __init xpram_setup_blkdev(void)
 		disk->queue = xpram_queues[i];
 		sprintf(disk->disk_name, "slram%d", i);
 		set_capacity(disk, xpram_sizes[i] << 1);
-		add_disk(disk);
+		add_disk(disk, true);
 	}
 
 	return 0;
diff --git a/drivers/sbus/char/jsflash.c b/drivers/sbus/char/jsflash.c
index a40ee1e..d45e193 100644
--- a/drivers/sbus/char/jsflash.c
+++ b/drivers/sbus/char/jsflash.c
@@ -590,7 +590,7 @@ static int jsfd_init(void)
 		set_capacity(disk, jdp->dsize >> 9);
 		disk->private_data = jdp;
 		disk->queue = jsf_queue;
-		add_disk(disk);
+		add_disk(disk, true);
 		set_disk_ro(disk, 1);
 	}
 	return 0;
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 60bff78..35515a2 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2996,7 +2996,7 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
 	}
 
 	blk_pm_runtime_init(sdp->request_queue, dev);
-	add_disk(gd);
+	add_disk(gd, true);
 	if (sdkp->capacity)
 		sd_dif_config_host(sdkp);
 
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 64c8674..57ea120 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -730,7 +730,7 @@ static int sr_probe(struct device *dev)
 
 	dev_set_drvdata(dev, cd);
 	disk->flags |= GENHD_FL_REMOVABLE;
-	add_disk(disk);
+	add_disk(disk, true);
 
 	sdev_printk(KERN_DEBUG, sdev,
 		    "Attached scsi CD-ROM %s\n", cd->cdi.name);
diff --git a/drivers/staging/lustre/lustre/llite/lloop.c b/drivers/staging/lustre/lustre/llite/lloop.c
index 813a9a3..748f6fd 100644
--- a/drivers/staging/lustre/lustre/llite/lloop.c
+++ b/drivers/staging/lustre/lustre/llite/lloop.c
@@ -835,7 +835,7 @@ static int __init lloop_init(void)
 
 	/* We cannot fail after we call this, so another loop!*/
 	for (i = 0; i < max_loop; i++)
-		add_disk(disks[i]);
+		add_disk(disks[i], true);
 	return 0;
 
 out_mem4:
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 359a8e4..038be80 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -414,7 +414,7 @@ static inline void free_part_info(struct hd_struct *part)
 extern void part_round_stats(int cpu, struct hd_struct *part);
 
 /* block/genhd.c */
-extern void add_disk(struct gendisk *disk);
+extern void add_disk(struct gendisk *disk, bool gen_uevent);
 extern void del_gendisk(struct gendisk *gp);
 extern struct gendisk *get_gendisk(dev_t dev, int *partno);
 extern struct block_device *bdget_disk(struct gendisk *disk, int partno);
-- 
2.9.0
