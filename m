From: Dan Williams <dan.j.williams@intel.com>
Subject: [RFC mdadm PATCH 06/11] imsm: immutable volume id
Date: Thu, 24 Apr 2014 00:22:51 -0700
Message-ID: <20140424072251.4515.77691.stgit@viggo.jf.intel.com>
References: <20140424071902.4515.19684.stgit@viggo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140424071902.4515.19684.stgit@viggo.jf.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, jes.sorensen@redhat.com, artur.paszkiewicz@intel.com, dave.jiang@intel.com
List-Id: linux-raid.ids

Support the new extensions to have a volume-id that is immutable and
unique for the life of the container.  Prior to this change deleting and
recreating a volume would result in it having the same uuid as the
previous volume in that position.  Now, every time a volume is created a
container generation count is incremented allowing the volume-ids to
include container generation salt.

TODO update kill_subarray_imsm() and update_subarray_imsm() to allow
deletion and renaming (respectively) of arrays with an immutable id.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 super-intel.c |   77 ++++++++++++++++++++++++++++++++++++++++++++++++---------
 1 files changed, 65 insertions(+), 12 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index f0a7ab5ccc7a..07e4c68982cd 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -188,8 +188,9 @@ struct imsm_dev {
 	__u16 cache_policy;
 	__u8  cng_state;
 	__u8  cng_sub_state;
-#define IMSM_DEV_FILLERS 10
-	__u32 filler[IMSM_DEV_FILLERS];
+	__u16 dev_id;
+	__u16 fill;
+	__u32 filler[9];
 	struct imsm_vol vol;
 } __attribute__ ((packed));
 
@@ -209,8 +210,9 @@ struct imsm_super {
 	__u32 orig_family_num;		/* 0x40 - 0x43 original family num */
 	__u32 pwr_cycle_count;		/* 0x44 - 0x47 simulated power cycle count for array */
 	__u32 bbm_log_size;		/* 0x48 - 0x4B - size of bad Block Mgmt Log in bytes */
-#define IMSM_FILLERS 35
-	__u32 filler[IMSM_FILLERS];	/* 0x4C - 0xD7 RAID_MPB_FILLERS */
+	__u16 create_events;		/* counter for generating unique ids */
+	__u16 fill1;
+	__u32 filler[34];
 	struct imsm_disk disk[1];	/* 0xD8 diskTbl[numDisks] */
 	/* here comes imsm_dev[num_raid_devs] */
 	/* here comes BBM logs */
@@ -1984,6 +1986,30 @@ static int match_home_imsm(struct supertype *st, char *homehost)
 	return -1;
 }
 
+static void volume_uuid_from_super(struct intel_super *super, struct sha1_ctx *ctx)
+{
+	struct imsm_dev *dev = NULL;
+
+	if (super->current_vol >= 0)
+		dev = get_imsm_dev(super, super->current_vol);
+
+	if (!dev)
+		return;
+
+	/* if the container is tracking creation events then dev_id is
+	 * valid and we can advertise an immutable uuid, otherwise use the
+	 * old volume-position/name method
+	 */
+	if (super->anchor->create_events) {
+		sha1_process_bytes(&dev->dev_id, sizeof(dev->dev_id), ctx);
+	} else {
+		__u32 vol = super->current_vol;
+
+		sha1_process_bytes(&vol, sizeof(vol), ctx);
+		sha1_process_bytes(dev->volume, MAX_RAID_SERIAL_LEN, ctx);
+	}
+}
+
 static void uuid_from_super_imsm(struct supertype *st, int uuid[4])
 {
 	/* The uuid returned here is used for:
@@ -2012,7 +2038,6 @@ static void uuid_from_super_imsm(struct supertype *st, int uuid[4])
 
 	char buf[20];
 	struct sha1_ctx ctx;
-	struct imsm_dev *dev = NULL;
 	__u32 family_num;
 
 	/* some mdadm versions failed to set ->orig_family_num, in which
@@ -2025,13 +2050,7 @@ static void uuid_from_super_imsm(struct supertype *st, int uuid[4])
 	sha1_init_ctx(&ctx);
 	sha1_process_bytes(super->anchor->sig, MPB_SIG_LEN, &ctx);
 	sha1_process_bytes(&family_num, sizeof(__u32), &ctx);
-	if (super->current_vol >= 0)
-		dev = get_imsm_dev(super, super->current_vol);
-	if (dev) {
-		__u32 vol = super->current_vol;
-		sha1_process_bytes(&vol, sizeof(vol), &ctx);
-		sha1_process_bytes(dev->volume, MAX_RAID_SERIAL_LEN, &ctx);
-	}
+	volume_uuid_from_super(super, &ctx);
 	sha1_finish_ctx(&ctx, buf);
 	memcpy(uuid, buf, 4*4);
 }
@@ -4562,6 +4581,39 @@ static int check_name(struct intel_super *super, char *name, int quiet)
 	return !reason;
 }
 
+static void new_dev_id(struct intel_super *super, struct imsm_dev *new_dev)
+{
+	struct imsm_super *mpb = super->anchor;
+	__u16 create_events, i;
+
+	/* only turn on create_events tracking for newly born
+	 * containers, lest we change the uuid of live volumes (see
+	 * volume_uuid_from_super())
+	 */
+	create_events = __le16_to_cpu(mpb->create_events);
+	if (super->current_vol > 0 && !create_events)
+		return;
+
+	/* catch the case of create_events wrapping to an existing id in
+	 * the mpb
+	 */
+	do {
+		create_events++;
+		/* wrap to 1, because zero means no dev_id support */
+		if (create_events == 0)
+			create_events = 1;
+		for (i = 0; i < mpb->num_raid_devs; i++) {
+			struct imsm_dev *dev = __get_imsm_dev(mpb, i);
+
+			if (dev->dev_id == __cpu_to_le16(create_events))
+				break;
+		}
+	} while (i < mpb->num_raid_devs);
+
+	new_dev->dev_id = __cpu_to_le16(create_events);
+	mpb->create_events = __cpu_to_le16(create_events);
+}
+
 static int init_super_imsm_volume(struct supertype *st, mdu_array_info_t *info,
 				  unsigned long long size, char *name,
 				  char *homehost, int *uuid,
@@ -4655,6 +4707,7 @@ static int init_super_imsm_volume(struct supertype *st, mdu_array_info_t *info,
 		return 0;
 	dv = xmalloc(sizeof(*dv));
 	dev = xcalloc(1, sizeof(*dev) + sizeof(__u32) * (info->raid_disks - 1));
+	new_dev_id(super, dev);
 	strncpy((char *) dev->volume, name, MAX_RAID_SERIAL_LEN);
 	array_blocks = calc_array_size(info->level, info->raid_disks,
 					       info->layout, info->chunk_size,

