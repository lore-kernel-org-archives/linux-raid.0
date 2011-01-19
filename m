From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: [PATCH 1/5] imsm platform: support for Intel(R) SAS controller.
Date: Wed, 19 Jan 2011 17:13:35 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D176EFD54A@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "neilb@suse.de" <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

From 306a1aa953f2923b46b270ad03d032298c2fdcaf Mon Sep 17 00:00:00 2001
From: Marcin Labun <marcin.labun@intel.com>
Date: Wed, 19 Jan 2011 17:12:28 +0100
Subject: [PATCH 1/5] imsm platform: support for Intel(R) SAS controller.

This patch adds platform support for SAS controller(s) built in Intel(R) Patsburg
chipset.

Signed-off-by: Marcin Labun <marcin.labun@intel.com>
Signed-off-by: Artur Wojcik <artur.wojcik@intel.com>
---
 platform-intel.c |   67 +++++++++++++++++++++++++++++++++++++-----------------
 platform-intel.h |   16 +++++++++++++
 2 files changed, 62 insertions(+), 21 deletions(-)

diff --git a/platform-intel.c b/platform-intel.c
index 6174908..3516a1b 100644
--- a/platform-intel.c
+++ b/platform-intel.c
@@ -51,6 +51,14 @@ struct sys_dev *find_driver_devices(const char *bus, const char *driver)
 	struct dirent *de;
 	struct sys_dev *head = NULL;
 	struct sys_dev *list = NULL;
+	enum sys_dev_type type;
+
+	if (strcmp(driver, "isci") == 0)
+		type = SYS_DEV_SAS;
+	else if (strcmp(driver, "ahci") == 0)
+		type = SYS_DEV_SATA;
+	else
+		type = SYS_DEV_UNKNOWN;
 
 	sprintf(path, "/sys/bus/%s/drivers/%s", bus, driver);
 	driver_dir = opendir(path);
@@ -74,6 +82,13 @@ struct sys_dev *find_driver_devices(const char *bus, const char *driver)
 		if (strncmp(bus, c+1, strlen(bus)) != 0)
 			continue;
 
+		sprintf(path, "/sys/bus/%s/drivers/%s/%s",
+			bus, driver, de->d_name);
+
+		/* if it's not Intel device skip it. */
+		if (devpath_to_vendor(path) != 0x8086)
+			continue;
+
 		/* start / add list entry */
 		if (!head) {
 			head = malloc(sizeof(*head));
@@ -88,11 +103,11 @@ struct sys_dev *find_driver_devices(const char *bus, const char *driver)
 			break;
 		}
 
-		/* generate canonical path name for the device */
-		sprintf(path, "/sys/bus/%s/drivers/%s/%s",
-			bus, driver, de->d_name);
+		list->type = type;
 		list->path = canonicalize_file_name(path);
 		list->next = NULL;
+		if ((list->pci_id = strrchr(list->path, '/')) != NULL)
+			list->pci_id++;
 	}
 	closedir(driver_dir);
 	return head;
@@ -122,23 +137,34 @@ __u16 devpath_to_vendor(const char *dev_path)
 	return id;
 }
 
-static int platform_has_intel_ahci(void)
+struct sys_dev *find_intel_devices(void)
 {
-	struct sys_dev *devices = find_driver_devices("pci", "ahci");
-	struct sys_dev *dev;
-	int ret = 0;
-
-	for (dev = devices; dev; dev = dev->next)
-		if (devpath_to_vendor(dev->path) == 0x8086) {
-			ret = 1;
-			break;
-		}
-
-	free_sys_dev(&devices);
-
-	return ret;
+	struct sys_dev *ahci, *isci;
+
+	isci = find_driver_devices("pci", "isci");
+	ahci = find_driver_devices("pci", "ahci");
+
+	if (!ahci) {
+		ahci = isci;
+	} else {
+		struct sys_dev *elem = ahci;
+		while (elem->next)
+			elem = elem->next;
+		elem->next = isci;
+	}
+	return ahci;
 }
 
+static int platform_has_intel_devices(void)
+{
+	struct sys_dev *devices;
+	devices = find_intel_devices();
+	if (devices) {
+		free_sys_dev(&devices);
+		return 1;
+	}
+	return 0;
+}
 
 static struct imsm_orom imsm_orom;
 static int scan(const void *start, const void *end)
@@ -185,7 +211,7 @@ const struct imsm_orom *find_imsm_orom(void)
 		return &imsm_orom;
 	}
 
-	if (!platform_has_intel_ahci())
+	if (!platform_has_intel_devices())
 		return NULL;
 
 	/* scan option-rom memory looking for an imsm signature */
@@ -212,7 +238,7 @@ char *devt_to_devpath(dev_t dev)
 	return canonicalize_file_name(device);
 }
 
-static char *diskfd_to_devpath(int fd)
+char *diskfd_to_devpath(int fd)
 {
 	/* return the device path for a disk, return NULL on error or fd
 	 * refers to a partition
@@ -233,7 +259,7 @@ int path_attached_to_hba(const char *disk_path, const char *hba_path)
 
 	if (!disk_path || !hba_path)
 		return 0;
-
+	dprintf("hba: %s - disk: %s\n", hba_path, disk_path);
 	if (strncmp(disk_path, hba_path, strlen(hba_path)) == 0)
 		rc = 1;
 	else
@@ -263,4 +289,3 @@ int disk_attached_to_hba(int fd, const char *hba_path)
 
 	return rc;
 }
-
diff --git a/platform-intel.h b/platform-intel.h
index 9088436..82cc85e 100644
--- a/platform-intel.h
+++ b/platform-intel.h
@@ -115,6 +115,7 @@ static inline int imsm_orom_has_chunk(const struct imsm_orom *orom, int chunk)
 	return !!(orom->sss & (1 << (fs - 1)));
 }
 
+
 /**
  * fls - find last (most-significant) bit set
  * @x: the word to search
@@ -164,15 +165,30 @@ static inline int imsm_orom_default_chunk(const struct imsm_orom *orom)
 	return min(512, (1 << fs));
 }
 
+
+enum sys_dev_type {
+	SYS_DEV_UNKNOWN = 0,
+	SYS_DEV_SAS,
+	SYS_DEV_SATA,
+	SYS_DEV_MAX
+};
+
+
 struct sys_dev {
+	enum sys_dev_type type;
 	char *path;
+	char *pci_id;
 	struct sys_dev *next;
 };
 
+char *diskfd_to_devpath(int fd);
 struct sys_dev *find_driver_devices(const char *bus, const char *driver);
+struct sys_dev *find_intel_devices(void);
 __u16 devpath_to_vendor(const char *dev_path);
 void free_sys_dev(struct sys_dev **list);
 const struct imsm_orom *find_imsm_orom(void);
 int disk_attached_to_hba(int fd, const char *hba_path);
 char *devt_to_devpath(dev_t dev);
 int path_attached_to_hba(const char *disk_path, const char *hba_path);
+const char *get_sys_dev_type(enum sys_dev_type);
+
-- 
1.6.4.2

