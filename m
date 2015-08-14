From: <gregkh@linuxfoundation.org>
Subject: Patch "md/bitmap: return an error when bitmap superblock is corrupt." has been added to the 3.10-stable tree
Date: Fri, 14 Aug 2015 10:25:23 -0700
Message-ID: <143957312364176@kroah.com>
References: <20150814170421.60d40eb0@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20150814170421.60d40eb0@noble>
Sender: stable-owner@vger.kernel.org
To: neilb@suse.com, gqjiang@suse.com, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, rgoldwyn@suse.com
Cc: stable@vger.kernel.org, stable-commits@vger.kernel.org
List-Id: linux-raid.ids


This is a note to let you know that I've just added the patch titled

    md/bitmap: return an error when bitmap superblock is corrupt.

to the 3.10-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     md-bitmap-return-an-error-when-bitmap-superblock-is-corrupt.patch
and it can be found in the queue-3.10 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From neilb@suse.com  Fri Aug 14 10:23:56 2015
From: NeilBrown <neilb@suse.com>
Date: Fri, 14 Aug 2015 17:04:21 +1000
Subject: md/bitmap: return an error when bitmap superblock is corrupt.
To: stable@vger.kernel.org, linux-raid <linux-raid@vger.kernel.org>
Cc: GuoQing Jiang <gqjiang@suse.com>, Goldwyn Rodrigues <rgoldwyn@suse.com>, lkml <linux-kernel@vger.kernel.org>
Message-ID: <20150814170421.60d40eb0@noble>

From: NeilBrown <neilb@suse.com>

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
Signed-off-by: NeilBrown <neilb@suse.com>
Reported-by: GuoQing Jiang <gqjiang@suse.com>

---
 drivers/md/bitmap.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -564,6 +564,8 @@ static int bitmap_read_sb(struct bitmap
 	if (err)
 		return err;
 
+	err = -EINVAL;
+
 	sb = kmap_atomic(sb_page);
 
 	chunksize = le32_to_cpu(sb->chunksize);


Patches currently in stable-queue which might be from neilb@suse.com are

queue-3.10/md-raid1-extend-spinlock-to-protect-raid1_end_read_request-against-inconsistencies.patch
queue-3.10/md-bitmap-return-an-error-when-bitmap-superblock-is-corrupt.patch
queue-3.10/md-use-kzalloc-when-bitmap-is-disabled.patch
