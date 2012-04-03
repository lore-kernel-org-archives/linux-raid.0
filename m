From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 09/10] md/raid10: split out interpretation of layout to
 separate function.
Date: Tue, 03 Apr 2012 15:53:02 +1000
Message-ID: <20120403055302.19495.47473.stgit@notabene.brown>
References: <20120403054656.19495.36380.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120403054656.19495.36380.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

We will soon be interpreting the layout (and chunksize etc) from
multiple places to support reshape.  So split it out into separate
function.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid10.c |   74 ++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 52 insertions(+), 22 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 0a6746f..1f84b8e 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3223,28 +3223,65 @@ raid10_size(struct mddev *mddev, sector_t sectors, int raid_disks)
 	return size << conf->geo.chunk_shift;
 }
 
+enum geo_type {geo_new, geo_old, geo_start};
+static int setup_geo(struct geom *geo, struct mddev *mddev, enum geo_type new)
+{
+	int nc, fc, fo;
+	int layout, chunk, disks;
+	switch (new) {
+	case geo_old:
+		layout = mddev->layout;
+		chunk = mddev->chunk_sectors;
+		disks = mddev->raid_disks - mddev->delta_disks;
+		break;
+	case geo_new:
+		layout = mddev->new_layout;
+		chunk = mddev->new_chunk_sectors;
+		disks = mddev->raid_disks;
+		break;
+	default: /* avoid 'may be unused' warnings */
+	case geo_start: /* new when starting reshape - raid_disks not
+			 * updated yet. */
+		layout = mddev->new_layout;
+		chunk = mddev->new_chunk_sectors;
+		disks = mddev->raid_disks + mddev->delta_disks;
+		break;
+	}
+	if (layout >> 17)
+		return -1;
+	if (chunk < (PAGE_SIZE >> 9) ||
+	    !is_power_of_2(chunk))
+		return -2;
+	nc = layout & 255;
+	fc = (layout >> 8) & 255;
+	fo = layout & (1<<16);
+	geo->raid_disks = disks;
+	geo->near_copies = nc;
+	geo->far_copies = fc;
+	geo->far_offset = fo;
+	geo->chunk_mask = chunk - 1;
+	geo->chunk_shift = ffz(~chunk);
+	return nc*fc;
+}
 
 static struct r10conf *setup_conf(struct mddev *mddev)
 {
 	struct r10conf *conf = NULL;
-	int nc, fc, fo;
 	sector_t stride, size;
 	int err = -EINVAL;
+	struct geom geo;
+	int copies;
+
+	copies = setup_geo(&geo, mddev, geo_new);
 
-	if (mddev->new_chunk_sectors < (PAGE_SIZE >> 9) ||
-	    !is_power_of_2(mddev->new_chunk_sectors)) {
+	if (copies == -2) {
 		printk(KERN_ERR "md/raid10:%s: chunk size must be "
 		       "at least PAGE_SIZE(%ld) and be a power of 2.\n",
 		       mdname(mddev), PAGE_SIZE);
 		goto out;
 	}
 
-	nc = mddev->new_layout & 255;
-	fc = (mddev->new_layout >> 8) & 255;
-	fo = mddev->new_layout & (1<<16);
-
-	if ((nc*fc) <2 || (nc*fc) > mddev->raid_disks ||
-	    (mddev->new_layout >> 17)) {
+	if (copies < 2 || copies > mddev->raid_disks) {
 		printk(KERN_ERR "md/raid10:%s: unsupported raid10 layout: 0x%8x\n",
 		       mdname(mddev), mddev->new_layout);
 		goto out;
@@ -3264,24 +3301,17 @@ static struct r10conf *setup_conf(struct mddev *mddev)
 	if (!conf->tmppage)
 		goto out;
 
-
-	conf->geo.raid_disks = mddev->raid_disks;
-	conf->geo.near_copies = nc;
-	conf->geo.far_copies = fc;
-	conf->copies = nc*fc;
-	conf->geo.far_offset = fo;
-	conf->geo.chunk_mask = mddev->new_chunk_sectors - 1;
-	conf->geo.chunk_shift = ffz(~mddev->new_chunk_sectors);
-
+	conf->geo = geo;
+	conf->copies = copies;
 	conf->r10bio_pool = mempool_create(NR_RAID10_BIOS, r10bio_pool_alloc,
 					   r10bio_pool_free, conf);
 	if (!conf->r10bio_pool)
 		goto out;
 
 	size = mddev->dev_sectors >> conf->geo.chunk_shift;
-	sector_div(size, fc);
+	sector_div(size, geo.far_copies);
 	size = size * conf->geo.raid_disks;
-	sector_div(size, nc);
+	sector_div(size, geo.near_copies);
 	/* 'size' is now the number of chunks in the array */
 	/* calculate "used chunks per device" in 'stride' */
 	stride = size * conf->copies;
@@ -3294,10 +3324,10 @@ static struct r10conf *setup_conf(struct mddev *mddev)
 
 	conf->dev_sectors = stride << conf->geo.chunk_shift;
 
-	if (fo)
+	if (geo.far_offset)
 		stride = 1;
 	else
-		sector_div(stride, fc);
+		sector_div(stride, geo.far_copies);
 	conf->geo.stride = stride << conf->geo.chunk_shift;
 	conf->prev = conf->geo;
 	conf->reshape_progress = MaxSector;


