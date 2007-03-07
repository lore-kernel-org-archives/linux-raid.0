From: Greg KH <gregkh@suse.de>
Subject: [patch 045/101] md: Fix raid10 recovery problem.
Date: Wed, 07 Mar 2007 09:11:20 -0800
Message-ID: <20070307171345.549073334@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1422829AbXCGRP2@vger.kernel.org>
Content-Disposition: inline; filename=md-fix-raid10-recovery-problem.patch
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>, Zwane Mwaikambo <zwane@arm.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>, Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>, Chris Wedgwood <reviews@ml.cw.f00f.org>, Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>, torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk, linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

From: NeilBrown <neilb@suse.de>

There are two errors that can lead to recovery problems with raid10
when used in 'far' more (not the default).

Due to a '>' instead of '>=' the wrong block is located which would
result in garbage being written to some random location, quite
possible outside the range of the device, causing the newly
reconstructed device to fail.

The device size calculation had some rounding errors (it didn't round
when it should) and so recovery would go a few blocks too far which
would again cause a write to a random block address and probably
a device error.

The code for working with device sizes was fairly confused and spread
out, so this has been tided up a bit.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/md/raid10.c |   38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

--- linux-2.6.20.1.orig/drivers/md/raid10.c
+++ linux-2.6.20.1/drivers/md/raid10.c
@@ -429,7 +429,7 @@ static sector_t raid10_find_virt(conf_t 
 		if (dev < 0)
 			dev += conf->raid_disks;
 	} else {
-		while (sector > conf->stride) {
+		while (sector >= conf->stride) {
 			sector -= conf->stride;
 			if (dev < conf->near_copies)
 				dev += conf->raid_disks - conf->near_copies;
@@ -1801,6 +1801,7 @@ static sector_t sync_request(mddev_t *md
 						for (k=0; k<conf->copies; k++)
 							if (r10_bio->devs[k].devnum == i)
 								break;
+						BUG_ON(k == conf->copies);
 						bio = r10_bio->devs[1].bio;
 						bio->bi_next = biolist;
 						biolist = bio;
@@ -2021,19 +2022,30 @@ static int run(mddev_t *mddev)
 	if (!conf->tmppage)
 		goto out_free_conf;
 
+	conf->mddev = mddev;
+	conf->raid_disks = mddev->raid_disks;
 	conf->near_copies = nc;
 	conf->far_copies = fc;
 	conf->copies = nc*fc;
 	conf->far_offset = fo;
 	conf->chunk_mask = (sector_t)(mddev->chunk_size>>9)-1;
 	conf->chunk_shift = ffz(~mddev->chunk_size) - 9;
+	size = mddev->size >> (conf->chunk_shift-1);
+	sector_div(size, fc);
+	size = size * conf->raid_disks;
+	sector_div(size, nc);
+	/* 'size' is now the number of chunks in the array */
+	/* calculate "used chunks per device" in 'stride' */
+	stride = size * conf->copies;
+	sector_div(stride, conf->raid_disks);
+	mddev->size = stride  << (conf->chunk_shift-1);
+
 	if (fo)
-		conf->stride = 1 << conf->chunk_shift;
-	else {
-		stride = mddev->size >> (conf->chunk_shift-1);
+		stride = 1;
+	else
 		sector_div(stride, fc);
-		conf->stride = stride << conf->chunk_shift;
-	}
+	conf->stride = stride << conf->chunk_shift;
+
 	conf->r10bio_pool = mempool_create(NR_RAID10_BIOS, r10bio_pool_alloc,
 						r10bio_pool_free, conf);
 	if (!conf->r10bio_pool) {
@@ -2063,8 +2075,6 @@ static int run(mddev_t *mddev)
 
 		disk->head_position = 0;
 	}
-	conf->raid_disks = mddev->raid_disks;
-	conf->mddev = mddev;
 	spin_lock_init(&conf->device_lock);
 	INIT_LIST_HEAD(&conf->retry_list);
 
@@ -2106,16 +2116,8 @@ static int run(mddev_t *mddev)
 	/*
 	 * Ok, everything is just fine now
 	 */
-	if (conf->far_offset) {
-		size = mddev->size >> (conf->chunk_shift-1);
-		size *= conf->raid_disks;
-		size <<= conf->chunk_shift;
-		sector_div(size, conf->far_copies);
-	} else
-		size = conf->stride * conf->raid_disks;
-	sector_div(size, conf->near_copies);
-	mddev->array_size = size/2;
-	mddev->resync_max_sectors = size;
+	mddev->array_size = size << (conf->chunk_shift-1);
+	mddev->resync_max_sectors = size << conf->chunk_shift;
 
 	mddev->queue->unplug_fn = raid10_unplug;
 	mddev->queue->issue_flush_fn = raid10_issue_flush;

--
