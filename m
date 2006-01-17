From: NeilBrown <neilb@suse.de>
Subject: [PATCH] md: Clear clevel whenever level is set.
Date: Tue, 17 Jan 2006 16:49:50 +1100
Message-ID: <1060117054950.14851@suse.de>
References: <20060117164838.14832.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This patch fixes a little bug in 2.6.15-mm3
--

The 'level' of an md array can be set as either a number of a string.
When one is set, the other must be marked 'undefined'.
This wasn't being done in one place: where new arrays are created.

Result: if md1 is a raid1, it is stopped and a raid5 is created there,
it might still appear to be a raid1.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    1 +
 1 file changed, 1 insertion(+)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2006-01-17 10:39:30.000000000 +1100
+++ ./drivers/md/md.c	2006-01-17 10:37:38.000000000 +1100
@@ -3392,6 +3392,7 @@ static int set_array_info(mddev_t * mdde
 	mddev->ctime         = get_seconds();
 
 	mddev->level         = info->level;
+	mddev->clevel[0]     = 0;
 	mddev->size          = info->size;
 	mddev->raid_disks    = info->raid_disks;
 	/* don't set md_minor, it is determined by which /dev/md* was
