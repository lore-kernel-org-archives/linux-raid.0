From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 07/24] Return MD_SB_CLUSTERED if mddev is clustered
Date: Thu, 18 Dec 2014 10:16:38 -0600
Message-ID: <20141218161638.GA29601@shrek.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: lzhong@suse.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 drivers/md/md.c                | 3 +++
 include/uapi/linux/raid/md_p.h | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 795d925..5f45951 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5630,6 +5630,9 @@ static int get_array_info(struct mddev * mddev, void __user * arg)
 		info.state = (1<<MD_SB_CLEAN);
 	if (mddev->bitmap && mddev->bitmap_info.offset)
 		info.state = (1<<MD_SB_BITMAP_PRESENT);
+	if (mddev_is_clustered(mddev))
+		info.state |= (1<<MD_SB_CLUSTERED);
+
 	info.active_disks  = insync;
 	info.working_disks = working;
 	info.failed_disks  = failed;
diff --git a/include/uapi/linux/raid/md_p.h b/include/uapi/linux/raid/md_p.h
index 49f4210..643489d 100644
--- a/include/uapi/linux/raid/md_p.h
+++ b/include/uapi/linux/raid/md_p.h
@@ -101,6 +101,7 @@ typedef struct mdp_device_descriptor_s {
 #define MD_SB_CLEAN		0
 #define MD_SB_ERRORS		1
 
+#define	MD_SB_CLUSTERED		5 /* MD is clustered */
 #define	MD_SB_BITMAP_PRESENT	8 /* bitmap may be present nearby */
 
 /*
-- 
2.1.2

