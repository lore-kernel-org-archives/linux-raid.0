From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 05/11] md: remove clumsy usage of do_sync_mapping_range
	from bitmap code
Date: Fri, 16 Oct 2009 16:49:18 +1100
Message-ID: <20091016054918.24208.52325.stgit@notabene.brown>
References: <20091016054316.24208.33818.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091016054316.24208.33818.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

and replace with vfs_fsync which is much neater (but wasn't exported,
or even in existence at the time the code was written).

Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/bitmap.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 6986b00..60e2b32 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1624,10 +1624,11 @@ int bitmap_create(mddev_t *mddev)
 	bitmap->offset = mddev->bitmap_offset;
 	if (file) {
 		get_file(file);
-		do_sync_mapping_range(file->f_mapping, 0, LLONG_MAX,
-				      SYNC_FILE_RANGE_WAIT_BEFORE |
-				      SYNC_FILE_RANGE_WRITE |
-				      SYNC_FILE_RANGE_WAIT_AFTER);
+		/* As future accesses to this file will use bmap,
+		 * and bypass the page cache, we must sync the file
+		 * first.
+		 */
+		vfs_fsync(file, file->f_dentry, 1);
 	}
 	/* read superblock from bitmap file (this sets bitmap->chunksize) */
 	err = bitmap_read_sb(bitmap);


