From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 4 of 8 - Make sure the size of a raid5/6 array is a multiple of the chunk size.
Date: Fri, 28 May 2004 16:45:25 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1BTb7N-0002To-DB@notabene.cse.unsw.edu.au>
References: <20040528163700.9426.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Normally the size is chosen as a multiple of the chunk size,
but if the size is explicitly chosen, it might not be.
So we force it.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

 ----------- Diffstat output ------------
 ./drivers/md/raid5.c     |    3 +++
 ./drivers/md/raid6main.c |    3 +++
 2 files changed, 6 insertions(+)

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2004-05-28 15:48:33.000000000 +1000
+++ ./drivers/md/raid5.c	2004-05-28 15:48:55.000000000 +1000
@@ -1611,6 +1611,9 @@ static int run (mddev_t *mddev)
 	conf->algorithm = mddev->layout;
 	conf->max_nr_stripes = NR_STRIPES;
 
+	/* device size must be a multiple of chunk size */
+	mddev->size &= ~(mddev->chunk_size/1024 -1);
+
 	if (!conf->chunk_size || conf->chunk_size % 4) {
 		printk(KERN_ERR "raid5: invalid chunk size %d for %s\n",
 			conf->chunk_size, mdname(mddev));

diff ./drivers/md/raid6main.c~current~ ./drivers/md/raid6main.c
--- ./drivers/md/raid6main.c~current~	2004-05-28 15:48:33.000000000 +1000
+++ ./drivers/md/raid6main.c	2004-05-28 15:48:55.000000000 +1000
@@ -1775,6 +1775,9 @@ static int run (mddev_t *mddev)
 	conf->algorithm = mddev->layout;
 	conf->max_nr_stripes = NR_STRIPES;
 
+	/* device size must be a multiple of chunk size */
+	mddev->size &= ~(mddev->chunk_size/1024 -1);
+
 	if (conf->raid_disks < 4) {
 		printk(KERN_ERR "raid6: not enough configured devices for %s (%d, minimum 4)\n",
 		       mdname(mddev), conf->raid_disks);
