From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md ] Fix problems with checksum handling in MD superblocks.
Date: Mon, 09 Aug 2004 11:48:47 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1BtzHL-000261-L3@notabene.cse.unsw.edu.au>
References: <20040809114809.8044.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, Mike Tran <mhtran@us.ibm.com>
List-Id: linux-raid.ids

### Comments for Changeset

md currently uses csum_partial to calculate checksums for superblocks.
However this function is not consistent across all architectures.
Some (i386) to a 32bit csum. Some (alpha) do a 16 bit csum.
This makes it hard for userspace to keep up.

So we provide a generic routine (that does exactly what the i386
csum_partial does) and:

 -When setting the csum, use csum_partial so that old kernels
  will still recognise the superblock
 -When checking the csum, allow either csum_partial or the new
  generic code to provide the right csum.  This allows user-space to
  just use the common code and always work.

Also modify the csum for version-1 superblock (which currently aren't being
used) to always user a predictable checksum algorithm.

Thanks to  Mike Tran <mhtran@us.ibm.com> for noticing this.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/md.c |   40 ++++++++++++++++++++++++++++++++++++++--
 1 files changed, 38 insertions(+), 2 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2004-08-06 15:37:54.000000000 +1000
+++ ./drivers/md/md.c	2004-08-06 15:43:07.000000000 +1000
@@ -472,6 +472,31 @@ static unsigned int calc_sb_csum(mdp_sup
 	return csum;
 }
 
+/* csum_partial is not consistent between different architectures.
+ * Some (i386) do a 32bit csum.  Some (alpha) do 16 bit.
+ * This makes it hard for user-space to know what to do.
+ * So we use calc_sb_csum to set the checksum to allow working
+ * with older kernels, but allow calc_sb_csum_common to
+ * be used when checking if a checksum is correct, to
+ * make life easier for user-space tools that might write 
+ * a superblock.
+ */
+static unsigned int calc_sb_csum_common(mdp_super_t *super)
+{
+	unsigned int  disk_csum = super->sb_csum;
+	unsigned long long newcsum = 0;
+	unsigned int csum;
+	int i;
+	unsigned int *superc = (int*) super;
+	super->sb_csum = 0;
+                                                                              
+	for (i=0; i<MD_SB_BYTES/4; i++)
+		newcsum+= superc[i];
+	csum = (newcsum& 0xffffffff) + (newcsum>>32);
+	super->sb_csum = disk_csum;
+	return csum;
+}
+
 /*
  * Handle superblock details.
  * We want to be able to handle multiple superblock formats
@@ -554,7 +579,8 @@ static int super_90_load(mdk_rdev_t *rde
 	if (sb->raid_disks <= 0)
 		goto abort;
 
-	if (calc_sb_csum(sb) != sb->sb_csum) {
+	if (calc_sb_csum(sb) != sb->sb_csum &&
+		calc_sb_csum_common(sb) != sb->sb_csum) {
 		printk(KERN_WARNING "md: invalid superblock checksum on %s\n",
 			b);
 		goto abort;
@@ -778,11 +804,21 @@ static void super_90_sync(mddev_t *mddev
 static unsigned int calc_sb_1_csum(struct mdp_superblock_1 * sb)
 {
 	unsigned int disk_csum, csum;
+	unsigned long long newcsum;
 	int size = 256 + sb->max_dev*2;
+	unsigned int *isuper = (unsigned int*)sb;
+	int i;
 
 	disk_csum = sb->sb_csum;
 	sb->sb_csum = 0;
-	csum = csum_partial((void *)sb, size, 0);
+	newcsum = 0;
+	for (i=0; size>=4; size -= 4 )
+		newcsum += le32_to_cpu(*isuper++);
+
+	if (size == 2)
+		newcsum += le16_to_cpu(*(unsigned short*) isuper);
+
+	csum = (newcsum & 0xffffffff) + (newcsum >> 32);
 	sb->sb_csum = disk_csum;
 	return csum;
 }
