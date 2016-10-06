From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 43/54] md/raid10: Return directly after detection of
 unsupported settings in setup_conf()
Date: Thu, 6 Oct 2016 11:43:39 +0200
Message-ID: <cb82c166-a267-dbb7-adac-f9d741bbda13@users.sourceforge.net>
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
Date: Wed, 5 Oct 2016 17:32:49 +0200

* Return directly after unsupported system settings were detected
  at the beginning.

* Delete the explicit initialisation for the local variables "conf"
  and "err" which became unnecessary with this refactoring.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/raid10.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 1f712f7..8326e68 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3478,8 +3478,8 @@ static int setup_geo(struct geom *geo, struct mddev *mddev, enum geo_type new)
 
 static struct r10conf *setup_conf(struct mddev *mddev)
 {
-	struct r10conf *conf = NULL;
-	int err = -EINVAL;
+	struct r10conf *conf;
+	int err;
 	struct geom geo;
 	int copies;
 
@@ -3489,13 +3489,13 @@ static struct r10conf *setup_conf(struct mddev *mddev)
 		printk(KERN_ERR "md/raid10:%s: chunk size must be "
 		       "at least PAGE_SIZE(%ld) and be a power of 2.\n",
 		       mdname(mddev), PAGE_SIZE);
-		goto out;
+		return ERR_PTR(-EINVAL);
 	}
 
 	if (copies < 2 || copies > mddev->raid_disks) {
 		printk(KERN_ERR "md/raid10:%s: unsupported raid10 layout: 0x%8x\n",
 		       mdname(mddev), mddev->new_layout);
-		goto out;
+		return ERR_PTR(-EINVAL);
 	}
 
 	err = -ENOMEM;
-- 
2.10.1
