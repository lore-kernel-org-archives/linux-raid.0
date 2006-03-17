From: NeilBrown <neilb@suse.de>
Subject: [PATCH 001 of 13] md: Add '4' to the list of levels for which bitmaps are supported.
Date: Fri, 17 Mar 2006 15:47:26 +1100
Message-ID: <1060317044726.16023@suse.de>
References: <20060317154017.15880.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


I really should make this a function of the personality....


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2006-03-17 11:45:43.000000000 +1100
+++ ./drivers/md/md.c	2006-03-17 11:48:08.000000000 +1100
@@ -763,7 +763,8 @@ static int super_90_validate(mddev_t *md
 
 		if (sb->state & (1<<MD_SB_BITMAP_PRESENT) &&
 		    mddev->bitmap_file == NULL) {
-			if (mddev->level != 1 && mddev->level != 5 && mddev->level != 6
+			if (mddev->level != 1 && mddev->level != 4
+			    && mddev->level != 5 && mddev->level != 6
 			    && mddev->level != 10) {
 				/* FIXME use a better test */
 				printk(KERN_WARNING "md: bitmaps not supported for this level.\n");
