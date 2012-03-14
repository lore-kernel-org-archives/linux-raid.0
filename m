From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 22/23] md: fix clearing of the 'changed' flags for the bad
 blocks list.
Date: Wed, 14 Mar 2012 15:40:41 +1100
Message-ID: <20120314044041.7978.95985.stgit@notabene.brown>
References: <20120314043555.7978.75486.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120314043555.7978.75486.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

In super_1_sync (the first hunk) we need to clear 'changed' before
checking read_seqretry(), otherwise we might race with other code
adding a bad block and so won't retry later.

In md_update_sb (the second hunk), in the case where there is no
metadata (neither persistent nor external), we treat any bad blocks as
an error.  However we need to clear the 'changed' flag before calling
md_ack_all_badblocks, else it won't do anything.

This patch is suitable for -stable release 3.0 and later.

Cc: stable@vger.kernel.org
Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/md.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index f873e71..e9913bf 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1805,13 +1805,13 @@ retry:
 						| BB_LEN(internal_bb));
 				*bbp++ = cpu_to_le64(store_bb);
 			}
+			bb->changed = 0;
 			if (read_seqretry(&bb->lock, seq))
 				goto retry;
 
 			bb->sector = (rdev->sb_start +
 				      (int)le32_to_cpu(sb->bblog_offset));
 			bb->size = le16_to_cpu(sb->bblog_size);
-			bb->changed = 0;
 		}
 	}
 
@@ -2366,6 +2366,7 @@ repeat:
 			clear_bit(MD_CHANGE_PENDING, &mddev->flags);
 			rdev_for_each(rdev, mddev) {
 				if (rdev->badblocks.changed) {
+					rdev->badblocks.changed = 0;
 					md_ack_all_badblocks(&rdev->badblocks);
 					md_error(mddev, rdev, 0);
 				}


