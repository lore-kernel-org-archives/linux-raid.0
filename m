From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 05/36] md: Disable bad blocks and v0.90 metadata.
Date: Thu, 21 Jul 2011 12:58:48 +1000
Message-ID: <20110721025847.8422.55780.stgit@notabene.brown>
References: <20110721024556.8422.99443.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721024556.8422.99443.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

v0.90 metadata cannot record bad blocks, so when loading metadata
for such a device, set shift to -1.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/md.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 18c3aab..340e2d4 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1058,6 +1058,7 @@ static int super_90_load(mdk_rdev_t *rdev, mdk_rdev_t *refdev, int minor_version
 	rdev->preferred_minor = sb->md_minor;
 	rdev->data_offset = 0;
 	rdev->sb_size = MD_SB_BYTES;
+	rdev->badblocks.shift = -1;
 
 	if (sb->level == LEVEL_MULTIPATH)
 		rdev->desc_nr = -1;
@@ -3009,6 +3010,9 @@ static mdk_rdev_t *md_import_device(dev_t newdev, int super_format, int super_mi
 			goto abort_free;
 		}
 	}
+	if (super_format == -1)
+		/* hot-add for 0.90, or non-persistent: so no badblocks */
+		rdev->badblocks.shift = -1;
 
 	return rdev;
 


