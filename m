From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 15/54] md/raid1: Less function calls in setup_conf() after
 error detection
Date: Thu, 6 Oct 2016 11:11:14 +0200
Message-ID: <b48403b0-7eb2-cfeb-33bd-1996e838559a@users.sourceforge.net>
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
Date: Tue, 4 Oct 2016 18:01:02 +0200

Resource release functions were called in up to four cases
by the setup_conf() function during error handling even if
the passed data structure members contained a null pointer.

Adjust jump targets according to the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/raid1.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 4d2fcbc..7dc45ba 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2786,19 +2786,19 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 				GFP_KERNEL);
 	if (!conf->mirrors) {
 		err = -ENOMEM;
-		goto abort;
+		goto free_conf;
 	}
 
 	conf->tmppage = alloc_page(GFP_KERNEL);
 	if (!conf->tmppage) {
 		err = -ENOMEM;
-		goto abort;
+		goto free_mirrors;
 	}
 
 	conf->poolinfo = kzalloc(sizeof(*conf->poolinfo), GFP_KERNEL);
 	if (!conf->poolinfo) {
 		err = -ENOMEM;
-		goto abort;
+		goto put_page;
 	}
 
 	conf->poolinfo->raid_disks = mddev->raid_disks * 2;
@@ -2807,7 +2807,7 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 					  conf->poolinfo);
 	if (!conf->r1bio_pool) {
 		err = -ENOMEM;
-		goto abort;
+		goto free_poolinfo;
 	}
 
 	conf->poolinfo->mddev = mddev;
@@ -2825,7 +2825,7 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 
 		if (disk->rdev) {
 			err = -EINVAL;
-			goto abort;
+			goto destroy_pool;
 		}
 
 		disk->rdev = rdev;
@@ -2866,7 +2866,7 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 				if (!test_bit(In_sync, &disk->rdev->flags)) {
 					/* Original is not in_sync - bad */
 					err = -EIO;
-					goto abort;
+					goto destroy_pool;
 				}
 			}
 		}
@@ -2886,16 +2886,19 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 		       "md/raid1:%s: couldn't allocate thread\n",
 		       mdname(mddev));
 		err = -ENOMEM;
-		goto abort;
+		goto destroy_pool;
 	}
 
 	return conf;
-
- abort:
+destroy_pool:
 	mempool_destroy(conf->r1bio_pool);
+free_poolinfo:
 	kfree(conf->poolinfo);
+put_page:
 	safe_put_page(conf->tmppage);
+free_mirrors:
 	kfree(conf->mirrors);
+free_conf:
 	kfree(conf);
 	return ERR_PTR(err);
 }
-- 
2.10.1
