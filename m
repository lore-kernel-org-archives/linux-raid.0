From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 2 of 5] Discard calc_sb_csum_common in favour of csum_fold
Date: Wed, 20 Oct 2004 13:26:21 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1CK77F-0008IO-54@notabene.cse.unsw.edu.au>
References: <20041020132354.31830.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


csum_fold should always have been used on the result
of csum_partial.  calc_sb_csum_common therefore isn't needed.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/md.c |   27 +--------------------------
 1 files changed, 1 insertion(+), 26 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2004-10-20 13:21:25.000000000 +1000
+++ ./drivers/md/md.c	2004-10-20 13:21:25.000000000 +1000
@@ -483,30 +483,6 @@ static unsigned int calc_sb_csum(mdp_sup
 	return csum;
 }
 
-/* csum_partial is not consistent between different architectures.
- * Some (i386) do a 32bit csum.  Some (alpha) do 16 bit.
- * This makes it hard for user-space to know what to do.
- * So we use calc_sb_csum to set the checksum to allow working
- * with older kernels, but allow calc_sb_csum_common to
- * be used when checking if a checksum is correct, to
- * make life easier for user-space tools that might write
- * a superblock.
- */
-static unsigned int calc_sb_csum_common(mdp_super_t *super)
-{
-	unsigned int  disk_csum = super->sb_csum;
-	unsigned long long newcsum = 0;
-	unsigned int csum;
-	int i;
-	unsigned int *superc = (int*) super;
-	super->sb_csum = 0;
-
-	for (i=0; i<MD_SB_BYTES/4; i++)
-		newcsum+= superc[i];
-	csum = (newcsum& 0xffffffff) + (newcsum>>32);
-	super->sb_csum = disk_csum;
-	return csum;
-}
 
 /*
  * Handle superblock details.
@@ -590,8 +566,7 @@ static int super_90_load(mdk_rdev_t *rde
 	if (sb->raid_disks <= 0)
 		goto abort;
 
-	if (calc_sb_csum(sb) != sb->sb_csum &&
-		calc_sb_csum_common(sb) != sb->sb_csum) {
+	if (csum_fold(calc_sb_csum(sb)) != csum_fold(sb->sb_csum)) {
 		printk(KERN_WARNING "md: invalid superblock checksum on %s\n",
 			b);
 		goto abort;
