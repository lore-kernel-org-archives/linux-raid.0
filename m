From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 4 of 12] Minor code rearrangement in bitmap_init_from_disk
Date: Wed, 23 Mar 2005 16:47:11 +1100
Message-ID: <E1DDyhz-0004Ga-3p@notabene.cse.unsw.edu.au>
References: <20050323164208.16240.patches@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/bitmap.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff ./drivers/md/bitmap.c~current~ ./drivers/md/bitmap.c
--- ./drivers/md/bitmap.c~current~	2005-03-22 17:13:16.000000000 +1100
+++ ./drivers/md/bitmap.c	2005-03-22 17:19:19.000000000 +1100
@@ -782,7 +782,9 @@ static int bitmap_init_from_disk(struct 
 			"recovery\n", bmname(bitmap));
 
 	bytes = (chunks + 7) / 8;
-	num_pages = (bytes + PAGE_SIZE - 1) / PAGE_SIZE;
+
+	num_pages = (bytes + sizeof(bitmap_super_t) + PAGE_SIZE - 1) / PAGE_SIZE + 1;
+
 	if (i_size_read(file->f_mapping->host) < bytes + sizeof(bitmap_super_t)) {
 		printk(KERN_INFO "%s: bitmap file too short %lu < %lu\n",
 			bmname(bitmap),
@@ -790,18 +792,16 @@ static int bitmap_init_from_disk(struct 
 			bytes + sizeof(bitmap_super_t));
 		goto out;
 	}
-	num_pages++;
+
+	ret = -ENOMEM;
+
 	bitmap->filemap = kmalloc(sizeof(struct page *) * num_pages, GFP_KERNEL);
-	if (!bitmap->filemap) {
-		ret = -ENOMEM;
+	if (!bitmap->filemap)
 		goto out;
-	}
 
 	bitmap->filemap_attr = kmalloc(sizeof(long) * num_pages, GFP_KERNEL);
-	if (!bitmap->filemap_attr) {
-		ret = -ENOMEM;
+	if (!bitmap->filemap_attr)
 		goto out;
-	}
 
 	memset(bitmap->filemap_attr, 0, sizeof(long) * num_pages);
 
