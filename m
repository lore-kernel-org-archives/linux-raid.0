From: NeilBrown <neilb@suse.com>
Subject: [PATCH stable] md/bitmap: return an error when bitmap superblock is
 corrupt.
Date: Fri, 14 Aug 2015 17:04:21 +1000
Message-ID: <20150814170421.60d40eb0@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: stable@vger.kernel.org, linux-raid <linux-raid@vger.kernel.org>
Cc: GuoQing Jiang <gqjiang@suse.com>, Goldwyn Rodrigues <rgoldwyn@suse.com>, lkml <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids


commit b97e92574c0bf335db1cd2ec491d8ff5cd5d0b49 upstream
    Use separate bitmaps for each nodes in the cluster

bitmap_read_sb() validates the bitmap superblock that it reads in.
If it finds an inconsistency like a bad magic number or out-of-range
version number, it prints an error and returns, but it incorrectly
returns zero, so the array is still assembled with the (invalid) bitmap.

This means it could try to use a bitmap with a new version number which
it therefore does not understand.

This bug was introduced in 3.5 and fix as part of a larger patch in 4.1.
So the patch is suitable for any -stable kernel in that range.

Fixes: 27581e5ae01f ("md/bitmap: centralise allocation of bitmap file pages.")
Cc: stable@vger.kernel.org (v3.5..v4.1)
Signed-off-by: NeilBrown <neilb@suse.com>
Reported-by: GuoQing Jiang <gqjiang@suse.com>

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 3a5767968ba0..894fd58f75f1 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -577,6 +577,8 @@ static int bitmap_read_sb(struct bitmap *bitmap)
 	if (err)
 		return err;
 
+	err = -EINVAL;
+
 	sb = kmap_atomic(sb_page);
 
 	chunksize = le32_to_cpu(sb->chunksize);
