From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 3 of 12] Improve debug-printing of bitmap superblock.
Date: Wed, 23 Mar 2005 16:47:10 +1100
Message-ID: <E1DDyhy-0004GW-U0@notabene.cse.unsw.edu.au>
References: <20050323164208.16240.patches@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


- report sync_size properly  - need /2 to convert sectors to KB
- move everything over 2 spaces to allow proper spelling of
  "events cleared".


Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/bitmap.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff ./drivers/md/bitmap.c~current~ ./drivers/md/bitmap.c
--- ./drivers/md/bitmap.c~current~	2005-03-22 17:12:09.000000000 +1100
+++ ./drivers/md/bitmap.c	2005-03-22 17:13:16.000000000 +1100
@@ -364,22 +364,22 @@ void bitmap_print_sb(struct bitmap *bitm
 		return;
 	sb = (bitmap_super_t *)kmap(bitmap->sb_page);
 	printk(KERN_DEBUG "%s: bitmap file superblock:\n", bmname(bitmap));
-	printk(KERN_DEBUG "       magic: %08x\n", le32_to_cpu(sb->magic));
-	printk(KERN_DEBUG "     version: %d\n", le32_to_cpu(sb->version));
-	printk(KERN_DEBUG "        uuid: %08x.%08x.%08x.%08x\n",
+	printk(KERN_DEBUG "         magic: %08x\n", le32_to_cpu(sb->magic));
+	printk(KERN_DEBUG "       version: %d\n", le32_to_cpu(sb->version));
+	printk(KERN_DEBUG "          uuid: %08x.%08x.%08x.%08x\n",
 					*(__u32 *)(sb->uuid+0),
 					*(__u32 *)(sb->uuid+4),
 					*(__u32 *)(sb->uuid+8),
 					*(__u32 *)(sb->uuid+12));
-	printk(KERN_DEBUG "      events: %llu\n",
+	printk(KERN_DEBUG "        events: %llu\n",
 			(unsigned long long) le64_to_cpu(sb->events));
-	printk(KERN_DEBUG "events_clred: %llu\n",
+	printk(KERN_DEBUG "events cleared: %llu\n",
 			(unsigned long long) le64_to_cpu(sb->events_cleared));
-	printk(KERN_DEBUG "       state: %08x\n", le32_to_cpu(sb->state));
-	printk(KERN_DEBUG "   chunksize: %d B\n", le32_to_cpu(sb->chunksize));
-	printk(KERN_DEBUG "daemon sleep: %ds\n", le32_to_cpu(sb->daemon_sleep));
-	printk(KERN_DEBUG "   sync size: %llu KB\n",
-			(unsigned long long)le64_to_cpu(sb->sync_size));
+	printk(KERN_DEBUG "         state: %08x\n", le32_to_cpu(sb->state));
+	printk(KERN_DEBUG "     chunksize: %d B\n", le32_to_cpu(sb->chunksize));
+	printk(KERN_DEBUG "  daemon sleep: %ds\n", le32_to_cpu(sb->daemon_sleep));
+	printk(KERN_DEBUG "     sync size: %llu KB\n",
+			(unsigned long long)le64_to_cpu(sb->sync_size)/2);
 	kunmap(bitmap->sb_page);
 }
 
