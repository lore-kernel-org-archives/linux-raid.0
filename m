From: Pawel Baldysiak <pawel.baldysiak@intel.com>
Subject: [PATCH 1/1] IMSM: Add support for Non-Intel NVMe drives under VMD
Date: Mon, 12 Dec 2016 11:28:44 +0100
Message-ID: <20161212102844.26697-1-pawel.baldysiak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@redhat.com
Cc: linux-raid@vger.kernel.org, Pawel Baldysiak <pawel.baldysiak@intel.com>
List-Id: linux-raid.ids

This patch adds checking if platform (preOS) supports
non-Intel NVMe drives under VMD domain,
and - if so - allow creating IMSM Raid Volume
with those drives.

Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
---
 platform-intel.h |  7 +++++++
 super-intel.c    | 12 +++++++++---
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/platform-intel.h b/platform-intel.h
index a8ae85f..4851074 100644
--- a/platform-intel.h
+++ b/platform-intel.h
@@ -99,6 +99,8 @@ struct imsm_orom {
 	#define IMSM_OROM_CAPABILITIES_Rohi (1 << 5)
 	#define IMSM_OROM_CAPABILITIES_ReadPatrol (1 << 6)
 	#define IMSM_OROM_CAPABILITIES_XorHw (1 << 7)
+	#define IMSM_OROM_CAPABILITIES_SKUMode ((1 << 8)|(1 << 9))
+	#define IMSM_OROM_CAPABILITIES_TPV (1 << 10)
 } __attribute__((packed));
 
 static inline int imsm_orom_has_raid0(const struct imsm_orom *orom)
@@ -184,6 +186,11 @@ static inline int imsm_orom_is_nvme(const struct imsm_orom *orom)
 			sizeof(orom->signature)) == 0;
 }
 
+static inline int imsm_orom_has_tpv_support(const struct imsm_orom *orom)
+{
+	return !!(orom->driver_features & IMSM_OROM_CAPABILITIES_TPV);
+}
+
 enum sys_dev_type {
 	SYS_DEV_UNKNOWN = 0,
 	SYS_DEV_SAS,
diff --git a/super-intel.c b/super-intel.c
index 0407d43..cee6951 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -2199,9 +2199,6 @@ static int print_vmd_attached_devs(struct sys_dev *hba)
 			continue;
 
 		sprintf(path, "/sys/bus/pci/drivers/nvme/%s", ent->d_name);
-		/* if not a intel NVMe - skip it*/
-		if (devpath_to_vendor(path) != 0x8086)
-			continue;
 
 		rp = realpath(path, NULL);
 		if (!rp)
@@ -2416,6 +2413,8 @@ static int detail_platform_imsm(int verbose, int enumerate_only, char *controlle
 	for (entry = orom_entries; entry; entry = entry->next) {
 		if (entry->type == SYS_DEV_VMD) {
 			print_imsm_capability(&entry->orom);
+			printf(" 3rd party NVMe :%s supported\n",
+			    imsm_orom_has_tpv_support(&entry->orom)?"":" not");
 			for (hba = list; hba; hba = hba->next) {
 				if (hba->type == SYS_DEV_VMD) {
 					char buf[PATH_MAX];
@@ -5609,6 +5608,13 @@ static int add_to_super_imsm(struct supertype *st, mdu_disk_info_t *dk,
 						"\tRAID 0 is the only supported configuration for this type of x8 device.\n");
 				break;
 			}
+		} else if (super->hba->type == SYS_DEV_VMD && super->orom &&
+		    !imsm_orom_has_tpv_support(super->orom)) {
+			pr_err("\tPlatform configuration does not support non-Intel NVMe drives.\n"
+			       "\tPlease refer to Intel(R) RSTe user guide.\n");
+			free(dd->devname);
+			free(dd);
+			return 1;
 		}
 	}
 
-- 
2.9.3

