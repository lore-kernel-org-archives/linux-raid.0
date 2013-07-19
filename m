From: mwilck@arcor.de
Subject: [PATCH 1/6] DDF: err_bad_md_layout: fix return value
Date: Fri, 19 Jul 2013 21:04:10 +0200
Message-ID: <1374260655-5788-2-git-send-email-mwilck@arcor.de>
References: <1374260655-5788-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1374260655-5788-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

This function must use -1 to indicate failure. Fix it.
---
 super-ddf.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index 8c6fa6d..e23291f 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -500,7 +500,7 @@ static int err_bad_md_layout(const mdu_array_info_t *array)
 {
 	pr_err("RAID%d layout %x with %d disks is unsupported for DDF\n",
 	       array->level, array->layout, array->raid_disks);
-	return DDF_INVALID_LEVEL;
+	return -1;
 }
 
 static int layout_md2ddf(const mdu_array_info_t *array,
-- 
1.7.1
