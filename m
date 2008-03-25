From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 3/8] md: alloc_disk_sb(): Return proper error value.
Date: Tue, 25 Mar 2008 20:55:49 +0100
Message-ID: <S1754829AbYGHQde/20080708163334Z+59@vger.kernel.org>
References: <20080708155541.GS23944@skl-net.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080708155541.GS23944@skl-net.de>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-raid.ids

If alloc_page() fails, ENOMEM is a more suitable error value
than EINVAL.

Signed-off-by: Andre Noll <maan@systemlinux.org>
---
 drivers/md/md.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 58762dd..7943df1 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -372,7 +372,7 @@ static int alloc_disk_sb(mdk_rdev_t * rdev)
 	rdev->sb_page = alloc_page(GFP_KERNEL);
 	if (!rdev->sb_page) {
 		printk(KERN_ALERT "md: out of memory.\n");
-		return -EINVAL;
+		return -ENOMEM;
 	}
 
 	return 0;
-- 
1.5.3.8

