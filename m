From: Maksymilian Kunt <maksymilian.kunt@intel.com>
Subject: [PATCH] imsm: show correct size for arrays with 4k disks
Date: Mon,  9 Jan 2017 15:16:04 +0100
Message-ID: <1483971364-7343-1-git-send-email-maksymilian.kunt@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: jes.sorensen@redhat.com, Maksymilian Kunt <maksymilian.kunt@intel.com>
List-Id: linux-raid.ids

Number of blocks used to calculate array size is based on 512 block size
so the size displayed is incorrect for arrays with 4k disks.

Signed-off-by: Maksymilian Kunt <maksymilian.kunt@intel.com>
---
 super-intel.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 0817a1f..87ed8ec 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1480,8 +1480,10 @@ static void print_imsm_dev(struct intel_super *super,
 	printf("    Dirty State : %s\n", dev->vol.dirty ? "dirty" : "clean");
 }
 
-static void print_imsm_disk(struct imsm_disk *disk, int index, __u32 reserved)
-{
+static void print_imsm_disk(struct imsm_disk *disk,
+			    int index,
+			    __u32 reserved,
+			    unsigned int sector_size) {
 	char str[MAX_RAID_SERIAL_LEN + 1];
 	__u64 sz;
 
@@ -1499,7 +1501,8 @@ static void print_imsm_disk(struct imsm_disk *disk, int index, __u32 reserved)
 					    is_failed(disk) ? " failed" : "");
 	printf("             Id : %08x\n", __le32_to_cpu(disk->scsi_id));
 	sz = total_blocks(disk) - reserved;
-	printf("    Usable Size : %llu%s\n", (unsigned long long)sz,
+	printf("    Usable Size : %llu%s\n",
+	       (unsigned long long)sz * 512 / sector_size,
 	       human_size(sz * 512));
 }
 
@@ -1829,7 +1832,8 @@ static void examine_super_imsm(struct supertype *st, char *homehost)
 	printf("    MPB Sectors : %d\n", mpb_sectors(mpb, super->sector_size));
 	printf("          Disks : %d\n", mpb->num_disks);
 	printf("   RAID Devices : %d\n", mpb->num_raid_devs);
-	print_imsm_disk(__get_imsm_disk(mpb, super->disks->index), super->disks->index, reserved);
+	print_imsm_disk(__get_imsm_disk(mpb, super->disks->index),
+			super->disks->index, reserved, super->sector_size);
 	if (get_imsm_bbm_log_size(super->bbm_log)) {
 		struct bbm_log *log = super->bbm_log;
 
@@ -1851,12 +1855,14 @@ static void examine_super_imsm(struct supertype *st, char *homehost)
 	for (i = 0; i < mpb->num_disks; i++) {
 		if (i == super->disks->index)
 			continue;
-		print_imsm_disk(__get_imsm_disk(mpb, i), i, reserved);
+		print_imsm_disk(__get_imsm_disk(mpb, i), i, reserved,
+				super->sector_size);
 	}
 
 	for (dl = super->disks; dl; dl = dl->next)
 		if (dl->index == -1)
-			print_imsm_disk(&dl->disk, -1, reserved);
+			print_imsm_disk(&dl->disk, -1, reserved,
+					super->sector_size);
 
 	examine_migr_rec_imsm(super);
 }
-- 
1.8.3.1

