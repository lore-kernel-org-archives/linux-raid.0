From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 13/54] md/raid1: Return directly after a failed kzalloc() in
 setup_conf()
Date: Thu, 6 Oct 2016 11:09:18 +0200
Message-ID: <7bc6f8e0-5e74-08fc-74f3-33284786ea1e@users.sourceforge.net>
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
Date: Tue, 4 Oct 2016 15:56:41 +0200

* Return directly after a call of the function "kzalloc" failed
  at the beginning.

* Delete a repeated check for the local variable "conf"
  which became unnecessary with this refactoring.

* Reorder two calls for the function "kfree" at the end.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/raid1.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 5969711..74346f5 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2779,7 +2779,7 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 
 	conf = kzalloc(sizeof(struct r1conf), GFP_KERNEL);
 	if (!conf)
-		goto abort;
+		return ERR_PTR(-ENOMEM);
 
 	conf->mirrors = kcalloc(mddev->raid_disks * 2,
 				sizeof(*conf->mirrors),
@@ -2880,13 +2880,11 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 	return conf;
 
  abort:
-	if (conf) {
-		mempool_destroy(conf->r1bio_pool);
-		kfree(conf->mirrors);
-		safe_put_page(conf->tmppage);
-		kfree(conf->poolinfo);
-		kfree(conf);
-	}
+	mempool_destroy(conf->r1bio_pool);
+	kfree(conf->poolinfo);
+	safe_put_page(conf->tmppage);
+	kfree(conf->mirrors);
+	kfree(conf);
 	return ERR_PTR(err);
 }
 
-- 
2.10.1
