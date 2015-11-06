From: Vishnu Pratap Singh <vishnu.ps@samsung.com>
Subject: [PATCH 7/8] cdrom/gdrom.c: handle add_disk() return value
Date: Fri, 06 Nov 2015 17:52:14 +0530
Message-ID: <1446812535-10567-7-git-send-email-vishnu.ps@samsung.com>
References: <437969438-9181-1-git-send-email-vishnu.ps@samsung.com>
 <1446812535-10567-1-git-send-email-vishnu.ps@samsung.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-reply-to: <1446812535-10567-1-git-send-email-vishnu.ps@samsung.com>
Sender: linux-ide-owner@vger.kernel.org
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
 drivers/cdrom/gdrom.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/cdrom/gdrom.c b/drivers/cdrom/gdrom.c
index 584bc31..38ca43a 100644
--- a/drivers/cdrom/gdrom.c
+++ b/drivers/cdrom/gdrom.c
@@ -817,9 +817,14 @@ static int probe_gdrom(struct platform_device *devptr)
 	gd.toc = kzalloc(sizeof(struct gdromtoc), GFP_KERNEL);
 	if (!gd.toc)
 		goto probe_fail_toc;
-	add_disk(gd.disk);
+	err = add_disk(gd.disk);
+	if (err)
+		goto probe_fail_add_disk;
+
 	return 0;
 
+probe_fail_add_disk:
+	kfree(gd.toc);
 probe_fail_toc:
 	blk_cleanup_queue(gd.gdrom_rq);
 probe_fail_requestq:
-- 
1.9.1

