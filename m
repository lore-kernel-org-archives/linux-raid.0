From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 1/6] md: linear.c: Fix typo in comment.
Date: Fri, 25 Jul 2008 17:27:47 +0200
Message-ID: <1216999672-4943-2-git-send-email-maan@systemlinux.org>
References: <1216999672-4943-1-git-send-email-maan@systemlinux.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1216999672-4943-1-git-send-email-maan@systemlinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Andre Noll <maan@systemlinux.org>
List-Id: linux-raid.ids


Signed-off-by: Andre Noll <maan@systemlinux.org>
---
 drivers/md/linear.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index 1cafaa9..2773d7b 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -159,7 +159,7 @@ static linear_conf_t *linear_conf(mddev_t *mddev, int raid_disks)
 	/* min_spacing is the minimum spacing that will fit the hash
 	 * table in one PAGE.  This may be much smaller than needed.
 	 * We find the smallest non-terminal set of consecutive devices
-	 * that is larger than min_spacing as use the size of that as
+	 * that is larger than min_spacing and use the size of that as
 	 * the actual spacing
 	 */
 	conf->hash_spacing = conf->array_sectors / 2;
-- 
1.5.4.3

