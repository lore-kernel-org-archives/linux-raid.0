From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH] imsm: FIX: Use definitions for migration record disk
	operations
Date: Thu, 08 Dec 2011 09:47:37 +0100
Message-ID: <20111208084737.7807.25355.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

Add definition:
  MIGR_REC_BUF_SIZE
  MIGR_REC_POSITION
to super-intel.c and do not use magic numbers

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   28 +++++++++++++++++++---------
 1 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 4918f42..96b8547 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -240,6 +240,12 @@ static char *map_state_str[] = { "normal", "uninitialized", "degraded", "failed"
 
 #define GEN_MIGR_AREA_SIZE 2048 /* General Migration Copy Area size in blocks */
 
+#define MIGR_REC_BUF_SIZE 512 /* size of migr_record i/o buffer */
+#define MIGR_REC_POSITION 512 /* migr_record position offset on disk,
+			       * MIGR_REC_BUF_SIZE <= MIGR_REC_POSITION
+			       */
+
+
 #define UNIT_SRC_NORMAL     0   /* Source data for curr_migr_unit must
 				 *  be recovered using srcMap */
 #define UNIT_SRC_IN_CP_AREA 1   /* Source data for curr_migr_unit has
@@ -2072,13 +2078,14 @@ static int read_imsm_migr_rec(int fd, struct intel_super *super)
 	unsigned long long dsize;
 
 	get_dev_size(fd, NULL, &dsize);
-	if (lseek64(fd, dsize - 512, SEEK_SET) < 0) {
+	if (lseek64(fd, dsize - MIGR_REC_POSITION, SEEK_SET) < 0) {
 		fprintf(stderr,
 			Name ": Cannot seek to anchor block: %s\n",
 			strerror(errno));
 		goto out;
 	}
-	if (read(fd, super->migr_rec_buf, 512) != 512) {
+	if (read(fd, super->migr_rec_buf, MIGR_REC_BUF_SIZE) !=
+							    MIGR_REC_BUF_SIZE) {
 		fprintf(stderr,
 			Name ": Cannot read migr record block: %s\n",
 			strerror(errno));
@@ -2281,13 +2288,14 @@ static int write_imsm_migr_rec(struct supertype *st)
 		if (fd < 0)
 			continue;
 		get_dev_size(fd, NULL, &dsize);
-		if (lseek64(fd, dsize - 512, SEEK_SET) < 0) {
+		if (lseek64(fd, dsize - MIGR_REC_POSITION, SEEK_SET) < 0) {
 			fprintf(stderr,
 				Name ": Cannot seek to anchor block: %s\n",
 				strerror(errno));
 			goto out;
 		}
-		if (write(fd, super->migr_rec_buf, 512) != 512) {
+		if (write(fd, super->migr_rec_buf, MIGR_REC_BUF_SIZE) !=
+							    MIGR_REC_BUF_SIZE) {
 			fprintf(stderr,
 				Name ": Cannot write migr record block: %s\n",
 				strerror(errno));
@@ -3421,7 +3429,7 @@ static int load_imsm_mpb(int fd, struct intel_super *super, char *devname)
 	sectors = mpb_sectors(anchor) - 1;
 	free(anchor);
 
-	if (posix_memalign(&super->migr_rec_buf, 512, 512) != 0) {
+	if (posix_memalign(&super->migr_rec_buf, 512, MIGR_REC_BUF_SIZE) != 0) {
 		fprintf(stderr, Name
 			": %s could not allocate migr_rec buffer\n", __func__);
 		free(super->buf);
@@ -4318,7 +4326,8 @@ static int init_super_imsm_volume(struct supertype *st, mdu_array_info_t *info,
 			fprintf(stderr, Name": could not allocate new mpb\n");
 			return 0;
 		}
-		if (posix_memalign(&super->migr_rec_buf, 512, 512) != 0) {
+		if (posix_memalign(&super->migr_rec_buf, 512,
+				   MIGR_REC_BUF_SIZE) != 0) {
 			fprintf(stderr, Name
 				": %s could not allocate migr_rec buffer\n",
 				__func__);
@@ -4486,7 +4495,7 @@ static int init_super_imsm(struct supertype *st, mdu_array_info_t *info,
 			": %s could not allocate superblock\n", __func__);
 		return 0;
 	}
-	if (posix_memalign(&super->migr_rec_buf, 512, 512) != 0) {
+	if (posix_memalign(&super->migr_rec_buf, 512, MIGR_REC_BUF_SIZE) != 0) {
 		fprintf(stderr, Name
 			": %s could not allocate migr_rec buffer\n", __func__);
 		free(super->buf);
@@ -4880,7 +4889,7 @@ static int write_super_imsm(struct supertype *st, int doclose)
 	mpb->check_sum = __cpu_to_le32(sum);
 
 	if (clear_migration_record)
-		memset(super->migr_rec_buf, 0, 512);
+		memset(super->migr_rec_buf, 0, MIGR_REC_BUF_SIZE);
 
 	/* write the mpb for disks that compose raid devices */
 	for (d = super->disks; d ; d = d->next) {
@@ -4894,7 +4903,8 @@ static int write_super_imsm(struct supertype *st, int doclose)
 
 			get_dev_size(d->fd, NULL, &dsize);
 			if (lseek64(d->fd, dsize - 512, SEEK_SET) >= 0) {
-				if (write(d->fd, super->migr_rec_buf, 512) != 512)
+				if (write(d->fd, super->migr_rec_buf,
+					MIGR_REC_BUF_SIZE) != MIGR_REC_BUF_SIZE)
 					perror("Write migr_rec failed");
 			}
 		}

