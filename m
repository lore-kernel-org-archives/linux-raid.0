From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 02/24] Add number of nodes to bitmap structure for clustering
Date: Thu, 18 Dec 2014 10:15:23 -0600
Message-ID: <20141218161523.GA29576@shrek.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: lzhong@suse.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 drivers/md/bitmap.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bitmap.h b/drivers/md/bitmap.h
index 30210b9..6872945 100644
--- a/drivers/md/bitmap.h
+++ b/drivers/md/bitmap.h
@@ -128,10 +128,11 @@ typedef struct bitmap_super_s {
 	__le32 chunksize;    /* 52  the bitmap chunk size in bytes */
 	__le32 daemon_sleep; /* 56  seconds between disk flushes */
 	__le32 write_behind; /* 60  number of outstanding write-behind writes */
-	__le32 sectors_reserved; /* 64 number of 512-byte sectors that are
+	__le32 nodes;        /* 64 the maximum number of nodes in cluster. */
+	__le32 sectors_reserved; /* 68 number of 512-byte sectors that are
 				  * reserved for the bitmap. */
 
-	__u8  pad[256 - 68]; /* set to zero */
+	__u8  pad[256 - 72]; /* set to zero */
 } bitmap_super_t;
 
 /* notes:
-- 
2.1.2

