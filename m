From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] MD - 6 of 27 - Don't "analyze_sb" when creating new array.
Date: Thu, 18 Jul 2002 23:32:50 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1020718133250.4814@cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


### Comments for ChangeSet
Don't "analyze_sb" when creating new array.

When creating a new array (and we have an mddev->sb),
don't both to analyze the superblocks.  There is no point.
Also, these means we always allocate the array sb in
analyze_sbs, rather than conditionally.







 ----------- Diffstat output ------------
 ./drivers/md/md.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

--- ./drivers/md/md.c	2002/07/18 12:00:28	1.1
+++ ./drivers/md/md.c	2002/07/18 12:00:31	1.2
@@ -1143,9 +1143,8 @@ static int analyze_sbs(mddev_t * mddev)
 	 * find the freshest superblock, that one will be the superblock
 	 * that represents the whole array.
 	 */
-	if (!mddev->sb)
-		if (alloc_array_sb(mddev))
-			goto abort;
+	if (alloc_array_sb(mddev))
+		goto abort;
 	sb = mddev->sb;
 	freshest = NULL;
 
@@ -1562,7 +1561,7 @@ static int do_md_run(mddev_t * mddev)
 	/*
 	 * Analyze all RAID superblock(s)
 	 */
-	if (analyze_sbs(mddev)) {
+	if (!mddev->sb && analyze_sbs(mddev)) {
 		MD_BUG();
 		return -EINVAL;
 	}
