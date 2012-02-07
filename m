From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 10/12] imsm: FIX: Clear migration record when migration
	switches to next volume.
Date: Tue, 07 Feb 2012 15:04:15 +0100
Message-ID: <20120207140415.20627.72830.stgit@gklab-128-013.igk.intel.com>
References: <20120207135940.20627.33309.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120207135940.20627.33309.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com, lukasz.dorau@intel.com
List-Id: linux-raid.ids

When OLCE is in progress, checkpoint steps are getting bigger due to added space during process.
When mdadm fails after saving "max" to sync_max, mdmon will monitor process
and switch reshape to next array. At this moment we have got information
inconsistency between metadata and migration record.
To avoid this, clear migration record by mdmon /exception from the rule
that migration record is maintained by mdadm/ when reshape switches
to next array.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   19 ++++++++++++++++---
 1 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 5f451f3..958edb5 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -353,6 +353,9 @@ struct intel_super {
 		void *migr_rec_buf; /* buffer for I/O operations */
 		struct migr_record *migr_rec; /* migration record */
 	};
+	int clean_migration_record_by_mdmon; /* when reshape is switched to next
+		array, it indicates that mdmon is allowed to clean migration
+		record */
 	size_t len; /* size of the 'buf' allocation */
 	void *next_buf; /* for realloc'ing buf from the manager */
 	size_t next_len;
@@ -3465,6 +3468,7 @@ static int load_imsm_mpb(int fd, struct intel_super *super, char *devname)
 		free(super->buf);
 		return 2;
 	}
+	super->clean_migration_record_by_mdmon = 0;
 
 	if (!sectors) {
 		check_sum = __gen_imsm_checksum(super->anchor);
@@ -5029,6 +5033,10 @@ static int write_super_imsm(struct supertype *st, int doclose)
 	sum = __gen_imsm_checksum(mpb);
 	mpb->check_sum = __cpu_to_le32(sum);
 
+	if (super->clean_migration_record_by_mdmon) {
+		clear_migration_record = 1;
+		super->clean_migration_record_by_mdmon = 0;
+	}
 	if (clear_migration_record)
 		memset(super->migr_rec_buf, 0, MIGR_REC_BUF_SIZE);
 
@@ -5036,9 +5044,6 @@ static int write_super_imsm(struct supertype *st, int doclose)
 	for (d = super->disks; d ; d = d->next) {
 		if (d->index < 0 || is_failed(&d->disk))
 			continue;
-		if (store_imsm_mpb(d->fd, mpb))
-			fprintf(stderr, "%s: failed for device %d:%d (fd: %d)%s\n",
-				__func__, d->major, d->minor, d->fd, strerror(errno));
 
 		if (clear_migration_record) {
 			unsigned long long dsize;
@@ -5050,6 +5055,13 @@ static int write_super_imsm(struct supertype *st, int doclose)
 					perror("Write migr_rec failed");
 			}
 		}
+
+		if (store_imsm_mpb(d->fd, mpb))
+			fprintf(stderr,
+				"%s: failed for device %d:%d (fd: %d)%s\n",
+				__func__, d->major, d->minor,
+				d->fd, strerror(errno));
+
 		if (doclose) {
 			close(d->fd);
 			d->fd = -1;
@@ -6928,6 +6940,7 @@ static void imsm_progress_container_reshape(struct intel_super *super)
 		map2->num_members = prev_num_members;
 
 		imsm_set_array_size(dev);
+		super->clean_migration_record_by_mdmon = 1;
 		super->updates_pending++;
 	}
 }

