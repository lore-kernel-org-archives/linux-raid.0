From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 002 of 2] Remove a number of misleading calls to MD_BUG
Date: Fri, 08 Apr 2005 11:41:46 +1000
Message-ID: <E1DJiVG-0007BA-DZ@notabene.cse.unsw.edu.au>
References: <20050408113719.27541.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


The conditions that cause these calls to MD_BUG are
not kernel bugs, just oddities in what userspace is
asking for.

Also convert analyze_sbs to return void, and the value
it returned was always 0.


Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/md.c |   30 ++++++++----------------------
 1 files changed, 8 insertions(+), 22 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-04-08 11:36:35.000000000 +1000
+++ ./drivers/md/md.c	2005-04-08 11:36:47.000000000 +1000
@@ -1387,7 +1387,7 @@ abort_free:
  */
 
 
-static int analyze_sbs(mddev_t * mddev)
+static void analyze_sbs(mddev_t * mddev)
 {
 	int i;
 	struct list_head *tmp;
@@ -1441,7 +1441,6 @@ static int analyze_sbs(mddev_t * mddev)
 		       " -- starting background reconstruction\n",
 		       mdname(mddev));
 
-	return 0;
 }
 
 int mdp_major = 0;
@@ -1508,10 +1507,9 @@ static int do_md_run(mddev_t * mddev)
 	struct gendisk *disk;
 	char b[BDEVNAME_SIZE];
 
-	if (list_empty(&mddev->disks)) {
-		MD_BUG();
+	if (list_empty(&mddev->disks))
+		/* cannot run an array with no devices.. */
 		return -EINVAL;
-	}
 
 	if (mddev->pers)
 		return -EBUSY;
@@ -1519,10 +1517,8 @@ static int do_md_run(mddev_t * mddev)
 	/*
 	 * Analyze all RAID superblock(s)
 	 */
-	if (!mddev->raid_disks && analyze_sbs(mddev)) {
-		MD_BUG();
-		return -EINVAL;
-	}
+	if (!mddev->raid_disks)
+		analyze_sbs(mddev);
 
 	chunk_size = mddev->chunk_size;
 	pnum = level_to_pers(mddev->level);
@@ -1548,7 +1544,7 @@ static int do_md_run(mddev_t * mddev)
 		 * chunk-size has to be a power of 2 and multiples of PAGE_SIZE
 		 */
 		if ( (1 << ffz(~chunk_size)) != chunk_size) {
-			MD_BUG();
+			printk(KERN_ERR "chunk_size of %d not valid\n", chunk_size);
 			return -EINVAL;
 		}
 		if (chunk_size < PAGE_SIZE) {
@@ -1573,11 +1569,6 @@ static int do_md_run(mddev_t * mddev)
 		}
 	}
 
-	if (pnum >= MAX_PERSONALITY) {
-		MD_BUG();
-		return -EINVAL;
-	}
-
 #ifdef CONFIG_KMOD
 	if (!pers[pnum])
 	{
@@ -1762,10 +1753,8 @@ static void autorun_array(mddev_t *mddev
 	struct list_head *tmp;
 	int err;
 
-	if (list_empty(&mddev->disks)) {
-		MD_BUG();
+	if (list_empty(&mddev->disks))
 		return;
-	}
 
 	printk(KERN_INFO "md: running: ");
 
@@ -3128,7 +3117,6 @@ int register_md_personality(int pnum, md
 	spin_lock(&pers_lock);
 	if (pers[pnum]) {
 		spin_unlock(&pers_lock);
-		MD_BUG();
 		return -EBUSY;
 	}
 
@@ -3140,10 +3128,8 @@ int register_md_personality(int pnum, md
 
 int unregister_md_personality(int pnum)
 {
-	if (pnum >= MAX_PERSONALITY) {
-		MD_BUG();
+	if (pnum >= MAX_PERSONALITY)
 		return -EINVAL;
-	}
 
 	printk(KERN_INFO "md: %s personality unregistered\n", pers[pnum]->name);
 	spin_lock(&pers_lock);
