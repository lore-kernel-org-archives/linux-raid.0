From: NeilBrown <neilb@suse.de>
Subject: [PATCH 001 of 3] md: Handle overflow of mdu_array_info_t->size better.
Date: Thu, 2 Feb 2006 17:02:06 +1100
Message-ID: <1060202060206.15960@suse.de>
References: <20060202165638.15890.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


mdu_array_info_t->size is 'int', which isn't big enough for the
size (in KB of each component in) some arrays.

So rather than a random overflow, set size to -1 when it cannot be set
correctly.

To update aspect on an array, userspace will sometimes:
  get_array_info
  change one field
  set_array_info

in this case, we don't want the '-1' in 'size' to change to size, or
look like a size change at all.  So test for that in update_array_info.



Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2006-02-02 16:42:56.000000000 +1100
+++ ./drivers/md/md.c	2006-02-02 16:48:47.000000000 +1100
@@ -2943,6 +2943,8 @@ static int get_array_info(mddev_t * mdde
 	info.ctime         = mddev->ctime;
 	info.level         = mddev->level;
 	info.size          = mddev->size;
+	if (info.size != mddev->size) /* overflow */
+		info.size = -1;
 	info.nr_disks      = nr;
 	info.raid_disks    = mddev->raid_disks;
 	info.md_minor      = mddev->md_minor;
@@ -3524,7 +3526,7 @@ static int update_array_info(mddev_t *md
 		)
 		return -EINVAL;
 	/* Check there is only one change */
-	if (mddev->size != info->size) cnt++;
+	if (info->size >= 0 && mddev->size != info->size) cnt++;
 	if (mddev->raid_disks != info->raid_disks) cnt++;
 	if (mddev->layout != info->layout) cnt++;
 	if ((state ^ info->state) & (1<<MD_SB_BITMAP_PRESENT)) cnt++;
@@ -3541,7 +3543,7 @@ static int update_array_info(mddev_t *md
 		else
 			return mddev->pers->reconfig(mddev, info->layout, -1);
 	}
-	if (mddev->size != info->size)
+	if (info->size >= 0 && mddev->size != info->size)
 		rv = update_size(mddev, info->size);
 
 	if (mddev->raid_disks    != info->raid_disks)
