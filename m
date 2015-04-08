From: Pawel Baldysiak <pawel.baldysiak@intel.com>
Subject: [PATCH] IMSM: Count arrays per orom
Date: Wed, 08 Apr 2015 11:42:18 +0200
Message-ID: <20150408094217.10715.28672.stgit@gklab-154-222.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, pawel.baldysiak@intel.com, artur.paszkiewicz@intel.com
List-Id: linux-raid.ids

Active arrays with IMSM metadata are counted per hba so far.
This is bad due to new functionality of orom shared between multiple
controllers i.e. more arrays can be created than is supported by orom.
This patch changes the way of counting arrays, so the result will be
sum of arrays under every hba supported by specific orom.

Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
---
 platform-intel.c |   14 ++++++++-
 platform-intel.h |    1 +
 super-intel.c    |   85 +++++++++++++++++++++++++++++++++++++-----------------
 3 files changed, 71 insertions(+), 29 deletions(-)

diff --git a/platform-intel.c b/platform-intel.c
index 1e9ddcd..edb8679 100644
--- a/platform-intel.c
+++ b/platform-intel.c
@@ -233,7 +233,7 @@ struct pciExpDataStructFormat {
 
 struct orom_entry *orom_entries;
 
-const struct imsm_orom *get_orom_by_device_id(__u16 dev_id)
+const struct orom_entry *get_orom_entry_by_device_id(__u16 dev_id)
 {
 	struct orom_entry *entry;
 	struct devid_list *devid;
@@ -241,13 +241,23 @@ const struct imsm_orom *get_orom_by_device_id(__u16 dev_id)
 	for (entry = orom_entries; entry; entry = entry->next) {
 		for (devid = entry->devid_list; devid; devid = devid->next) {
 			if (devid->devid == dev_id)
-				return &entry->orom;
+				return entry;
 		}
 	}
 
 	return NULL;
 }
 
+const struct imsm_orom *get_orom_by_device_id(__u16 dev_id)
+{
+	const struct orom_entry *entry = get_orom_entry_by_device_id(dev_id);
+
+	if (entry)
+		return &entry->orom;
+
+	return NULL;
+}
+
 static struct orom_entry *add_orom(const struct imsm_orom *orom)
 {
 	struct orom_entry *list;
diff --git a/platform-intel.h b/platform-intel.h
index 631fa76..695d6c6 100644
--- a/platform-intel.h
+++ b/platform-intel.h
@@ -238,5 +238,6 @@ int devt_attached_to_hba(dev_t dev, const char *hba_path);
 char *devt_to_devpath(dev_t dev);
 int path_attached_to_hba(const char *disk_path, const char *hba_path);
 const char *get_sys_dev_type(enum sys_dev_type);
+const struct orom_entry *get_orom_entry_by_device_id(__u16 dev_id);
 const struct imsm_orom *get_orom_by_device_id(__u16 device_id);
 struct sys_dev *device_by_id(__u16 device_id);
diff --git a/super-intel.c b/super-intel.c
index 77df8db..66cc8e5 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5853,37 +5853,68 @@ count_volumes_list(struct md_list *devlist, char *homehost,
 }
 
 static int
-count_volumes(char *hba, int dpa, int verbose)
+count_volumes(struct intel_hba *hba, int dpa, int verbose)
 {
-	struct md_list *devlist = NULL;
+	struct sys_dev *idev, *intel_devices = find_intel_devices();
 	int count = 0;
-	int found = 0;;
+	const struct orom_entry *entry;
+	struct devid_list *dv, *devid_list;
 
-	devlist = get_devices(hba);
-	/* if no intel devices return zero volumes */
-	if (devlist == NULL)
+	if (!hba || !hba->path)
 		return 0;
 
-	count = active_arrays_by_format("imsm", hba, &devlist, dpa, verbose);
-	dprintf("path: %s active arrays: %d\n", hba, count);
-	if (devlist == NULL)
+	for (idev = intel_devices; idev; idev = idev->next) {
+		if (strstr(idev->path, hba->path))
+				break;
+	}
+
+	if (!idev || !idev->dev_id)
 		return 0;
-	do  {
-		found = 0;
-		count += count_volumes_list(devlist,
-					    NULL,
-					    verbose,
-					    &found);
-		dprintf("found %d count: %d\n", found, count);
-	} while (found);
-
-	dprintf("path: %s total number of volumes: %d\n", hba, count);
-
-	while(devlist) {
-		struct md_list *dv = devlist;
-		devlist = devlist->next;
-		free(dv->devname);
-		free(dv);
+
+	entry = get_orom_entry_by_device_id(idev->dev_id);
+
+	if (!entry || !entry->devid_list)
+		return 0;
+
+	devid_list = entry->devid_list;
+	for (dv = devid_list; dv; dv = dv->next) {
+
+		struct md_list *devlist = NULL;
+		struct sys_dev *device = device_by_id(dv->devid);
+		char *hba_path;
+		int found = 0;
+
+		if (device)
+			hba_path = device->path;
+		else
+			return 0;
+
+		devlist = get_devices(hba_path);
+		/* if no intel devices return zero volumes */
+		if (devlist == NULL)
+			return 0;
+
+		count += active_arrays_by_format("imsm", hba_path, &devlist, dpa, verbose);
+		dprintf("path: %s active arrays: %d\n", hba_path, count);
+		if (devlist == NULL)
+			return 0;
+		do  {
+			found = 0;
+			count += count_volumes_list(devlist,
+							NULL,
+							verbose,
+							&found);
+			dprintf("found %d count: %d\n", found, count);
+		} while (found);
+
+		dprintf("path: %s total number of volumes: %d\n", hba_path, count);
+
+		while (devlist) {
+			struct md_list *dv = devlist;
+			devlist = devlist->next;
+			free(dv->devname);
+			free(dv);
+		}
 	}
 	return count;
 }
@@ -6105,7 +6136,7 @@ static int validate_geometry_imsm_volume(struct supertype *st, int level,
 	*freesize = maxsize;
 
 	if (super->orom) {
-		int count = count_volumes(super->hba->path,
+		int count = count_volumes(super->hba,
 				      super->orom->dpa, verbose);
 		if (super->orom->vphba <= count) {
 			pr_vrb(": platform does not support more than %d raid volumes.\n",
@@ -6261,7 +6292,7 @@ static int validate_geometry_imsm(struct supertype *st, int level, int layout,
 			   created */
 			if (super->orom && freesize) {
 				int count;
-				count = count_volumes(super->hba->path,
+				count = count_volumes(super->hba,
 						      super->orom->dpa, verbose);
 				if (super->orom->vphba <= count) {
 					pr_vrb(": platform does not support more than %d raid volumes.\n",

