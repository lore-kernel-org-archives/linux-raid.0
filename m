From: Pawel Baldysiak <pawel.baldysiak@intel.com>
Subject: [PATCH] IMSM: Enable spanning between VMD domains
Date: Fri, 21 Oct 2016 11:37:50 +0200
Message-ID: <1477042671-12934-3-git-send-email-pawel.baldysiak@intel.com>
References: <1477042671-12934-1-git-send-email-pawel.baldysiak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1477042671-12934-1-git-send-email-pawel.baldysiak@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@redhat.com
Cc: linux-raid@vger.kernel.org, Pawel Baldysiak <pawel.baldysiak@intel.com>
List-Id: linux-raid.ids

Each VMD domain adds additional PCI domain. This patch
enables RAID creation with NVMe drives from different
VMD domains.

Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
---
 super-intel.c | 19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index f52e3d4..6fc9cb1 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -567,10 +567,6 @@ static int attach_hba_to_super(struct intel_super *super, struct sys_dev *device
 	if (device->type != hba->type)
 		return 2;
 
-	/* Always forbid spanning between VMD domains (seen as different controllers by mdadm) */
-	if (device->type == SYS_DEV_VMD && !path_attached_to_hba(device->path, hba->path))
-		return 2;
-
 	/* Multiple same type HBAs can be used if they share the same OROM */
 	const struct imsm_orom *device_orom = get_orom_by_device_id(device->dev_id);
 
@@ -2023,10 +2019,10 @@ static int detail_platform_imsm(int verbose, int enumerate_only, char *controlle
 
 	for (entry = orom_entries; entry; entry = entry->next) {
 		if (entry->type == SYS_DEV_VMD) {
+			print_imsm_capability(&entry->orom);
 			for (hba = list; hba; hba = hba->next) {
 				if (hba->type == SYS_DEV_VMD) {
 					char buf[PATH_MAX];
-					print_imsm_capability(&entry->orom);
 					printf(" I/O Controller : %s (%s)\n",
 						vmd_domain_to_controller(hba, buf), get_sys_dev_type(hba->type));
 					if (print_vmd_attached_devs(hba)) {
@@ -2034,9 +2030,9 @@ static int detail_platform_imsm(int verbose, int enumerate_only, char *controlle
 							pr_err("failed to get devices attached to VMD domain.\n");
 						result |= 2;
 					}
-					printf("\n");
 				}
 			}
+			printf("\n");
 			continue;
 		}
 
@@ -5999,14 +5995,6 @@ count_volumes(struct intel_hba *hba, int dpa, int verbose)
 		else
 			return 0;
 
-		/* VMD has one orom entry for all domain, but spanning is not allowed.
-		 * VMD arrays should be counted per domain (controller), so skip
-		 * domains that are not the given one.
-		 */
-		if (hba->type == SYS_DEV_VMD &&
-		   (strncmp(device->path, hba->path, strlen(device->path)) != 0))
-			continue;
-
 		devlist = get_devices(hba_path);
 		/* if no intel devices return zero volumes */
 		if (devlist == NULL)
@@ -9268,8 +9256,7 @@ int validate_container_imsm(struct mdinfo *info)
 			return 1;
 		}
 
-		if (orom != orom2 ||
-		    (hba->type == SYS_DEV_VMD && hba != hba2)) {
+		if (orom != orom2) {
 			pr_err("WARNING - IMSM container assembled with disks under different HBAs!\n"
 				"       This operation is not supported and can lead to data loss.\n");
 			return 1;
-- 
2.7.4

