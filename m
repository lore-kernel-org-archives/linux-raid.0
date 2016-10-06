From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 27/54] md/raid5: Return directly after a failed kzalloc() in
 setup_conf()
Date: Thu, 6 Oct 2016 11:26:04 +0200
Message-ID: <1490c223-763b-b64c-b685-e3bdaa32923c@users.sourceforge.net>
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
Date: Tue, 4 Oct 2016 22:44:59 +0200

* Return directly after a call of the function "kzalloc" failed
  at the beginning.

* Delete a repeated check for the local variable "conf"
  which became unnecessary with this refactoring.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/raid5.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 562138f..17f50a6 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6482,8 +6482,8 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 	}
 
 	conf = kzalloc(sizeof(*conf), GFP_KERNEL);
-	if (conf == NULL)
-		goto abort;
+	if (!conf)
+		return ERR_PTR(-ENOMEM);
 	/* Don't enable multi-threading by default*/
 	if (!alloc_thread_groups(conf, 0, &group_cnt, &worker_cnt_per_group,
 				 &new_group)) {
@@ -6646,11 +6646,8 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 	return conf;
 
  abort:
-	if (conf) {
-		free_conf(conf);
-		return ERR_PTR(-EIO);
-	} else
-		return ERR_PTR(-ENOMEM);
+	free_conf(conf);
+	return ERR_PTR(-EIO);
 }
 
 static int only_parity(int raid_disk, int algo, int raid_disks, int max_degraded)
-- 
2.10.1
