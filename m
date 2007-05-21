From: NeilBrown <neilb@suse.de>
Subject: [PATCH 001 of 7] md: Avoid overflow in raid0 calculation with large components.
Date: Mon, 21 May 2007 11:33:03 +1000
Message-ID: <1070521013303.6655@suse.de>
References: <20070521111837.20906.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Jeff Zheng <Jeff.Zheng@endace.com>, Neil Brown <neilb@suse.de>, stable@kernel.org
List-Id: linux-raid.ids


If a raid0 has a component device larger than 4TB, and is accessed on
a 32bit machines, then as 'chunk' is unsigned lock,
   chunk << chunksize_bits
can overflow (this can be as high as the size of the device in KB).
chunk itself will not overflow (without triggering a BUG).

So change 'chunk' to be 'sector_t, and get rid of the 'BUG' as it becomes
impossible to hit.

Cc: "Jeff Zheng" <Jeff.Zheng@endace.com>
Signed-off-by: Neil Brown <neilb@suse.de>
Cc: stable@kernel.org

### Diffstat output
 ./drivers/md/raid0.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff .prev/drivers/md/raid0.c ./drivers/md/raid0.c
--- .prev/drivers/md/raid0.c	2007-05-18 11:48:57.000000000 +1000
+++ ./drivers/md/raid0.c	2007-05-18 11:48:57.000000000 +1000
@@ -415,7 +415,7 @@ static int raid0_make_request (request_q
 	raid0_conf_t *conf = mddev_to_conf(mddev);
 	struct strip_zone *zone;
 	mdk_rdev_t *tmp_dev;
-	unsigned long chunk;
+	sector_t chunk;
 	sector_t block, rsect;
 	const int rw = bio_data_dir(bio);
 
@@ -470,7 +470,6 @@ static int raid0_make_request (request_q
 
 		sector_div(x, zone->nb_dev);
 		chunk = x;
-		BUG_ON(x != (sector_t)chunk);
 
 		x = block >> chunksize_bits;
 		tmp_dev = zone->dev[sector_div(x, zone->nb_dev)];
