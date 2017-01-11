From: Song Liu <songliubraving@fb.com>
Subject: [PATCH v2 1/2] EXPORT_SYMBOL radix_tree_lookup_slot
Date: Tue, 10 Jan 2017 17:42:50 -0800
Message-ID: <20170111014251.3236610-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuan@kylinos.cn, liuyun01@kylinos.cn, Song Liu <songliubraving@fb.com>, Jes.Sorensen@redhat.com
List-Id: linux-raid.ids

It will be used in drivers/md/raid5-cache.c

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 lib/radix-tree.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/radix-tree.c b/lib/radix-tree.c
index 6f382e0..1ee7449 100644
--- a/lib/radix-tree.c
+++ b/lib/radix-tree.c
@@ -1099,6 +1099,7 @@ void radix_tree_replace_slot(struct radix_tree_root *root,
 {
 	replace_slot(root, NULL, slot, item, true);
 }
+EXPORT_SYMBOL(radix_tree_replace_slot);
 
 /**
  * radix_tree_iter_replace - replace item in a slot
-- 
2.9.3

