From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 04/17] md: remove the autoscan partition re-read
Date: Thu,  9 Jul 2020 17:18:01 +0200
Message-ID: <20200709151814.110422-5-hch@lst.de>
References: <20200709151814.110422-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20200709151814.110422-1-hch@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Song Liu <song@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

devfs is long gone, and autoscan works just fine without this these days.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/md-autodetect.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/md/md-autodetect.c b/drivers/md/md-autodetect.c
index 0eb746211ed53c..6bc9b734eee6ff 100644
--- a/drivers/md/md-autodetect.c
+++ b/drivers/md/md-autodetect.c
@@ -240,16 +240,6 @@ static void __init md_setup_drive(void)
 			err = ksys_ioctl(fd, RUN_ARRAY, 0);
 		if (err)
 			printk(KERN_WARNING "md: starting md%d failed\n", minor);
-		else {
-			/* reread the partition table.
-			 * I (neilb) and not sure why this is needed, but I cannot
-			 * boot a kernel with devfs compiled in from partitioned md
-			 * array without it
-			 */
-			ksys_close(fd);
-			fd = ksys_open(name, 0, 0);
-			ksys_ioctl(fd, BLKRRPART, 0);
-		}
 		ksys_close(fd);
 	}
 }
-- 
2.26.2
