From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 21/24] md/bitmap: make sure reshape request are reflected
 in superblock.
Date: Tue, 17 Apr 2012 18:43:42 +1000
Message-ID: <20120417084342.6433.10119.stgit@notabene.brown>
References: <20120417084324.6433.68345.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120417084324.6433.68345.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

As a reshape may change the sync_size and/or chunk_size, we need
to update these whenever we write out the bitmap superblock.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/bitmap.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index dc5ec72..d1004b6 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -418,6 +418,9 @@ void bitmap_update_sb(struct bitmap *bitmap)
 	/* Just in case these have been changed via sysfs: */
 	sb->daemon_sleep = cpu_to_le32(bitmap->mddev->bitmap_info.daemon_sleep/HZ);
 	sb->write_behind = cpu_to_le32(bitmap->mddev->bitmap_info.max_write_behind);
+	/* This might have been changed by a reshape */
+	sb->sync_size = cpu_to_le64(bitmap->mddev->resync_max_sectors);
+	sb->chunksize = cpu_to_le32(bitmap->mddev->bitmap_info.chunksize);
 	kunmap_atomic(sb);
 	write_page(bitmap, bitmap->storage.sb_page, 1);
 }


