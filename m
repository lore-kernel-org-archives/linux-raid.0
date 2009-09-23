From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] md: stop using do_sync_mapping_range
Date: Wed, 23 Sep 2009 15:18:22 +0200
Message-ID: <20090923131822.GA12287@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

It's a very awkward way to write out all data and wait for it, so just
call filemap_write_and_wait.  I still can't figure what the point of
all this is, so a comment would surely be helpful.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: vfs-2.6.git/drivers/md/bitmap.c
===================================================================
--- vfs-2.6.git.orig/drivers/md/bitmap.c	2009-09-22 14:31:08.698262797 -0300
+++ vfs-2.6.git/drivers/md/bitmap.c	2009-09-22 14:33:01.573762756 -0300
@@ -1621,10 +1621,7 @@ int bitmap_create(mddev_t *mddev)
 	bitmap->offset = mddev->bitmap_offset;
 	if (file) {
 		get_file(file);
-		do_sync_mapping_range(file->f_mapping, 0, LLONG_MAX,
-				      SYNC_FILE_RANGE_WAIT_BEFORE |
-				      SYNC_FILE_RANGE_WRITE |
-				      SYNC_FILE_RANGE_WAIT_AFTER);
+		filemap_write_and_wait(file->f_mapping);
 	}
 	/* read superblock from bitmap file (this sets bitmap->chunksize) */
 	err = bitmap_read_sb(bitmap);
