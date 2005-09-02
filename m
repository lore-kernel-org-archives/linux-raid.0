From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 002 of 5] Choose better default offset for bitmap.
Date: Fri, 02 Sep 2005 16:12:53 +1000
Message-ID: <E1EB4nF-0008N9-Gv@notabene.cse.unsw.edu.au>
References: <20050902161106.32018.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On reflection, a better default location for hot-adding
bitmaps with version-1 superblocks is immediately after
the superblock.  There might not be much room there, but
there is usually atleast 3k, and that is a good start.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-09-02 15:59:28.000000000 +1000
+++ ./drivers/md/md.c	2005-09-02 15:59:39.000000000 +1000
@@ -957,8 +957,7 @@ static int super_1_validate(mddev_t *mdd
 		mddev->events = le64_to_cpu(sb->events);
 		mddev->bitmap_offset = 0;
 		mddev->default_bitmap_offset = 0;
-		if (mddev->minor_version == 0)
-			mddev->default_bitmap_offset = -(64*1024)/512;
+		mddev->default_bitmap_offset = 1024;
 		
 		mddev->recovery_cp = le64_to_cpu(sb->resync_offset);
 		memcpy(mddev->uuid, sb->set_uuid, 16);
