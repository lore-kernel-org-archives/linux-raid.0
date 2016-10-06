From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 03/54] md/raid0: Move a variable assignment in
 create_strip_zones()
Date: Thu, 6 Oct 2016 10:54:48 +0200
Message-ID: <6df6dd93-d71d-0a14-e5d7-9ee664d6b040@users.sourceforge.net>
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
Date: Tue, 4 Oct 2016 12:02:29 +0200

One local variable was set to an error code before a concrete
error situation was detected. Thus move the corresponding assignment into
two if branches to indicate a memory allocation failure there.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/raid0.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 3c76451..71bd398 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -149,17 +149,21 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 		goto free_conf;
 	}
 
-	err = -ENOMEM;
 	conf->strip_zone = kcalloc(conf->nr_strip_zones,
 				   sizeof(*conf->strip_zone),
 				   GFP_KERNEL);
-	if (!conf->strip_zone)
+	if (!conf->strip_zone) {
+		err = -ENOMEM;
 		goto free_conf;
+	}
+
 	conf->devlist = kcalloc(conf->nr_strip_zones * mddev->raid_disks,
 				sizeof(*conf->devlist),
 				GFP_KERNEL);
-	if (!conf->devlist)
+	if (!conf->devlist) {
+		err = -ENOMEM;
 		goto free_zone;
+	}
 
 	/* The first zone must contain all devices, so here we check that
 	 * there is a proper alignment of slots to devices and find them all
-- 
2.10.1
