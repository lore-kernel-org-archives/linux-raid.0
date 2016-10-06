From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 44/54] md/raid10: Return directly after a failed kzalloc() in
 setup_conf()
Date: Thu, 6 Oct 2016 11:44:30 +0200
Message-ID: <6885c0ba-458f-23aa-883d-d1571c398bc5@users.sourceforge.net>
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
Date: Wed, 5 Oct 2016 17:46:02 +0200

* Return directly after a call of the function "kzalloc" failed
  at the beginning.

* Delete a repeated check for the local variable "conf"
  which became unnecessary with this refactoring.

* Reorder calls for the functions "kfree" and "safe_put_page"
  at the end.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/raid10.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 8326e68..abe75c2 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3501,7 +3501,7 @@ static struct r10conf *setup_conf(struct mddev *mddev)
 	err = -ENOMEM;
 	conf = kzalloc(sizeof(*conf), GFP_KERNEL);
 	if (!conf)
-		goto out;
+		return ERR_PTR(-ENOMEM);
 
 	/* FIXME calc properly */
 	conf->mirrors = kcalloc(mddev->raid_disks + max(0, -mddev->delta_disks),
@@ -3554,12 +3554,10 @@ static struct r10conf *setup_conf(struct mddev *mddev)
 	return conf;
 
  out:
-	if (conf) {
-		mempool_destroy(conf->r10bio_pool);
-		kfree(conf->mirrors);
-		safe_put_page(conf->tmppage);
-		kfree(conf);
-	}
+	mempool_destroy(conf->r10bio_pool);
+	safe_put_page(conf->tmppage);
+	kfree(conf->mirrors);
+	kfree(conf);
 	return ERR_PTR(err);
 }
 
-- 
2.10.1
