From: NeilBrown <neilb@suse.de>
Subject: [PATCH 005 of 5] md: Fix type that is stopping raid5 grow from working.
Date: Mon, 15 Oct 2007 14:34:49 +1000
Message-ID: <1071015043449.5545@suse.de>
References: <20071015143136.5200.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids


This kmem_cache_create is creating a cache that already exists.  We
could us the alternate name, just like we do a few lines up.

Signed-off-by: Neil Brown <neilb@suse.de>
Cc: "Dan Williams" <dan.j.williams@intel.com>

### Diffstat output
 ./drivers/md/raid5.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2007-10-15 14:12:03.000000000 +1000
+++ ./drivers/md/raid5.c	2007-10-15 14:12:06.000000000 +1000
@@ -1380,7 +1380,7 @@ static int resize_stripes(raid5_conf_t *
 	if (!sc)
 		return -ENOMEM;
 
-	sc_q = kmem_cache_create(conf->sq_cache_name[conf->active_name],
+	sc_q = kmem_cache_create(conf->sq_cache_name[1-conf->active_name],
 			       (sizeof(struct stripe_queue)+(newsize-1) *
 				sizeof(struct r5_queue_dev)) +
 				r5_io_weight_size(newsize) +
