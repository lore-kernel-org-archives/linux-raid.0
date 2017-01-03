From: Pawel Baldysiak <pawel.baldysiak@intel.com>
Subject: [PATCH 1/1] IMSM: Fix signed/unsigned comparisons
Date: Tue,  3 Jan 2017 15:20:13 +0100
Message-ID: <20170103142013.13132-1-pawel.baldysiak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@redhat.com
Cc: linux-raid@vger.kernel.org, Pawel Baldysiak <pawel.baldysiak@intel.com>
List-Id: linux-raid.ids

Prior to this patch there was an error during compiling
on 32-bit arch. This patch fixes this issue.

Reported-by: Thomas Backlund <tmb@mageia.org>
Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
---
 super-intel.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 29b2163..0817a1f 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1945,7 +1945,7 @@ static int copy_metadata_imsm(struct supertype *st, int from, int to)
 
 	if (lseek64(from, dsize-(2*sector_size), 0) < 0)
 		goto err;
-	if (read(from, buf, sector_size) != sector_size)
+	if ((unsigned int)read(from, buf, sector_size) != sector_size)
 		goto err;
 	sb = buf;
 	if (strncmp((char*)sb->sig, MPB_SIGNATURE, MPB_SIG_LEN) != 0)
@@ -2816,7 +2816,7 @@ static int read_imsm_migr_rec(int fd, struct intel_super *super)
 		       strerror(errno));
 		goto out;
 	}
-	if (read(fd, super->migr_rec_buf,
+	if ((unsigned int)read(fd, super->migr_rec_buf,
 	    MIGR_REC_BUF_SECTORS*sector_size) !=
 	    MIGR_REC_BUF_SECTORS*sector_size) {
 		pr_err("Cannot read migr record block: %s\n",
@@ -3018,7 +3018,7 @@ static int write_imsm_migr_rec(struct supertype *st)
 			       strerror(errno));
 			goto out;
 		}
-		if (write(fd, super->migr_rec_buf,
+		if ((unsigned int)write(fd, super->migr_rec_buf,
 		    MIGR_REC_BUF_SECTORS*sector_size) !=
 		    MIGR_REC_BUF_SECTORS*sector_size) {
 			pr_err("Cannot write migr record block: %s\n",
@@ -4122,7 +4122,7 @@ static int load_imsm_mpb(int fd, struct intel_super *super, char *devname)
 			pr_err("Failed to allocate imsm anchor buffer on %s\n", devname);
 		return 1;
 	}
-	if (read(fd, anchor, sector_size) != sector_size) {
+	if ((unsigned int)read(fd, anchor, sector_size) != sector_size) {
 		if (devname)
 			pr_err("Cannot read anchor block on %s: %s\n",
 			       devname, strerror(errno));
@@ -5637,7 +5637,7 @@ static int add_to_super_imsm(struct supertype *st, mdu_disk_info_t *dk,
 	memset(super->migr_rec_buf, 0, MIGR_REC_BUF_SECTORS*super->sector_size);
 	if (lseek64(fd, size - MIGR_REC_SECTOR_POSITION*super->sector_size,
 	    SEEK_SET) >= 0) {
-		if (write(fd, super->migr_rec_buf,
+		if ((unsigned int)write(fd, super->migr_rec_buf,
 		    MIGR_REC_BUF_SECTORS*super->sector_size) !=
 		    MIGR_REC_BUF_SECTORS*super->sector_size)
 			perror("Write migr_rec failed");
@@ -5847,7 +5847,8 @@ static int write_super_imsm(struct supertype *st, int doclose)
 			get_dev_size(d->fd, NULL, &dsize);
 			if (lseek64(d->fd, dsize - sector_size,
 			    SEEK_SET) >= 0) {
-				if (write(d->fd, super->migr_rec_buf,
+				if ((unsigned int)write(d->fd,
+				    super->migr_rec_buf,
 				    MIGR_REC_BUF_SECTORS*sector_size) !=
 				    MIGR_REC_BUF_SECTORS*sector_size)
 					perror("Write migr_rec failed");
@@ -8090,7 +8091,7 @@ static int store_imsm_mpb(int fd, struct imsm_super *mpb)
 	if (lseek64(fd, dsize - (sector_size * 2), SEEK_SET) < 0)
 		return 1;
 
-	if (write(fd, buf, sector_size) != sector_size)
+	if ((unsigned int)write(fd, buf, sector_size) != sector_size)
 		return 1;
 
 	return 0;
@@ -11501,7 +11502,7 @@ static int imsm_manage_reshape(
 		get_dev_size(d->fd, NULL, &dsize);
 		if (lseek64(d->fd, dsize - MIGR_REC_SECTOR_POSITION*sector_size,
 			    SEEK_SET) >= 0) {
-			if (write(d->fd, super->migr_rec_buf,
+			if ((unsigned int)write(d->fd, super->migr_rec_buf,
 			    MIGR_REC_BUF_SECTORS*sector_size) !=
 			    MIGR_REC_BUF_SECTORS*sector_size)
 				perror("Write migr_rec failed");
-- 
2.9.3

