From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 18/23] md/bitmap: change a 'goto' to a normal 'if'
 construct.
Date: Wed, 14 Mar 2012 15:40:41 +1100
Message-ID: <20120314044041.7978.20593.stgit@notabene.brown>
References: <20120314043555.7978.75486.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120314043555.7978.75486.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The use of a goto makes the control flow more obscure here.

So make it a normal:
  if (x) {
     Y;
  }

No functional change.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/bitmap.c |   40 +++++++++++++++++++++-------------------
 1 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 04df18e..fcf3c94 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -633,26 +633,28 @@ static int bitmap_read_sb(struct bitmap *bitmap)
 	/* keep the array size field of the bitmap superblock up to date */
 	sb->sync_size = cpu_to_le64(bitmap->mddev->resync_max_sectors);
 
-	if (!bitmap->mddev->persistent)
-		goto success;
-
-	/*
-	 * if we have a persistent array superblock, compare the
-	 * bitmap's UUID and event counter to the mddev's
-	 */
-	if (memcmp(sb->uuid, bitmap->mddev->uuid, 16)) {
-		printk(KERN_INFO "%s: bitmap superblock UUID mismatch\n",
-			bmname(bitmap));
-		goto out;
-	}
-	events = le64_to_cpu(sb->events);
-	if (events < bitmap->mddev->events) {
-		printk(KERN_INFO "%s: bitmap file is out of date (%llu < %llu) "
-			"-- forcing full recovery\n", bmname(bitmap), events,
-			(unsigned long long) bitmap->mddev->events);
-		sb->state |= cpu_to_le32(BITMAP_STALE);
+	if (bitmap->mddev->persistent) {
+		/*
+		 * We have a persistent array superblock, so compare the
+		 * bitmap's UUID and event counter to the mddev's
+		 */
+		if (memcmp(sb->uuid, bitmap->mddev->uuid, 16)) {
+			printk(KERN_INFO
+			       "%s: bitmap superblock UUID mismatch\n",
+			       bmname(bitmap));
+			goto out;
+		}
+		events = le64_to_cpu(sb->events);
+		if (events < bitmap->mddev->events) {
+			printk(KERN_INFO
+			       "%s: bitmap file is out of date (%llu < %llu) "
+			       "-- forcing full recovery\n",
+			       bmname(bitmap), events,
+			       (unsigned long long) bitmap->mddev->events);
+			sb->state |= cpu_to_le32(BITMAP_STALE);
+		}
 	}
-success:
+
 	/* assign fields using values from superblock */
 	bitmap->mddev->bitmap_info.chunksize = chunksize;
 	bitmap->mddev->bitmap_info.daemon_sleep = daemon_sleep;


