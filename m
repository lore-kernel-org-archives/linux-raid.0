From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md ] Make sure raid5/raid6 resync uses correct 'max_sectors'
Date: Mon, 01 Aug 2005 14:46:52 +1000
Message-ID: <E1DzSCS-0006um-GO@notabene.cse.unsw.edu.au>
References: <20050801144150.23561.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm putting together a test-suite for mdadm and md (About time), and
it found this bug for me.  Without it, an array creating in just the
right way (i.e. the way that mdadm-v2 creates array) will resync
forever.

It would be good if this went into 2.6.13

Thanks,
NeilBrown


--

The default resync_max_sector is set to "mddev->size << 1".
If the raid-personality-module updates mddev->size, it must
update resync_max_sectors too.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/raid5.c     |    1 +
 ./drivers/md/raid6main.c |    1 +
 2 files changed, 2 insertions(+)

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2005-08-01 14:36:10.000000000 +1000
+++ ./drivers/md/raid5.c	2005-08-01 14:36:10.000000000 +1000
@@ -1653,6 +1653,7 @@ static int run (mddev_t *mddev)
 
 	/* device size must be a multiple of chunk size */
 	mddev->size &= ~(mddev->chunk_size/1024 -1);
+	mddev->resync_max_sectors = mddev->size << 1;
 
 	if (!conf->chunk_size || conf->chunk_size % 4) {
 		printk(KERN_ERR "raid5: invalid chunk size %d for %s\n",

diff ./drivers/md/raid6main.c~current~ ./drivers/md/raid6main.c
--- ./drivers/md/raid6main.c~current~	2005-08-01 14:36:10.000000000 +1000
+++ ./drivers/md/raid6main.c	2005-08-01 14:36:10.000000000 +1000
@@ -1813,6 +1813,7 @@ static int run (mddev_t *mddev)
 
 	/* device size must be a multiple of chunk size */
 	mddev->size &= ~(mddev->chunk_size/1024 -1);
+	mddev->resync_max_sectors = mddev->size << 1;
 
 	if (conf->raid_disks < 4) {
 		printk(KERN_ERR "raid6: not enough configured devices for %s (%d, minimum 4)\n",
