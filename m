From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 3.10 34/35] md/bitmap: return an error when bitmap superblock is corrupt.
Date: Fri, 14 Aug 2015 10:45:12 -0700
Message-ID: <20150814174355.024047496@linuxfoundation.org>
References: <20150814174353.835241087@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150814174353.835241087@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, "stable@vger.kernel.org, linux-raid" <linux-raid@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, NeilBrown <neilb@suse.com>, GuoQing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

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
