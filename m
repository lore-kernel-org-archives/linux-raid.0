From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 8 of 12] A couple of tidyups relating to the bitmap file.
Date: Wed, 23 Mar 2005 16:47:11 +1100
Message-ID: <E1DDyhz-0004Gq-G7@notabene.cse.unsw.edu.au>
References: <20050323164208.16240.patches@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


1/ When init from disk, it is a BUG if there is nowhere
   to init from,
2/ use seq_path to print path in /proc/mdstat


Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/bitmap.c |    8 +-------
 ./drivers/md/md.c     |   11 +++++------
 2 files changed, 6 insertions(+), 13 deletions(-)

diff ./drivers/md/bitmap.c~current~ ./drivers/md/bitmap.c
--- ./drivers/md/bitmap.c~current~	2005-03-22 17:20:50.000000000 +1100
+++ ./drivers/md/bitmap.c	2005-03-22 17:21:47.000000000 +1100
@@ -764,13 +764,7 @@ static int bitmap_init_from_disk(struct 
 	chunks = bitmap->chunks;
 	file = bitmap->file;
 
-	if (!file) { /* no file, dirty all the in-memory bits */
-		printk(KERN_INFO "%s: no bitmap file, doing full recovery\n",
-			bmname(bitmap));
-		bitmap_set_memory_bits(bitmap, 0,
-				       chunks << CHUNK_BLOCK_SHIFT(bitmap), 1);
-		return 0;
-	}
+	BUG_ON(!file);
 
 #if INJECT_FAULTS_3
 	outofdate = 1;

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-03-22 17:20:16.000000000 +1100
+++ ./drivers/md/md.c	2005-03-22 17:21:30.000000000 +1100
@@ -3259,10 +3259,8 @@ static int md_seq_show(struct seq_file *
 			seq_printf(seq, "\n       ");
 
 		if ((bitmap = mddev->bitmap)) {
-			char *buf, *path;
 			unsigned long chunk_kb;
 			unsigned long flags;
-			buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
 			spin_lock_irqsave(&bitmap->lock, flags);
 			chunk_kb = bitmap->chunksize >> 10;
 			seq_printf(seq, "bitmap: %lu/%lu pages [%luKB], "
@@ -3273,13 +3271,14 @@ static int md_seq_show(struct seq_file *
 					<< (PAGE_SHIFT - 10),
 				chunk_kb ? chunk_kb : bitmap->chunksize,
 				chunk_kb ? "KB" : "B");
-			if (bitmap->file && buf) {
-				path = file_path(bitmap->file, buf, PAGE_SIZE);
-				seq_printf(seq, ", file: %s", path ? path : "");
+			if (bitmap->file) {
+				seq_printf(seq, ", file: ");
+				seq_path(seq, bitmap->file->f_vfsmnt, 
+					 bitmap->file->f_dentry," \t\n");
 			}
+
 			seq_printf(seq, "\n");
 			spin_unlock_irqrestore(&bitmap->lock, flags);
-			kfree(buf);
 		}
 
 		seq_printf(seq, "\n");
