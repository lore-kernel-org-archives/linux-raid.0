From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 002 of 2] Clear the 'recovery' flags when starting an md array.
Date: Fri, 26 Aug 2005 17:25:19 +1000
Message-ID: <E1E8YaV-0004FQ-Vh@notabene.cse.unsw.edu.au>
References: <20050826172148.16280.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


It possibly for this to still have flags in it and a previous
instance has been stopped, and that confused the new array using
the same mddev.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/md.c |    1 +
 1 files changed, 1 insertion(+)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-08-26 17:01:48.000000000 +1000
+++ ./drivers/md/md.c	2005-08-26 17:04:20.000000000 +1000
@@ -1701,6 +1701,7 @@ static int do_md_run(mddev_t * mddev)
 	mddev->pers = pers[pnum];
 	spin_unlock(&pers_lock);
 
+	mddev->recovery = 0;
 	mddev->resync_max_sectors = mddev->size << 1; /* may be over-ridden by personality */
 
 	/* before we start the array running, initialise the bitmap */
