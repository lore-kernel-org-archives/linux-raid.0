From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 5/8] md: Handle growth of v1.x metadata correctly.
Date: Mon, 03 Aug 2009 07:58:18 +1000
Message-ID: <20090802215818.4198.37394.stgit@notabene.brown>
References: <20090802215444.4198.83094.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090802215444.4198.83094.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: stable@kernel.org, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

The v1.x metadata does not have a fixed size and can grow
when devices are added.
If it grows enough to require an extra sector of storage,
we need to update the 'sb_size' to match.

Without this, md can write out an incomplete superblock with a
bad checksum, which will be rejected when trying to re-assemble
the array.

Cc: stable@kernel.org
Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/md.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index fc04963..5b507e9 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1399,8 +1399,14 @@ static void super_1_sync(mddev_t *mddev, mdk_rdev_t *rdev)
 		if (rdev2->desc_nr+1 > max_dev)
 			max_dev = rdev2->desc_nr+1;
 
-	if (max_dev > le32_to_cpu(sb->max_dev))
+	if (max_dev > le32_to_cpu(sb->max_dev)) {
+		int bmask;
 		sb->max_dev = cpu_to_le32(max_dev);
+		rdev->sb_size = max_dev * 2 + 256;
+		bmask = queue_logical_block_size(rdev->bdev->bd_disk->queue)-1;
+		if (rdev->sb_size & bmask)
+			rdev->sb_size = (rdev->sb_size | bmask) + 1;
+	}
 	for (i=0; i<max_dev;i++)
 		sb->dev_roles[i] = cpu_to_le16(0xfffe);
 	


