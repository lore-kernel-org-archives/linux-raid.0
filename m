From: Dan Williams <dan.j.williams@intel.com>
Subject: [mdadm PATCH 04/12] imsm: fix spare record writeout race
Date: Tue, 13 Oct 2009 19:10:36 -0700
Message-ID: <20091014021036.31570.80797.stgit@dwillia2-linux.ch.intel.com>
References: <20091014020739.31570.36408.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091014020739.31570.36408.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, krzysztof.wojcik@intel.com, ed.ciechanowski@intel.com, maciej.patelczyk@intel.com
List-Id: linux-raid.ids

imsm_activate_spare() in the manager thread may race against
write_super_imsm_spares() in the monitor thread.  Give
write_super_imsm_spares() its own private mpb buffer to prevent
confusing the manager.

This change uncovered cases where spares were not being assembled due to
a failed metadata version number check.  Spares can freely associate
across metadata version number, so reduce the scope of the version check
in the spare assembly case.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 super-intel.c |   59 ++++++++++++++++++++++++++++++++++-----------------------
 1 files changed, 35 insertions(+), 24 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index e53afbb..0e3ed89 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1477,9 +1477,6 @@ static int compare_super_imsm(struct supertype *st, struct supertype *tst)
                 return 0;
         }
 
-	if (memcmp(first->anchor->sig, sec->anchor->sig, MAX_SIGNATURE_LENGTH) != 0)
-		return 3;
-
 	/* if an anchor does not have num_raid_devs set then it is a free
 	 * floating spare
 	 */
@@ -1492,6 +1489,10 @@ static int compare_super_imsm(struct supertype *st, struct supertype *tst)
 		__u32 first_family = first->anchor->orig_family_num;
 		__u32 sec_family = sec->anchor->orig_family_num;
 
+		if (memcmp(first->anchor->sig, sec->anchor->sig,
+			   MAX_SIGNATURE_LENGTH) != 0)
+			return 3;
+
 		if (first_family == 0)
 			first_family = first->anchor->family_num;
 		if (sec_family == 0)
@@ -1499,8 +1500,10 @@ static int compare_super_imsm(struct supertype *st, struct supertype *tst)
 
 		if (first_family != sec_family)
 			return 3;
+
 	}
 
+
 	/* if 'first' is a spare promote it to a populated mpb with sec's
 	 * family number
 	 */
@@ -2976,39 +2979,48 @@ static int add_to_super_imsm(struct supertype *st, mdu_disk_info_t *dk,
 	return 0;
 }
 
-static int store_imsm_mpb(int fd, struct intel_super *super);
+static int store_imsm_mpb(int fd, struct imsm_super *mpb);
+
+static union {
+	char buf[512];
+	struct imsm_super anchor;
+} spare_record __attribute__ ((aligned(512)));
 
 /* spare records have their own family number and do not have any defined raid
  * devices
  */
 static int write_super_imsm_spares(struct intel_super *super, int doclose)
 {
-	struct imsm_super mpb_save;
 	struct imsm_super *mpb = super->anchor;
+	struct imsm_super *spare = &spare_record.anchor;
 	__u32 sum;
 	struct dl *d;
 
-	mpb_save = *mpb;
-	mpb->num_raid_devs = 0;
-	mpb->num_disks = 1;
-	mpb->mpb_size = sizeof(struct imsm_super);
-	mpb->generation_num = __cpu_to_le32(1UL);
+	spare->mpb_size = __cpu_to_le32(sizeof(struct imsm_super)),
+	spare->generation_num = __cpu_to_le32(1UL),
+	spare->attributes = MPB_ATTRIB_CHECKSUM_VERIFY;
+	spare->num_disks = 1,
+	spare->num_raid_devs = 0,
+	spare->cache_size = mpb->cache_size,
+	spare->pwr_cycle_count = __cpu_to_le32(1),
+
+	snprintf((char *) spare->sig, MAX_SIGNATURE_LENGTH,
+		 MPB_SIGNATURE MPB_VERSION_RAID0);
 
 	for (d = super->disks; d; d = d->next) {
 		if (d->index != -1)
 			continue;
 
-		mpb->disk[0] = d->disk;
-		sum = __gen_imsm_checksum(mpb);
-		mpb->family_num = __cpu_to_le32(sum);
-		mpb->orig_family_num = 0;
-		sum = __gen_imsm_checksum(mpb);
-		mpb->check_sum = __cpu_to_le32(sum);
+		spare->disk[0] = d->disk;
+		sum = __gen_imsm_checksum(spare);
+		spare->family_num = __cpu_to_le32(sum);
+		spare->orig_family_num = 0;
+		sum = __gen_imsm_checksum(spare);
+		spare->check_sum = __cpu_to_le32(sum);
 
-		if (store_imsm_mpb(d->fd, super)) {
+		if (store_imsm_mpb(d->fd, spare)) {
 			fprintf(stderr, "%s: failed for device %d:%d %s\n",
 				__func__, d->major, d->minor, strerror(errno));
-			*mpb = mpb_save;
 			return 1;
 		}
 		if (doclose) {
@@ -3017,7 +3029,6 @@ static int write_super_imsm_spares(struct intel_super *super, int doclose)
 		}
 	}
 
-	*mpb = mpb_save;
 	return 0;
 }
 
@@ -3069,7 +3080,7 @@ static int write_super_imsm(struct intel_super *super, int doclose)
 	for (d = super->disks; d ; d = d->next) {
 		if (d->index < 0)
 			continue;
-		if (store_imsm_mpb(d->fd, super))
+		if (store_imsm_mpb(d->fd, mpb))
 			fprintf(stderr, "%s: failed for device %d:%d %s\n",
 				__func__, d->major, d->minor, strerror(errno));
 		if (doclose) {
@@ -4144,9 +4155,9 @@ static void imsm_set_disk(struct active_array *a, int n, int state)
 	}
 }
 
-static int store_imsm_mpb(int fd, struct intel_super *super)
+static int store_imsm_mpb(int fd, struct imsm_super *mpb)
 {
-	struct imsm_super *mpb = super->anchor;
+	void *buf = mpb;
 	__u32 mpb_size = __le32_to_cpu(mpb->mpb_size);
 	unsigned long long dsize;
 	unsigned long long sectors;
@@ -4161,7 +4172,7 @@ static int store_imsm_mpb(int fd, struct intel_super *super)
 		if (lseek64(fd, dsize - (512 * (2 + sectors)), SEEK_SET) < 0)
 			return 1;
 
-		if (write(fd, super->buf + 512, 512 * sectors) != 512 * sectors)
+		if (write(fd, buf + 512, 512 * sectors) != 512 * sectors)
 			return 1;
 	}
 
@@ -4169,7 +4180,7 @@ static int store_imsm_mpb(int fd, struct intel_super *super)
 	if (lseek64(fd, dsize - (512 * 2), SEEK_SET) < 0)
 		return 1;
 
-	if (write(fd, super->buf, 512) != 512)
+	if (write(fd, buf, 512) != 512)
 		return 1;
 
 	return 0;

