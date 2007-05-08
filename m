From: NeilBrown <neilb@suse.de>
Subject: [PATCH 002 of 5] md: Stop using csum_partial for checksum calculation in md.
Date: Tue, 8 May 2007 14:29:23 +1000
Message-ID: <1070508042923.28749@suse.de>
References: <20070508142718.28571.patches@notabene>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S967797AbXEHEaF@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids


If CONFIG_NET is not selected, csum_partial is not exported, so
md.ko cannot use it.
We shouldn't really be using csum_partial anyway as it is an
internal-to-networking interface.

So replace it with C code to do the same thing.  Speed is not
crucial here, so something simple and correct is best.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |   31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2007-05-07 14:33:31.000000000 +1000
+++ ./drivers/md/md.c	2007-05-07 14:57:41.000000000 +1000
@@ -590,14 +590,41 @@ abort:
 	return ret;
 }
 
+
+static u32 md_csum_fold(u32 csum)
+{
+	csum = (csum & 0xffff) + (csum >> 16);
+	return (csum & 0xffff) + (csum >> 16);
+}
+
 static unsigned int calc_sb_csum(mdp_super_t * sb)
 {
+	u64 newcsum = 0;
+	u32 *sb32 = (u32*)sb;
+	int i;
 	unsigned int disk_csum, csum;
 
 	disk_csum = sb->sb_csum;
 	sb->sb_csum = 0;
-	csum = csum_partial((void *)sb, MD_SB_BYTES, 0);
+
+	for (i = 0; i < MD_SB_BYTES/4 ; i++)
+		newcsum += sb32[i];
+	csum = (newcsum & 0xffffffff) + (newcsum>>32);
+
+
+#ifdef CONFIG_ALPHA
+	/* This used to use csum_partial, which was wrong for several
+	 * reasons including that different results are returned on
+	 * different architectures.  It isn't critical that we get exactly
+	 * the same return value as before (we always csum_fold before
+	 * testing, and that removes any differences).  However as we
+	 * know that csum_partial always returned a 16bit value on
+	 * alphas, do a fold to maximise conformity to previous behaviour.
+	 */
+	sb->sb_csum = md_csum_fold(disk_csum);
+#else
 	sb->sb_csum = disk_csum;
+#endif
 	return csum;
 }
 
@@ -685,7 +712,7 @@ static int super_90_load(mdk_rdev_t *rde
 	if (sb->raid_disks <= 0)
 		goto abort;
 
-	if (csum_fold(calc_sb_csum(sb)) != csum_fold(sb->sb_csum)) {
+	if (md_csum_fold(calc_sb_csum(sb)) != md_csum_fold(sb->sb_csum)) {
 		printk(KERN_WARNING "md: invalid superblock checksum on %s\n",
 			b);
 		goto abort;
