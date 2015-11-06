From: Vishnu Pratap Singh <vishnu.ps@samsung.com>
Subject: [PATCH 3/8] block/floppy.c: handle blk_register_region() return value
Date: Fri, 06 Nov 2015 17:52:10 +0530
Message-ID: <1446812535-10567-3-git-send-email-vishnu.ps@samsung.com>
References: <437969438-9181-1-git-send-email-vishnu.ps@samsung.com>
 <1446812535-10567-1-git-send-email-vishnu.ps@samsung.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-reply-to: <1446812535-10567-1-git-send-email-vishnu.ps@samsung.com>
Sender: linux-ide-owner@vger.kernel.org
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
 drivers/block/floppy.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 331363e..50802a6 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4219,8 +4219,10 @@ static int __init do_floppy_init(void)
 	if (err)
 		goto out_unreg_blkdev;
 
-	blk_register_region(MKDEV(FLOPPY_MAJOR, 0), 256, THIS_MODULE,
+	err = blk_register_region(MKDEV(FLOPPY_MAJOR, 0), 256, THIS_MODULE,
 			    floppy_find, NULL, NULL);
+	if (err)
+		goto out_unreg_region;
 
 	for (i = 0; i < 256; i++)
 		if (ITYPE(i))
@@ -4250,7 +4252,7 @@ static int __init do_floppy_init(void)
 	if (fdc_state[0].address == -1) {
 		cancel_delayed_work(&fd_timeout);
 		err = -ENODEV;
-		goto out_unreg_region;
+		goto out_fdc_err;
 	}
 #if N_FDC > 1
 	fdc_state[1].address = FDC2;
@@ -4261,7 +4263,7 @@ static int __init do_floppy_init(void)
 	if (err) {
 		cancel_delayed_work(&fd_timeout);
 		err = -EBUSY;
-		goto out_unreg_region;
+		goto out_fdc_region;
 	}
 
 	/* initialise drive state */
@@ -4357,8 +4359,9 @@ out_remove_drives:
 out_release_dma:
 	if (atomic_read(&usage_count))
 		floppy_release_irq_and_dma();
-out_unreg_region:
+out_fdc_err:
 	blk_unregister_region(MKDEV(FLOPPY_MAJOR, 0), 256);
+out_unreg_region:
 	platform_driver_unregister(&floppy_driver);
 out_unreg_blkdev:
 	unregister_blkdev(FLOPPY_MAJOR, "fd");
-- 
1.9.1

