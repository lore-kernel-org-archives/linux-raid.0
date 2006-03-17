From: NeilBrown <neilb@suse.de>
Subject: [PATCH 006 of 6] md: Make new function stripe_to_pdidx static.
Date: Fri, 17 Mar 2006 18:21:50 +1100
Message-ID: <1060317072150.28683@suse.de>
References: <20060317181912.28543.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids



Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2006-03-17 18:18:48.000000000 +1100
+++ ./drivers/md/raid5.c	2006-03-17 18:18:50.000000000 +1100
@@ -1037,7 +1037,7 @@ static int add_stripe_bio(struct stripe_
 
 static void end_reshape(raid5_conf_t *conf);
 
-int stripe_to_pdidx(sector_t stripe, raid5_conf_t *conf, int disks)
+static int stripe_to_pdidx(sector_t stripe, raid5_conf_t *conf, int disks)
 {
 	int sectors_per_chunk = conf->chunk_size >> 9;
 	sector_t x = stripe;
