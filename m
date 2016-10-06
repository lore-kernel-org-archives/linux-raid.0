From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 46/54] md/raid10: Less function calls in setup_conf() after
 error detection
Date: Thu, 6 Oct 2016 11:46:15 +0200
Message-ID: <fbf4bcd3-1505-d959-eaa2-f6688a0aec2c@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Guoqing Jiang <gqjiang@suse.com>, Jens Axboe <axboe@fb.com>, Mike Christie <mchristi@redhat.com>, Neil Brown <neilb@suse.com>, Shaohua Li <shli@kernel.org>, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-raid.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 5 Oct 2016 18:32:30 +0200

Resource release functions were called in up to three cases
by the setup_conf() function during error handling even if
the passed data structure members contained a null pointer.

Adjust jump targets according to the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/raid10.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 7e512d4..9b8d11f 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3508,13 +3508,13 @@ static struct r10conf *setup_conf(struct mddev *mddev)
 				GFP_KERNEL);
 	if (!conf->mirrors) {
 		err = -ENOMEM;
-		goto out;
+		goto free_conf;
 	}
 
 	conf->tmppage = alloc_page(GFP_KERNEL);
 	if (!conf->tmppage) {
 		err = -ENOMEM;
-		goto out;
+		goto kfree_mirrors;
 	}
 
 	conf->geo = geo;
@@ -3523,7 +3523,7 @@ static struct r10conf *setup_conf(struct mddev *mddev)
 					   r10bio_pool_free, conf);
 	if (!conf->r10bio_pool) {
 		err = -ENOMEM;
-		goto out;
+		goto put_page;
 	}
 
 	calc_sectors(conf, mddev->dev_sectors);
@@ -3533,7 +3533,7 @@ static struct r10conf *setup_conf(struct mddev *mddev)
 	} else {
 		if (setup_geo(&conf->prev, mddev, geo_old) != conf->copies) {
 			err = -EINVAL;
-			goto out;
+			goto destroy_pool;
 		}
 		conf->reshape_progress = mddev->reshape_position;
 		if (conf->prev.far_offset)
@@ -3554,16 +3554,18 @@ static struct r10conf *setup_conf(struct mddev *mddev)
 	conf->thread = md_register_thread(raid10d, mddev, "raid10");
 	if (!conf->thread) {
 		err = -ENOMEM;
-		goto out;
+		goto destroy_pool;
 	}
 
 	conf->mddev = mddev;
 	return conf;
-
- out:
+destroy_pool:
 	mempool_destroy(conf->r10bio_pool);
+put_page:
 	safe_put_page(conf->tmppage);
+kfree_mirrors:
 	kfree(conf->mirrors);
+free_conf:
 	kfree(conf);
 	return ERR_PTR(err);
 }
-- 
2.10.1
