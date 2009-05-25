From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 2/6] md: Fix a bug in super_1_sync().
Date: Mon, 25 May 2009 11:27:33 +0200
Message-ID: <1243243657-21855-3-git-send-email-maan@systemlinux.org>
References: <1243243657-21855-1-git-send-email-maan@systemlinux.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1243243657-21855-1-git-send-email-maan@systemlinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, Andre Noll <maan@systemlinux.org>
List-Id: linux-raid.ids

The new_chunk fields of both struct mddev_s and struct mdp_superblock_1
are measured in bytes. However, in super_1_sync(), mddev->new_chunk
is converted to sectors before it assigned to sb->new_chunk.

This results in a too small number being stored in the in-memory
image of the superblock which could confuse the reshape process.

Signed-off-by: Andre Noll <maan@systemlinux.org>
---
 drivers/md/md.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 48bdbdf..66e32e4 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1402,7 +1402,7 @@ static void super_1_sync(mddev_t *mddev, mdk_rdev_t *rdev)
 		sb->new_layout = cpu_to_le32(mddev->new_layout);
 		sb->delta_disks = cpu_to_le32(mddev->delta_disks);
 		sb->new_level = cpu_to_le32(mddev->new_level);
-		sb->new_chunk = cpu_to_le32(mddev->new_chunk>>9);
+		sb->new_chunk = cpu_to_le32(mddev->new_chunk);
 	}
 
 	max_dev = 0;
-- 
1.5.4.3

