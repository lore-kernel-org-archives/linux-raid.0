From: Vishnu Pratap Singh <vishnu.ps@samsung.com>
Subject: [PATCH 2/8] mmc: handle add_disk() return value
Date: Fri, 06 Nov 2015 17:52:09 +0530
Message-ID: <1446812535-10567-2-git-send-email-vishnu.ps@samsung.com>
References: <437969438-9181-1-git-send-email-vishnu.ps@samsung.com>
 <1446812535-10567-1-git-send-email-vishnu.ps@samsung.com>
Return-path: <linux-mmc-owner@vger.kernel.org>
In-reply-to: <1446812535-10567-1-git-send-email-vishnu.ps@samsung.com>
Sender: linux-mmc-owner@vger.kernel.org
To: axboe@kernel.dk, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, jmoyer@redhat.com, minchan@kernel.org, ngupta@vflare.org, sergey.senozhatsky.work@gmail.com, davem@davemloft.net, neilb@suse.com, ulf.hansson@linaro.org, tiwai@suse.de, hare@suse.de, ming.lei@canonical.com, jarod@redhat.com, viro@zeniv.linux.org.uk, tj@kernel.org, adrian.hunter@intel.com, jonathanh@nvidia.com, grundler@chromium.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org
Cc: cpgs@samsung.com, vishu13285@gmail.com, pintu.k@samsung.com, rohit.kr@samsung.com, Vishnu Pratap Singh <vishnu.ps@samsung.com>
List-Id: linux-raid.ids

This patch handles  add_disk() return value.
Earlier add_disk() function doesn't handle error
cases, now it is added, so the callers of this function
should also handle it.

Verfied on X86 based ubuntu machine.
This patch depends on [PATCH 1/8] block/genhd.c: Add error handling

Signed-off-by: Vishnu Pratap Singh <vishnu.ps@samsung.com>
---
 drivers/mmc/card/block.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 23b6c8e..543c670 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -2432,7 +2432,10 @@ static int mmc_add_disk(struct mmc_blk_data *md)
 	int ret;
 	struct mmc_card *card = md->queue.card;
 
-	add_disk(md->disk);
+	ret = add_disk(md->disk);
+	if (ret)
+		goto add_disk_fail;
+
 	md->force_ro.show = force_ro_show;
 	md->force_ro.store = force_ro_store;
 	sysfs_attr_init(&md->force_ro.attr);
@@ -2468,7 +2471,7 @@ power_ro_lock_fail:
 	device_remove_file(disk_to_dev(md->disk), &md->force_ro);
 force_ro_fail:
 	del_gendisk(md->disk);
-
+add_disk_fail:
 	return ret;
 }
 
-- 
1.9.1

