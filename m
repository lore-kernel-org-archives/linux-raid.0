From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH 2/2] imsm: improved platform capabilities checking
Date: Fri, 28 Feb 2014 11:29:28 +0100
Message-ID: <1393583368-31542-3-git-send-email-artur.paszkiewicz@intel.com>
References: <1393583368-31542-1-git-send-email-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1393583368-31542-1-git-send-email-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, pawel.baldysiak@intel.com, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

This patch ensures that on Intel platforms only AHCI controllers with
RAID mode enabled are seen as IMSM capable by mdadm.

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Reviewed-by: Lukasz Dorau <lukasz.dorau@intel.com>
---
 platform-intel.c | 16 +++++++++++++---
 platform-intel.h |  3 ++-
 super-intel.c    | 13 ++++++-------
 3 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/platform-intel.c b/platform-intel.c
index 77f8639..3d4d9c7 100644
--- a/platform-intel.c
+++ b/platform-intel.c
@@ -59,6 +59,7 @@ struct sys_dev *find_driver_devices(const char *bus, const char *driver)
 	struct sys_dev *list = NULL;
 	enum sys_dev_type type;
 	unsigned long long dev_id;
+	unsigned long long class;
 
 	if (strcmp(driver, "isci") == 0)
 		type = SYS_DEV_SAS;
@@ -99,6 +100,9 @@ struct sys_dev *find_driver_devices(const char *bus, const char *driver)
 		if (devpath_to_ll(path, "device", &dev_id) != 0)
 			continue;
 
+		if (devpath_to_ll(path, "class", &class) != 0)
+			continue;
+
 		/* start / add list entry */
 		if (!head) {
 			head = xmalloc(sizeof(*head));
@@ -114,6 +118,7 @@ struct sys_dev *find_driver_devices(const char *bus, const char *driver)
 		}
 
 		list->dev_id = (__u16) dev_id;
+		list->class = (__u32) class;
 		list->type = type;
 		list->path = realpath(path, NULL);
 		list->next = NULL;
@@ -348,6 +353,8 @@ static const struct imsm_orom *find_imsm_hba_orom(enum sys_dev_type hba_id)
 #define VENDOR_GUID \
 	EFI_GUID(0x193dfefa, 0xa445, 0x4302, 0x99, 0xd8, 0xef, 0x3a, 0xad, 0x1a, 0x04, 0xc6)
 
+#define PCI_CLASS_RAID_CNTRL 0x010400
+
 int populated_efi[SYS_DEV_MAX] = { 0, 0 };
 
 static struct imsm_orom imsm_efi[SYS_DEV_MAX];
@@ -445,13 +452,16 @@ const struct imsm_orom *find_imsm_orom(void)
 	return find_imsm_hba_orom(SYS_DEV_SATA);
 }
 
-const struct imsm_orom *find_imsm_capability(enum sys_dev_type hba_id)
+const struct imsm_orom *find_imsm_capability(struct sys_dev *hba)
 {
 	const struct imsm_orom *cap=NULL;
 
-	if ((cap = find_imsm_efi(hba_id)) != NULL)
+	if (hba->type == SYS_DEV_SATA && hba->class != PCI_CLASS_RAID_CNTRL)
+		return NULL;
+
+	if ((cap = find_imsm_efi(hba->type)) != NULL)
 		return cap;
-	if ((cap = find_imsm_hba_orom(hba_id)) != NULL)
+	if ((cap = find_imsm_hba_orom(hba->type)) != NULL)
 		return cap;
 	return NULL;
 }
diff --git a/platform-intel.h b/platform-intel.h
index bcd84b7..6887097 100644
--- a/platform-intel.h
+++ b/platform-intel.h
@@ -180,6 +180,7 @@ struct sys_dev {
 	char *path;
 	char *pci_id;
 	__u16  dev_id;
+	__u32  class;
 	struct sys_dev *next;
 };
 
@@ -201,7 +202,7 @@ static inline char *guid_str(char *buf, struct efi_guid guid)
 char *diskfd_to_devpath(int fd);
 struct sys_dev *find_driver_devices(const char *bus, const char *driver);
 struct sys_dev *find_intel_devices(void);
-const struct imsm_orom *find_imsm_capability(enum sys_dev_type hba_id);
+const struct imsm_orom *find_imsm_capability(struct sys_dev *hba);
 const struct imsm_orom *find_imsm_orom(void);
 int disk_attached_to_hba(int fd, const char *hba_path);
 char *devt_to_devpath(dev_t dev);
diff --git a/super-intel.c b/super-intel.c
index f0a7ab5..b21fe67 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1886,13 +1886,12 @@ static int detail_platform_imsm(int verbose, int enumerate_only, char *controlle
 		if (!list)
 			return 2;
 		for (hba = list; hba; hba = hba->next) {
-			orom = find_imsm_capability(hba->type);
-			if (!orom) {
-				result = 2;
+			if (find_imsm_capability(hba)) {
+				result = 0;
 				break;
 			}
 			else
-				result = 0;
+				result = 2;
 		}
 		return result;
 	}
@@ -1909,7 +1908,7 @@ static int detail_platform_imsm(int verbose, int enumerate_only, char *controlle
 	for (hba = list; hba; hba = hba->next) {
 		if (controller_path && (compare_paths(hba->path,controller_path) != 0))
 			continue;
-		orom = find_imsm_capability(hba->type);
+		orom = find_imsm_capability(hba);
 		if (!orom)
 			pr_err("imsm capabilities not found for controller: %s (type %s)\n",
 				hba->path, get_sys_dev_type(hba->type));
@@ -1954,7 +1953,7 @@ static int export_detail_platform_imsm(int verbose, char *controller_path)
 	for (hba = list; hba; hba = hba->next) {
 		if (controller_path && (compare_paths(hba->path,controller_path) != 0))
 			continue;
-		orom = find_imsm_capability(hba->type);
+		orom = find_imsm_capability(hba);
 		if (!orom) {
 			if (verbose > 0)
 				pr_err("IMSM_DETAIL_PLATFORM_ERROR=NO_IMSM_CAPABLE_DEVICE_UNDER_%s\n",hba->path);
@@ -3839,7 +3838,7 @@ static int find_intel_hba_capability(int fd, struct intel_super *super, char *de
 		}
 		return 2;
 	}
-	super->orom = find_imsm_capability(hba_name->type);
+	super->orom = find_imsm_capability(hba_name);
 	if (!super->orom)
 		return 3;
 	return 0;
-- 
1.8.4.5

