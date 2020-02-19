From: Blazej Kucman <blazej.kucman@intel.com>
Subject: [PATCH] imsm: Remove --dump/--restore implementation
Date: Wed, 19 Feb 2020 11:13:17 +0100
Message-ID: <20200219101317.30293-1-blazej.kucman@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: jes.sorensen@gmail.com
List-Id: linux-raid.ids

Functionalities --dump and --restore are not supported.
Remove dead code from imsm.

Signed-off-by: Blazej Kucman <blazej.kucman@intel.com>
---
 super-intel.c | 56 --------------------------------------------------------
 1 file changed, 56 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 47809bc2..b5652fd3 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -2128,61 +2128,6 @@ static void export_examine_super_imsm(struct supertype *st)
 	printf("MD_DEVICES=%u\n", mpb->num_disks);
 }
 
-static int copy_metadata_imsm(struct supertype *st, int from, int to)
-{
-	/* The second last sector of the device contains
-	 * the "struct imsm_super" metadata.
-	 * This contains mpb_size which is the size in bytes of the
-	 * extended metadata.  This is located immediately before
-	 * the imsm_super.
-	 * We want to read all that, plus the last sector which
-	 * may contain a migration record, and write it all
-	 * to the target.
-	 */
-	void *buf;
-	unsigned long long dsize, offset;
-	int sectors;
-	struct imsm_super *sb;
-	struct intel_super *super = st->sb;
-	unsigned int sector_size = super->sector_size;
-	unsigned int written = 0;
-
-	if (posix_memalign(&buf, MAX_SECTOR_SIZE, MAX_SECTOR_SIZE) != 0)
-		return 1;
-
-	if (!get_dev_size(from, NULL, &dsize))
-		goto err;
-
-	if (lseek64(from, dsize-(2*sector_size), 0) < 0)
-		goto err;
-	if ((unsigned int)read(from, buf, sector_size) != sector_size)
-		goto err;
-	sb = buf;
-	if (strncmp((char*)sb->sig, MPB_SIGNATURE, MPB_SIG_LEN) != 0)
-		goto err;
-
-	sectors = mpb_sectors(sb, sector_size) + 2;
-	offset = dsize - sectors * sector_size;
-	if (lseek64(from, offset, 0) < 0 ||
-	    lseek64(to, offset, 0) < 0)
-		goto err;
-	while (written < sectors * sector_size) {
-		int n = sectors*sector_size - written;
-		if (n > 4096)
-			n = 4096;
-		if (read(from, buf, n) != n)
-			goto err;
-		if (write(to, buf, n) != n)
-			goto err;
-		written += n;
-	}
-	free(buf);
-	return 0;
-err:
-	free(buf);
-	return 1;
-}
-
 static void detail_super_imsm(struct supertype *st, char *homehost,
 			      char *subarray)
 {
@@ -12271,7 +12216,6 @@ struct superswitch super_imsm = {
 	.reshape_super  = imsm_reshape_super,
 	.manage_reshape = imsm_manage_reshape,
 	.recover_backup = recover_backup_imsm,
-	.copy_metadata = copy_metadata_imsm,
 	.examine_badblocks = examine_badblocks_imsm,
 	.match_home	= match_home_imsm,
 	.uuid_from_super= uuid_from_super_imsm,
-- 
2.16.4
