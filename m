From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH] md/raid10: optimize read_balance() for 'far offset' arrays
Date: Wed,  8 Jun 2011 16:57:18 +0900
Message-ID: <1307519838-6869-1-git-send-email-namhyung@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If @conf->far_offset > 0, there is only 1 stripe so that we can treat
the array same as 'near' arrays.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 drivers/md/raid10.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 6e846688962f..fc56bdd8c3fb 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -531,7 +531,7 @@ retry:
 			break;
 
 		/* for far > 1 always use the lowest address */
-		if (conf->far_copies > 1)
+		if (conf->far_copies > 1 && conf->far_offset == 0)
 			new_distance = r10_bio->devs[slot].addr;
 		else
 			new_distance = abs(r10_bio->devs[slot].addr -
-- 
1.7.5.2

