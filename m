From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 3 of 9] Remove kludgy level check from md.c
Date: Fri, 18 Feb 2005 11:40:44 +1100
Message-ID: <E1D1wCK-0000X5-9g@notabene.cse.unsw.edu.au>
References: <20050218111131.790.patches@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


This test is overly specific, and misses raid10.
Assume all levels >= 1 might need reconstruction instead.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/md.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-02-18 11:11:11.000000000 +1100
+++ ./drivers/md/md.c	2005-02-18 11:11:17.000000000 +1100
@@ -1478,9 +1478,8 @@ static int analyze_sbs(mddev_t * mddev)
 
 
 
-	if ((mddev->recovery_cp != MaxSector) &&
-	    ((mddev->level == 1) ||
-	     ((mddev->level >= 4) && (mddev->level <= 6))))
+	if (mddev->recovery_cp != MaxSector &&
+	    mddev->level >= 1)
 		printk(KERN_ERR "md: %s: raid array is not clean"
 		       " -- starting background reconstruction\n",
 		       mdname(mddev));
