From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 1 of 2] Fix multipath assembly bug
Date: Thu, 10 Feb 2005 09:22:47 +1100
Message-ID: <E1Cz0ER-0000QW-TP@notabene.cse.unsw.edu.au>
References: <20050210091909.1612.patches@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


In md, there are "level" number and "personality" numbers.
LEVEL_MULTIPATH is the level number for multipath.
MULTIPATH is the personality number for multipath.

In one place, we compare the level with a personality
... bad

This makes it impossible to assemble multipath arrays.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/md.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-02-09 11:27:25.000000000 +1100
+++ ./drivers/md/md.c	2005-02-09 14:22:16.000000000 +1100
@@ -572,7 +572,7 @@ static int super_90_load(mdk_rdev_t *rde
 	rdev->preferred_minor = sb->md_minor;
 	rdev->data_offset = 0;
 
-	if (sb->level == MULTIPATH)
+	if (sb->level == LEVEL_MULTIPATH)
 		rdev->desc_nr = -1;
 	else
 		rdev->desc_nr = sb->this_disk.number;
