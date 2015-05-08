From: NeilBrown <neilb@suse.de>
Subject: [PATCH 1/7] md-raid0: conditional mddev->queue access to suit
 dm-raid
Date: Fri, 08 May 2015 18:56:10 +1000
Message-ID: <20150508085610.19179.84724.stgit@notabene.brown>
References: <20150508085345.19179.8866.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150508085345.19179.8866.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Shaohua Li <shli@kernel.org>
Cc: Heinz Mauelshagen <heinzm@redhat.com>, linux-nfs@vger.kernel.org
List-Id: linux-raid.ids

From: Heinz Mauelshagen <heinzm@redhat.com>

This patch is a prerequisite for dm-raid "raid0" support to allow
dm-raid to access the MD RAID0 personality doing unconditional
accesses to mddev->queue, which is NULL in case of dm-raid stacked on
top of MD.

Most of the conditional mddev->queue accesses made it to upstream but
this missing one, which prohibits md raid0 to set disk stack limits
(being done in dm core in case of md underneath dm).

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Tested-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/raid0.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 2cb59a641cd2..6a68ef5246d4 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -188,8 +188,9 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 		}
 		dev[j] = rdev1;
 
-		disk_stack_limits(mddev->gendisk, rdev1->bdev,
-				  rdev1->data_offset << 9);
+		if (mddev->queue)
+			disk_stack_limits(mddev->gendisk, rdev1->bdev,
+					  rdev1->data_offset << 9);
 
 		if (rdev1->bdev->bd_disk->queue->merge_bvec_fn)
 			conf->has_merge_bvec = 1;


