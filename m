From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 45/54] md/raid10: Move assignments for the variable "err" in
 setup_conf()
Date: Thu, 6 Oct 2016 11:45:24 +0200
Message-ID: <aaf54edd-9051-e72d-90b3-3c2755e0736c@users.sourceforge.net>
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
Date: Wed, 5 Oct 2016 18:26:45 +0200

One local variable was set to an error code before a concrete
error situation was detected. Thus move the corresponding assignments
into if branches to indicate a memory allocation failure there.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/raid10.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index abe75c2..7e512d4 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3498,7 +3498,6 @@ static struct r10conf *setup_conf(struct mddev *mddev)
 		return ERR_PTR(-EINVAL);
 	}
 
-	err = -ENOMEM;
 	conf = kzalloc(sizeof(*conf), GFP_KERNEL);
 	if (!conf)
 		return ERR_PTR(-ENOMEM);
@@ -3507,19 +3506,25 @@ static struct r10conf *setup_conf(struct mddev *mddev)
 	conf->mirrors = kcalloc(mddev->raid_disks + max(0, -mddev->delta_disks),
 				sizeof(*conf->mirrors),
 				GFP_KERNEL);
-	if (!conf->mirrors)
+	if (!conf->mirrors) {
+		err = -ENOMEM;
 		goto out;
+	}
 
 	conf->tmppage = alloc_page(GFP_KERNEL);
-	if (!conf->tmppage)
+	if (!conf->tmppage) {
+		err = -ENOMEM;
 		goto out;
+	}
 
 	conf->geo = geo;
 	conf->copies = copies;
 	conf->r10bio_pool = mempool_create(NR_RAID10_BIOS, r10bio_pool_alloc,
 					   r10bio_pool_free, conf);
-	if (!conf->r10bio_pool)
+	if (!conf->r10bio_pool) {
+		err = -ENOMEM;
 		goto out;
+	}
 
 	calc_sectors(conf, mddev->dev_sectors);
 	if (mddev->reshape_position == MaxSector) {
@@ -3547,8 +3552,10 @@ static struct r10conf *setup_conf(struct mddev *mddev)
 	atomic_set(&conf->nr_pending, 0);
 
 	conf->thread = md_register_thread(raid10d, mddev, "raid10");
-	if (!conf->thread)
+	if (!conf->thread) {
+		err = -ENOMEM;
 		goto out;
+	}
 
 	conf->mddev = mddev;
 	return conf;
-- 
2.10.1
