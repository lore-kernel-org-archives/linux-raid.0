From: Alexey Obitotskiy <aleksey.obitotskiy@intel.com>
Subject: [PATCH] imsm: count arrays under VMD HBAs correctly
Date: Mon,  9 Jan 2017 13:12:22 +0100
Message-ID: <1483963942-24774-1-git-send-email-aleksey.obitotskiy@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Jes.Sorensen@redhat.com
List-Id: linux-raid.ids

OROM defines maximum number of arrays supported. On array creation mdadm
checks if number of arrays doesn't exceed that limit, however it is not
calculated correctly for VMD now.

The current code performs a lookup of HBA using the id. VMD HBAs have
the same id so each lookup returns the same structure (first
encountered). Take a different approach for VMD HBAs. As id is not
unique and cannot be used for lookups, iterate over all VMD HBAs and
compare both id and HBA path.

Signed-off-by: Alexey Obitotskiy <aleksey.obitotskiy@intel.com>
---
 platform-intel.c | 10 ++++++++++
 platform-intel.h |  1 +
 super-intel.c    | 48 ++++++++++++++++++++++++++++++++++++------------
 3 files changed, 47 insertions(+), 12 deletions(-)

diff --git a/platform-intel.c b/platform-intel.c
index c60fd9e..72a4f19 100644
--- a/platform-intel.c
+++ b/platform-intel.c
@@ -178,6 +178,16 @@ struct sys_dev *device_by_id(__u16 device_id)
 	return NULL;
 }
 
+struct sys_dev *device_by_id_and_path(__u16 device_id, const char *path)
+{
+	struct sys_dev *iter;
+
+	for (iter = intel_devices; iter != NULL; iter = iter->next)
+		if ((iter->dev_id == device_id) && strstr(iter->path, path))
+			return iter;
+	return NULL;
+}
+
 static int devpath_to_ll(const char *dev_path, const char *entry, unsigned long long *val)
 {
 	char path[strlen(dev_path) + strlen(entry) + 2];
diff --git a/platform-intel.h b/platform-intel.h
index a8ae85f..4b4e67f 100644
--- a/platform-intel.h
+++ b/platform-intel.h
@@ -244,4 +244,5 @@ const char *get_sys_dev_type(enum sys_dev_type);
 const struct orom_entry *get_orom_entry_by_device_id(__u16 dev_id);
 const struct imsm_orom *get_orom_by_device_id(__u16 device_id);
 struct sys_dev *device_by_id(__u16 device_id);
+struct sys_dev *device_by_id_and_path(__u16 device_id, const char *path);
 char *vmd_domain_to_controller(struct sys_dev *hba, char *buf);
diff --git a/super-intel.c b/super-intel.c
index 0407d43..93cea8c 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -6475,20 +6475,20 @@ count_volumes_list(struct md_list *devlist, char *homehost,
 	return count;
 }
 
-static int
-count_volumes(struct intel_hba *hba, int dpa, int verbose)
+static int __count_volumes(char *hba_path, int dpa, int verbose,
+			   int cmp_hba_path)
 {
 	struct sys_dev *idev, *intel_devices = find_intel_devices();
 	int count = 0;
 	const struct orom_entry *entry;
 	struct devid_list *dv, *devid_list;
 
-	if (!hba || !hba->path)
+	if (!hba_path)
 		return 0;
 
 	for (idev = intel_devices; idev; idev = idev->next) {
-		if (strstr(idev->path, hba->path))
-				break;
+		if (strstr(idev->path, hba_path))
+			break;
 	}
 
 	if (!idev || !idev->dev_id)
@@ -6502,22 +6502,28 @@ count_volumes(struct intel_hba *hba, int dpa, int verbose)
 	devid_list = entry->devid_list;
 	for (dv = devid_list; dv; dv = dv->next) {
 		struct md_list *devlist;
-		struct sys_dev *device = device_by_id(dv->devid);
-		char *hba_path;
+		struct sys_dev *device = NULL;
+		char *hpath;
 		int found = 0;
 
+		if (cmp_hba_path)
+			device = device_by_id_and_path(dv->devid, hba_path);
+		else
+			device = device_by_id(dv->devid);
+
 		if (device)
-			hba_path = device->path;
+			hpath = device->path;
 		else
 			return 0;
 
-		devlist = get_devices(hba_path);
+		devlist = get_devices(hpath);
 		/* if no intel devices return zero volumes */
 		if (devlist == NULL)
 			return 0;
 
-		count += active_arrays_by_format("imsm", hba_path, &devlist, dpa, verbose);
-		dprintf("path: %s active arrays: %d\n", hba_path, count);
+		count += active_arrays_by_format("imsm", hpath, &devlist, dpa,
+						 verbose);
+		dprintf("path: %s active arrays: %d\n", hpath, count);
 		if (devlist == NULL)
 			return 0;
 		do  {
@@ -6529,7 +6535,7 @@ count_volumes(struct intel_hba *hba, int dpa, int verbose)
 			dprintf("found %d count: %d\n", found, count);
 		} while (found);
 
-		dprintf("path: %s total number of volumes: %d\n", hba_path, count);
+		dprintf("path: %s total number of volumes: %d\n", hpath, count);
 
 		while (devlist) {
 			struct md_list *dv = devlist;
@@ -6541,6 +6547,24 @@ count_volumes(struct intel_hba *hba, int dpa, int verbose)
 	return count;
 }
 
+static int count_volumes(struct intel_hba *hba, int dpa, int verbose)
+{
+	if (!hba)
+		return 0;
+	if (hba->type == SYS_DEV_VMD) {
+		struct sys_dev *dev;
+		int count = 0;
+
+		for (dev = find_intel_devices(); dev; dev = dev->next) {
+			if (dev->type == SYS_DEV_VMD)
+				count += __count_volumes(dev->path, dpa,
+							 verbose, 1);
+		}
+		return count;
+	}
+	return __count_volumes(hba->path, dpa, verbose, 0);
+}
+
 static int imsm_default_chunk(const struct imsm_orom *orom)
 {
 	/* up to 512 if the plaform supports it, otherwise the platform max.
-- 
2.7.4

