From: Shaohua Li <shli@kernel.org>
Subject: [PATCH] MD: not clear ->safemode for external metadata array
Date: Fri, 11 Aug 2017 20:39:52 -0700
Message-ID: <a34d31891470e5c0c16e1eb0b05398e2b30f6c23.1502509111.git.shli@fb.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Shaohua Li <shli@fb.com>, NeilBrown <neilb@suse.com>
List-Id: linux-raid.ids

From: Shaohua Li <shli@fb.com>

->safemode should be triggered by mdadm for external metadaa array, otherwise
array's state confuses mdadm.

Fixes: 33182d15c6bf(md: always clear ->safemode when md_check_recovery gets the mddev lock.)
Cc: NeilBrown <neilb@suse.com>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/md.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index f8840ef1aafd..a74dc9963822 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8658,7 +8658,7 @@ void md_check_recovery(struct mddev *mddev)
 	if (mddev_trylock(mddev)) {
 		int spares = 0;
 
-		if (mddev->safemode == 1)
+		if (!mddev->external && mddev->safemode == 1)
 			mddev->safemode = 0;
 
 		if (mddev->ro) {
-- 
2.11.0

