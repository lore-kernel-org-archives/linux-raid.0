From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: [PATCH 2/5] imsm: allocate buffer to support maximum sector size
Date: Tue,  9 May 2017 12:25:44 +0200
Message-ID: <1494325547-3028-3-git-send-email-tomasz.majchrzak@intel.com>
References: <1494325547-3028-1-git-send-email-tomasz.majchrzak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1494325547-3028-1-git-send-email-tomasz.majchrzak@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: jes.sorensen@gmail.com, Alexey Obitotskiy <aleksey.obitotskiy@intel.com>, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
List-Id: linux-raid.ids

From: Alexey Obitotskiy <aleksey.obitotskiy@intel.com>

Allocate migration record buffer to support maximum sector size. Disk with
non-matching sector size is not going to be included in the array, however
some preparation/cleanup actions still take place on it and they would
cause a crash. Clear migration record using sector size of the disk (not
array) as they might not match.

Signed-off-by: Alexey Obitotskiy <aleksey.obitotskiy@intel.com>
Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
---
 super-intel.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 2a5d848..cfb10d5 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -4229,8 +4229,8 @@ static int load_imsm_mpb(int fd, struct intel_super *super, char *devname)
 	sectors = mpb_sectors(anchor, sector_size) - 1;
 	free(anchor);
 
-	if (posix_memalign(&super->migr_rec_buf, sector_size,
-	    MIGR_REC_BUF_SECTORS*sector_size) != 0) {
+	if (posix_memalign(&super->migr_rec_buf, MAX_SECTOR_SIZE,
+	    MIGR_REC_BUF_SECTORS*MAX_SECTOR_SIZE) != 0) {
 		pr_err("could not allocate migr_rec buffer\n");
 		free(super->buf);
 		return 2;
@@ -5258,8 +5258,9 @@ static int init_super_imsm_volume(struct supertype *st, mdu_array_info_t *info,
 			pr_err("could not allocate new mpb\n");
 			return 0;
 		}
-		if (posix_memalign(&super->migr_rec_buf, sector_size,
-				   MIGR_REC_BUF_SECTORS*sector_size) != 0) {
+		if (posix_memalign(&super->migr_rec_buf, MAX_SECTOR_SIZE,
+				   MIGR_REC_BUF_SECTORS*
+				   MAX_SECTOR_SIZE) != 0) {
 			pr_err("could not allocate migr_rec buffer\n");
 			free(super->buf);
 			free(super);
@@ -5719,12 +5720,12 @@ static int add_to_super_imsm(struct supertype *st, mdu_disk_info_t *dk,
 	}
 
 	/* clear migr_rec when adding disk to container */
-	memset(super->migr_rec_buf, 0, MIGR_REC_BUF_SECTORS*super->sector_size);
-	if (lseek64(fd, size - MIGR_REC_SECTOR_POSITION*super->sector_size,
+	memset(super->migr_rec_buf, 0, MIGR_REC_BUF_SECTORS*MAX_SECTOR_SIZE);
+	if (lseek64(fd, size - MIGR_REC_SECTOR_POSITION*member_sector_size,
 	    SEEK_SET) >= 0) {
 		if ((unsigned int)write(fd, super->migr_rec_buf,
-		    MIGR_REC_BUF_SECTORS*super->sector_size) !=
-		    MIGR_REC_BUF_SECTORS*super->sector_size)
+		    MIGR_REC_BUF_SECTORS*member_sector_size) !=
+		    MIGR_REC_BUF_SECTORS*member_sector_size)
 			perror("Write migr_rec failed");
 	}
 
@@ -5916,7 +5917,7 @@ static int write_super_imsm(struct supertype *st, int doclose)
 	}
 	if (clear_migration_record)
 		memset(super->migr_rec_buf, 0,
-		    MIGR_REC_BUF_SECTORS*sector_size);
+		    MIGR_REC_BUF_SECTORS*MAX_SECTOR_SIZE);
 
 	if (sector_size == 4096)
 		convert_to_4k(super);
@@ -11770,7 +11771,7 @@ static int imsm_manage_reshape(
 	/* clear migr_rec on disks after successful migration */
 	struct dl *d;
 
-	memset(super->migr_rec_buf, 0, MIGR_REC_BUF_SECTORS*sector_size);
+	memset(super->migr_rec_buf, 0, MIGR_REC_BUF_SECTORS*MAX_SECTOR_SIZE);
 	for (d = super->disks; d; d = d->next) {
 		if (d->index < 0 || is_failed(&d->disk))
 			continue;
-- 
1.8.3.1

