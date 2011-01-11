From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 01/13] md: fix regression with re-adding devices to arrays
	with no metadata
Date: Wed, 12 Jan 2011 09:12:46 +1100
Message-ID: <20110111221246.12732.67207.stgit@notabene.brown>
References: <20110111221050.12732.31647.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110111221050.12732.31647.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Commit 1a855a0606 (2.6.37-rc4) fixed a problem where devices were
re-added when they shouldn't be but caused a regression in a less
common case that means sometimes devices cannot be re-added when they
should be.

In particular, when re-adding a device to an array without metadata
we should always access the device, but after the above commit we
didn't.

This patch sets the In_sync flag in that case so that the re-add
succeeds.

This patch is suitable for any -stable kernel to which 1a855a0606 was
applied.

Cc: stable@kernel.org
Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/md.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 175c424..0da25da 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5159,9 +5159,10 @@ static int add_new_disk(mddev_t * mddev, mdu_disk_info_t *info)
 		/* set saved_raid_disk if appropriate */
 		if (!mddev->persistent) {
 			if (info->state & (1<<MD_DISK_SYNC)  &&
-			    info->raid_disk < mddev->raid_disks)
+			    info->raid_disk < mddev->raid_disks) {
 				rdev->raid_disk = info->raid_disk;
-			else
+				set_bit(In_sync, &rdev->flags);
+			} else
 				rdev->raid_disk = -1;
 		} else
 			super_types[mddev->major_version].


