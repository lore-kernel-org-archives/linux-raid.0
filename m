From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: [PATCH 07/31] imsm: FIX: core dump during imsm metadata writing
Date: Tue, 9 Nov 2010 17:00:55 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D174A1CA96@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

Wrong number of disks during metadata update causes core dump.
New disks number based on internal mdmon information has to used for calculation (not previously read from metadata).

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 mdadm/mdadm/super-intel.c |   27 ++++++++++++++++++---------
 1 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/mdadm/mdadm/super-intel.c b/mdadm/mdadm/super-intel.c index ffb4c33..100a19c 100644
--- a/mdadm/mdadm/super-intel.c
+++ b/mdadm/mdadm/super-intel.c
@@ -3510,8 +3510,9 @@ static int write_super_imsm_spares(struct intel_super *super, int doclose)
 	return 0;
 }
 
-static int write_super_imsm(struct intel_super *super, int doclose)
+static int write_super_imsm(struct supertype *st, int doclose)
 {
+	struct intel_super *super = st->sb;
 	struct imsm_super *mpb = super->anchor;
 	struct dl *d;
 	__u32 generation;
@@ -3519,6 +3520,7 @@ static int write_super_imsm(struct intel_super *super, int doclose)
 	int spares = 0;
 	int i;
 	__u32 mpb_size = sizeof(struct imsm_super) - sizeof(struct imsm_disk);
+	int num_disks = 0;
 
 	/* 'generation' is incremented everytime the metadata is written */
 	generation = __le32_to_cpu(mpb->generation_num);
@@ -3531,21 +3533,28 @@ static int write_super_imsm(struct intel_super *super, int doclose)
 	if (mpb->orig_family_num == 0)
 		mpb->orig_family_num = mpb->family_num;
 
-	mpb_size += sizeof(struct imsm_disk) * mpb->num_disks;
 	for (d = super->disks; d; d = d->next) {
 		if (d->index == -1)
 			spares++;
-		else
+		else {
 			mpb->disk[d->index] = d->disk;
+			num_disks++;
+		}
 	}
-	for (d = super->missing; d; d = d->next)
+	for (d = super->missing; d; d = d->next) {
 		mpb->disk[d->index] = d->disk;
+		num_disks++;
+	}
+	mpb->num_disks = num_disks;
+	mpb_size += sizeof(struct imsm_disk) * mpb->num_disks;
 
 	for (i = 0; i < mpb->num_raid_devs; i++) {
 		struct imsm_dev *dev = __get_imsm_dev(mpb, i);
-
-		imsm_copy_dev(dev, get_imsm_dev(super, i));
-		mpb_size += sizeof_imsm_dev(dev, 0);
+		struct imsm_dev *dev2 = get_imsm_dev(super, i);
+		if ((dev) && (dev2)) {
+			imsm_copy_dev(dev, dev2);
+			mpb_size += sizeof_imsm_dev(dev, 0);
+		}
 	}
 	mpb_size += __le32_to_cpu(mpb->bbm_log_size);
 	mpb->mpb_size = __cpu_to_le32(mpb_size); @@ -3665,7 +3674,7 @@ static int write_init_super_imsm(struct supertype *st)
 		struct dl *d;
 		for (d = super->disks; d; d = d->next)
 			Kill(d->devname, NULL, 0, 1, 1);
-		return write_super_imsm(st->sb, 1);
+		return write_super_imsm(st, 1);
 	}
 }
 #endif
@@ -4938,7 +4947,7 @@ static void imsm_sync_metadata(struct supertype *container)
 	if (!super->updates_pending)
 		return;
 
-	write_super_imsm(super, 0);
+	write_super_imsm(container, 0);
 
 	super->updates_pending = 0;
 }

