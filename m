From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: [PATCH] md: fix device size calculation with non-persistent superblock
Date: Mon, 23 Feb 2004 11:57:29 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <403A30F9.D54AAC68@SteelEye.com>
References: <20040223024124.GA1590@psilocybus> <16441.33071.218049.163976@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------0F7B22E4CB6C4C1E76FD28F5"
Return-path: <linux-raid-owner@vger.kernel.org>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------0F7B22E4CB6C4C1E76FD28F5
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Neil,

Currently, the device size calculation is not correct when hot-adding
devices to arrays with non-persistent superblocks. Device size is always
calculated as if there were a physical superblock on every device. The
attached simple change to hot_add_disk() fixes the problem.

Thanks,
Paul
--------------0F7B22E4CB6C4C1E76FD28F5
Content-Type: text/x-patch; charset=us-ascii;
 name="md_nonpersistent_sb_fix.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="md_nonpersistent_sb_fix.diff"

--- 2_6_3_rc2/drivers/md/md.c.PRISTINE	Mon Feb 23 11:01:57 2004
+++ 2_6_3_rc2/drivers/md/md.c	Mon Feb 23 11:29:10 2004
@@ -2365,7 +2365,12 @@ static int hot_add_disk(mddev_t * mddev,
 		return -EINVAL;
 	}
 
-	rdev->sb_offset = calc_dev_sboffset(rdev->bdev);
+	if (mddev->persistent)
+		rdev->sb_offset = calc_dev_sboffset(rdev->bdev);
+	else
+		rdev->sb_offset = rdev->bdev->bd_inode->i_size
+							>> BLOCK_SIZE_BITS;
+
 	size = calc_dev_size(rdev, mddev->chunk_size);
 	rdev->size = size;
 

--------------0F7B22E4CB6C4C1E76FD28F5--

