From: Vishnu Pratap Singh <vishnu.ps@samsung.com>
Subject: [PATCH 6/8] md/md.c: handle blk_register_region() return value
Date: Fri, 06 Nov 2015 17:52:13 +0530
Message-ID: <1446812535-10567-6-git-send-email-vishnu.ps@samsung.com>
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
 drivers/md/md.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index a71b36f..244bb26 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8940,10 +8940,12 @@ static int __init md_init(void)
 		goto err_mdp;
 	mdp_major = ret;
 
-	blk_register_region(MKDEV(MD_MAJOR, 0), 512, THIS_MODULE,
-			    md_probe, NULL, NULL);
-	blk_register_region(MKDEV(mdp_major, 0), 1UL<<MINORBITS, THIS_MODULE,
-			    md_probe, NULL, NULL);
+	if (blk_register_region(MKDEV(MD_MAJOR, 0), 512, THIS_MODULE,
+			    md_probe, NULL, NULL))
+		goto err_md_blk;
+	if (blk_register_region(MKDEV(mdp_major, 0), 1UL<<MINORBITS,
+			    THIS_MODULE, md_probe, NULL, NULL))
+		goto err_mdp_blk;
 
 	register_reboot_notifier(&md_notifier);
 	raid_table_header = register_sysctl_table(raid_root_table);
@@ -8951,6 +8953,10 @@ static int __init md_init(void)
 	md_geninit();
 	return 0;
 
+err_mdp_blk:
+	blk_unregister_region(MKDEV(MD_MAJOR, 0), 512);
+err_md_blk:
+	unregister_blkdev(MD_MAJOR, "mdp");
 err_mdp:
 	unregister_blkdev(MD_MAJOR, "md");
 err_md:
-- 
1.9.1

