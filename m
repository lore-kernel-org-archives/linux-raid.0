From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 6/6] md/raid5: Kill outdated comment.
Date: Mon, 25 May 2009 11:27:37 +0200
Message-ID: <1243243657-21855-7-git-send-email-maan@systemlinux.org>
References: <1243243657-21855-1-git-send-email-maan@systemlinux.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1243243657-21855-1-git-send-email-maan@systemlinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, Andre Noll <maan@systemlinux.org>
List-Id: linux-raid.ids

Raid5 has learned to take over also raid4 and raid6 arrays.
---
 drivers/md/raid5.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 772593d..9ec505b 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5231,8 +5231,6 @@ static void *raid5_takeover(mddev_t *mddev)
 	 *  raid1 - if there are two drives.  We need to know the chunk size
 	 *  raid4 - trivial - just use a raid4 layout.
 	 *  raid6 - Providing it is a *_6 layout
-	 *
-	 * For now, just do raid1
 	 */
 
 	if (mddev->level == 1)
-- 
1.5.4.3

