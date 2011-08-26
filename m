From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 3/9] imsm: fix display spares
Date: Thu, 25 Aug 2011 19:14:14 -0700
Message-ID: <20110826021414.28015.43618.stgit@localhost6.localdomain6>
References: <20110826020908.28015.52384.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110826020908.28015.52384.stgit@localhost6.localdomain6>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, marcin.labun@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

Commit 94827db3 "imsm: add spares to --examine output." may try to
display failed disks whose imsm_disk info is not uptodate (due to not
being able to look itself up by serial).  The same effect can be had by
just loosening the restriction in print_imsm_disk().

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 super-intel.c |   36 +++++++++++-------------------------
 1 files changed, 11 insertions(+), 25 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 2f11698..0347183 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1059,18 +1059,20 @@ static void print_imsm_dev(struct intel_super *super,
 	printf("    Dirty State : %s\n", dev->vol.dirty ? "dirty" : "clean");
 }
 
-static void print_imsm_disk(struct imsm_super *mpb, int index, __u32 reserved)
+static void print_imsm_disk(struct imsm_disk *disk, int index, __u32 reserved)
 {
-	struct imsm_disk *disk = __get_imsm_disk(mpb, index);
 	char str[MAX_RAID_SERIAL_LEN + 1];
 	__u64 sz;
 
-	if (index < 0 || !disk)
+	if (index < -1 || !disk)
 		return;
 
 	printf("\n");
 	snprintf(str, MAX_RAID_SERIAL_LEN + 1, "%s", disk->serial);
-	printf("  Disk%02d Serial : %s\n", index, str);
+	if (index >= 0)
+		printf("  Disk%02d Serial : %s\n", index, str);
+	else
+		printf("    Disk Serial : %s\n", str);
 	printf("          State :%s%s%s\n", is_spare(disk) ? " spare" : "",
 					    is_configured(disk) ? " active" : "",
 					    is_failed(disk) ? " failed" : "");
@@ -1254,7 +1256,7 @@ static void examine_super_imsm(struct supertype *st, char *homehost)
 	printf("    MPB Sectors : %d\n", mpb_sectors(mpb));
 	printf("          Disks : %d\n", mpb->num_disks);
 	printf("   RAID Devices : %d\n", mpb->num_raid_devs);
-	print_imsm_disk(mpb, super->disks->index, reserved);
+	print_imsm_disk(__get_imsm_disk(mpb, super->disks->index), super->disks->index, reserved);
 	if (super->bbm_log) {
 		struct bbm_log *log = super->bbm_log;
 
@@ -1279,28 +1281,12 @@ static void examine_super_imsm(struct supertype *st, char *homehost)
 	for (i = 0; i < mpb->num_disks; i++) {
 		if (i == super->disks->index)
 			continue;
-		print_imsm_disk(mpb, i, reserved);
+		print_imsm_disk(__get_imsm_disk(mpb, i), i, reserved);
 	}
-	for (dl = super->disks ; dl; dl = dl->next) {
-		struct imsm_disk *disk;
-		char str[MAX_RAID_SERIAL_LEN + 1];
-		__u64 sz;
-
-		if (dl->index >= 0)
-			continue;
 
-		disk = &dl->disk;
-		printf("\n");
-		snprintf(str, MAX_RAID_SERIAL_LEN + 1, "%s", disk->serial);
-		printf("    Disk Serial : %s\n", str);
-		printf("          State :%s%s%s\n", is_spare(disk) ? " spare" : "",
-		       is_configured(disk) ? " active" : "",
-		       is_failed(disk) ? " failed" : "");
-		printf("             Id : %08x\n", __le32_to_cpu(disk->scsi_id));
-		sz = __le32_to_cpu(disk->total_blocks) - reserved;
-		printf("    Usable Size : %llu%s\n", (unsigned long long)sz,
-		       human_size(sz * 512));
-	}
+	for (dl = super->disks; dl; dl = dl->next)
+		if (dl->index == -1)
+			print_imsm_disk(&dl->disk, -1, reserved);
 
 	examine_migr_rec_imsm(super);
 }

