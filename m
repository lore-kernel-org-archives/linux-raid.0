From: NeilBrown <neilb@suse.de>
Subject: [PATCH 001 of 2] md: Fix two raid10 bugs.
Date: Tue, 12 Jun 2007 11:09:29 +1000
Message-ID: <1070612010929.25355@suse.de>
References: <20070612110634.25171.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>, stable@kernel.org
List-Id: linux-raid.ids


1/ When resyncing a degraded raid10 which has more than 2 copies of each block,
  garbage can get synced on top of good data.

2/ We round the wrong way in part of the device size calculation, which
  can cause confusion.

Signed-off-by: Neil Brown <neilb@suse.de>
Cc: stable@kernel.org

### Diffstat output
 ./drivers/md/raid10.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff .prev/drivers/md/raid10.c ./drivers/md/raid10.c
--- .prev/drivers/md/raid10.c	2007-06-12 10:19:04.000000000 +1000
+++ ./drivers/md/raid10.c	2007-06-12 10:20:31.000000000 +1000
@@ -1866,6 +1866,7 @@ static sector_t sync_request(mddev_t *md
 			int d = r10_bio->devs[i].devnum;
 			bio = r10_bio->devs[i].bio;
 			bio->bi_end_io = NULL;
+			clear_bit(BIO_UPTODATE, &bio->bi_flags);
 			if (conf->mirrors[d].rdev == NULL ||
 			    test_bit(Faulty, &conf->mirrors[d].rdev->flags))
 				continue;
@@ -2036,6 +2037,11 @@ static int run(mddev_t *mddev)
 	/* 'size' is now the number of chunks in the array */
 	/* calculate "used chunks per device" in 'stride' */
 	stride = size * conf->copies;
+
+	/* We need to round up when dividing by raid_disks to
+	 * get the stride size.
+	 */
+	stride += conf->raid_disks - 1;
 	sector_div(stride, conf->raid_disks);
 	mddev->size = stride  << (conf->chunk_shift-1);
 
