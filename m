From: Pawel Baldysiak <pawel.baldysiak@intel.com>
Subject: [PATCH] IMSM: Clear migration record on disks more often
Date: Tue, 20 Jan 2015 13:52:25 +0100
Message-ID: <20150120125225.3110.88243.stgit@gklab-154-222.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, pawel.baldysiak@intel.com, artur.paszkiewicz@intel.com
List-Id: linux-raid.ids

Migration record is not always cleared after successful migration. This can
block another reshape from being started. Migration will not be continued via
systemd service due to error in verifying reshape position. This patch added
clearing migration record when disk is added to container, and after successful
migration.

Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
---
 super-intel.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/super-intel.c b/super-intel.c
index 4c53019..2406991 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5055,6 +5055,14 @@ static int add_to_super_imsm(struct supertype *st, mdu_disk_info_t *dk,
 	}
 
 	get_dev_size(fd, NULL, &size);
+	/* clear migr_rec when adding disk to container */
+	memset(super->migr_rec_buf, 0, MIGR_REC_BUF_SIZE);
+	if (lseek64(fd, size - 512, SEEK_SET) >= 0) {
+		if (write(fd, super->migr_rec_buf,
+			MIGR_REC_BUF_SIZE) != MIGR_REC_BUF_SIZE)
+			perror("Write migr_rec failed");
+	}
+
 	size /= 512;
 	serialcpy(dd->disk.serial, dd->serial);
 	set_total_blocks(&dd->disk, size);
@@ -10648,6 +10656,23 @@ static int imsm_manage_reshape(
 
 	}
 
+	/* clear migr_rec on disks after successful migration */
+	struct dl *d;
+
+	memset(super->migr_rec_buf, 0, MIGR_REC_BUF_SIZE);
+	for (d = super->disks; d; d = d->next) {
+		if (d->index < 0 || is_failed(&d->disk))
+			continue;
+		unsigned long long dsize;
+
+		get_dev_size(d->fd, NULL, &dsize);
+		if (lseek64(d->fd, dsize - 512, SEEK_SET) >= 0) {
+			if (write(d->fd, super->migr_rec_buf,
+				MIGR_REC_BUF_SIZE) != MIGR_REC_BUF_SIZE)
+				perror("Write migr_rec failed");
+		}
+	}
+
 	/* return '1' if done */
 	ret_val = 1;
 abort:

