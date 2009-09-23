From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] md: stop using do_sync_mapping_range
Date: Thu, 24 Sep 2009 08:52:36 +1000
Message-ID: <19130.42676.5539.459956@notabene.brown>
References: <20090923131822.GA12287@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Christoph Hellwig on Wednesday September 23
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday September 23, hch@lst.de wrote:
> It's a very awkward way to write out all data and wait for it, so just
> call filemap_write_and_wait.  I still can't figure what the point of
> all this is, so a comment would surely be helpful.

When md/bitmap accesses a file, it uses bmap to find addresses and then
submit_bh to do IO, so it completely by-passes the page cache.
So this code is present to ensure that the page cache has no dirty
pages for the file before we start using the file.

I don't recall exactly why I used do_sync_mapping_range.  I suspect
that I looked at what "sys_fsync" used (do_fsync?) and found that
wasn't exported, so I looked at what sys_sync_file_range used, found
that was exported, and so used that.

Looking at the current state of the VFS, I think I would rather use
vfs_fsync.

So would you be happy with something like the following?

Thanks,
NeilBrown



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
