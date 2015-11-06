From: Vishnu Pratap Singh <vishnu.ps@samsung.com>
Subject: [PATCH 8/8] ide/ide-probe.c: handle blk_register_region() return value
Date: Fri, 06 Nov 2015 17:52:15 +0530
Message-ID: <1446812535-10567-8-git-send-email-vishnu.ps@samsung.com>
References: <437969438-9181-1-git-send-email-vishnu.ps@samsung.com>
 <1446812535-10567-1-git-send-email-vishnu.ps@samsung.com>
Return-path: <linux-mmc-owner@vger.kernel.org>
In-reply-to: <1446812535-10567-1-git-send-email-vishnu.ps@samsung.com>
Sender: linux-mmc-owner@vger.kernel.org
To: axboe@kernel.dk, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, jmoyer@redhat.com, minchan@kernel.org, ngupta@vflare.org, sergey.senozhatsky.work@gmail.com, davem@davemloft.net, neilb@suse.com, ulf.hansson@linaro.org, tiwai@suse.de, hare@suse.de, ming.lei@canonical.com, jarod@redhat.com, viro@zeniv.linux.org.uk, tj@kernel.org, adrian.hunter@intel.com, jonathanh@nvidia.com, grundler@chromium.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org
Cc: cpgs@samsung.com, vishu13285@gmail.com, pintu.k@samsung.com, rohit.kr@samsung.com, Vishnu Pratap Singh <vishnu.ps@samsung.com>
List-Id: linux-raid.ids

This patch handles blk_register_region() return value.
Earlier blk_register_region() function doesn't handle error
cases, now it is added, so the callers of this function
should also handle it.

Verfied on X86 based ubuntu machine.
This patch depends on [PATCH 1/8] block/genhd.c: Add error handling

Signed-off-by: Vishnu Pratap Singh <vishnu.ps@samsung.com>
---
 drivers/ide/ide-probe.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 0b63fac..651eb05 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -917,9 +917,9 @@ static int exact_lock(dev_t dev, void *data)
 	return 0;
 }
 
-void ide_register_region(struct gendisk *disk)
+int ide_register_region(struct gendisk *disk)
 {
-	blk_register_region(MKDEV(disk->major, disk->first_minor),
+	return blk_register_region(MKDEV(disk->major, disk->first_minor),
 			    disk->minors, NULL, exact_match, exact_lock, disk);
 }
 
@@ -988,8 +988,9 @@ static int hwif_init(ide_hwif_t *hwif)
 		goto out;
 	}
 
-	blk_register_region(MKDEV(hwif->major, 0), MAX_DRIVES << PARTN_BITS,
-			    THIS_MODULE, ata_probe, ata_lock, hwif);
+	if (blk_register_region(MKDEV(hwif->major, 0), MAX_DRIVES << PARTN_BITS,
+			    THIS_MODULE, ata_probe, ata_lock, hwif))
+		goto out;
 	return 1;
 
 out:
-- 
1.9.1

