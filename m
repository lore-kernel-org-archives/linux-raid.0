From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 004 of 18] Set default_bitmap_offset properly in set_array_info
Date: Mon, 28 Nov 2005 10:39:57 +1100
Message-ID: <1051127233957.14781@suse.de>
References: <20051128102824.14498.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


If an array is created using set_array_info, default_bitmap_offset
isn't set properly meaning that an internal bitmap cannot be hot-added until
the array is stopped and re-assembled.


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-11-28 10:08:19.000000000 +1100
+++ ./drivers/md/md.c	2005-11-28 10:10:54.000000000 +1100
@@ -1028,7 +1028,6 @@ static int super_1_validate(mddev_t *mdd
 		mddev->size = le64_to_cpu(sb->size)/2;
 		mddev->events = le64_to_cpu(sb->events);
 		mddev->bitmap_offset = 0;
-		mddev->default_bitmap_offset = 0;
 		mddev->default_bitmap_offset = 1024;
 		
 		mddev->recovery_cp = le64_to_cpu(sb->resync_offset);
@@ -2932,6 +2931,9 @@ static int set_array_info(mddev_t * mdde
 
 	mddev->sb_dirty      = 1;
 
+	mddev->default_bitmap_offset = MD_SB_BYTES >> 9;
+	mddev->bitmap_offset = 0;
+
 	/*
 	 * Generate a 128 bit UUID
 	 */
