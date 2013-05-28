From: Kumar Amit Mehta <gmate.amit@gmail.com>
Subject: [PATCH] md: md.c: use strlcpy instead of strcpy
Date: Tue, 28 May 2013 02:39:41 -0700
Message-ID: <1369733981-10679-1-git-send-email-gmate.amit@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-raid.ids

Name of major driver can be of maximum of DISK_NAME_LEN size, therefore
use strlcpy instead of strcpy.

Signed-off-by: Kumar Amit Mehta <gmate.amit@gmail.com>
---
 drivers/md/md.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 0bbe710..9450a2c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4863,7 +4863,7 @@ static int md_alloc(dev_t dev, char *name)
 	disk->major = MAJOR(mddev->unit);
 	disk->first_minor = unit << shift;
 	if (name)
-		strcpy(disk->disk_name, name);
+		strlcpy(disk->disk_name, name, DISK_NAME_LEN);
 	else if (partitioned)
 		sprintf(disk->disk_name, "md_d%d", unit);
 	else
-- 
1.7.10.4
