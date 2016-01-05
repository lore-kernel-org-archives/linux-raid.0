From: Pawel Baldysiak <pawel.baldysiak@intel.com>
Subject: [PATCH] IMSM: Add support for VMD
Date: Tue, 05 Jan 2016 17:03:04 +0100
Message-ID: <20160105160304.17913.4114.stgit@gklab-154-222.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, pawel.baldysiak@intel.com, artur.paszkiewicz@intel.com
List-Id: linux-raid.ids

The Intel Volume Management Device (VMD) is an integrated
endpoint on the platform's PCIe root complex that acts
as a host bridge to a secondary PCIe domain.

This patch adds proper handling of NVMe devices attached to VMD domain.
Each VMD domain is treated as a separate controller (HBA).
Spanning between domains is forbidden.

Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
---
 platform-intel.c |   87 +++++++++++++++++++++++++++++++++++---
 platform-intel.h |    4 ++
 super-intel.c    |  124 ++++++++++++++++++++++++++++++++++++++++++++++++------
 3 files changed, 194 insertions(+), 21 deletions(-)

diff --git a/platform-intel.c b/platform-intel.c
index edb8679..2370602 100644
--- a/platform-intel.c
+++ b/platform-intel.c
@@ -33,8 +33,6 @@
 static int devpath_to_ll(const char *dev_path, const char *entry,
 			 unsigned long long *val);
 
-static __u16 devpath_to_vendor(const char *dev_path);
-
 static void free_sys_dev(struct sys_dev **list)
 {
 	while (*list) {
@@ -57,6 +55,7 @@ struct sys_dev *find_driver_devices(const char *bus, const char *driver)
 	struct dirent *de;
 	struct sys_dev *head = NULL;
 	struct sys_dev *list = NULL;
+	struct sys_dev *vmd = NULL;
 	enum sys_dev_type type;
 	unsigned long long dev_id;
 	unsigned long long class;
@@ -65,17 +64,25 @@ struct sys_dev *find_driver_devices(const char *bus, const char *driver)
 		type = SYS_DEV_SAS;
 	else if (strcmp(driver, "ahci") == 0)
 		type = SYS_DEV_SATA;
-	else if (strcmp(driver, "nvme") == 0)
+	else if (strcmp(driver, "nvme") == 0) {
+		/* if looking for nvme devs, first look for vmd */
+		vmd = find_driver_devices("pci", "vmd");
 		type = SYS_DEV_NVME;
+	} else if (strcmp(driver, "vmd") == 0)
+		type = SYS_DEV_VMD;
 	else
 		type = SYS_DEV_UNKNOWN;
 
 	sprintf(path, "/sys/bus/%s/drivers/%s", bus, driver);
 	driver_dir = opendir(path);
-	if (!driver_dir)
+	if (!driver_dir) {
+		if (vmd)
+			free_sys_dev(&vmd);
 		return NULL;
+	}
 	for (de = readdir(driver_dir); de; de = readdir(driver_dir)) {
 		int n;
+		int skip = 0;
 
 		/* is 'de' a device? check that the 'subsystem' link exists and
 		 * that its target matches 'bus'
@@ -95,8 +102,19 @@ struct sys_dev *find_driver_devices(const char *bus, const char *driver)
 		sprintf(path, "/sys/bus/%s/drivers/%s/%s",
 			bus, driver, de->d_name);
 
-		/* if it's not Intel device skip it. */
-		if (devpath_to_vendor(path) != 0x8086)
+		/* if searching for nvme - skip vmd connected one */
+		if (type == SYS_DEV_NVME) {
+			struct sys_dev *dev;
+			char *rp = realpath(path, NULL);
+			for (dev = vmd; dev; dev = dev->next) {
+				if ((strncmp(dev->path, rp, strlen(dev->path)) == 0))
+					skip = 1;
+			}
+			free(rp);
+		}
+
+		/* if it's not Intel device or mark as VMD connected - skip it. */
+		if (devpath_to_vendor(path) != 0x8086 || skip == 1)
 			continue;
 
 		if (devpath_to_ll(path, "device", &dev_id) != 0)
@@ -122,12 +140,28 @@ struct sys_dev *find_driver_devices(const char *bus, const char *driver)
 		list->dev_id = (__u16) dev_id;
 		list->class = (__u32) class;
 		list->type = type;
+		/* Each VMD device (domain) adds separate PCI bus, it is better to
+		 * store path as a path to that bus (easier further determination which
+		 * NVMe dev is connected to this particular VMD domain).
+		 */
+		if (type == SYS_DEV_VMD) {
+			sprintf(path, "/sys/bus/%s/drivers/%s/%s/domain/device",
+			bus, driver, de->d_name);
+		}
 		list->path = realpath(path, NULL);
 		list->next = NULL;
 		if ((list->pci_id = strrchr(list->path, '/')) != NULL)
 			list->pci_id++;
 	}
 	closedir(driver_dir);
+
+	if (vmd) {
+		if (list)
+			list->next = vmd;
+		else
+			head = vmd;
+	}
+
 	return head;
 }
 
@@ -160,7 +194,7 @@ static int devpath_to_ll(const char *dev_path, const char *entry, unsigned long
 	return n;
 }
 
-static __u16 devpath_to_vendor(const char *dev_path)
+__u16 devpath_to_vendor(const char *dev_path)
 {
 	char path[strlen(dev_path) + strlen("/vendor") + 1];
 	char vendor[7];
@@ -196,6 +230,7 @@ struct sys_dev *find_intel_devices(void)
 
 	isci = find_driver_devices("pci", "isci");
 	ahci = find_driver_devices("pci", "ahci");
+	/* Searching for NVMe will return list of NVMe and VMD controllers */
 	nvme = find_driver_devices("pci", "nvme");
 
 	if (!isci && !ahci) {
@@ -430,6 +465,7 @@ static const struct imsm_orom *find_imsm_hba_orom(struct sys_dev *hba)
 #define AHCI_PROP "RstSataV"
 #define AHCI_SSATA_PROP "RstsSatV"
 #define AHCI_CSATA_PROP "RstCSatV"
+#define VMD_PROP "RstUefiV"
 
 #define VENDOR_GUID \
 	EFI_GUID(0x193dfefa, 0xa445, 0x4302, 0x99, 0xd8, 0xef, 0x3a, 0xad, 0x1a, 0x04, 0xc6)
@@ -545,15 +581,21 @@ const struct imsm_orom *find_imsm_efi(struct sys_dev *hba)
 			if (!csata)
 				csata = add_orom(&orom);
 			add_orom_device_id(csata, hba->dev_id);
+			csata->type = hba->type;
 			return &csata->orom;
 		}
 	}
 
+	if (hba->type == SYS_DEV_VMD) {
+		err = read_efi_variable(&orom, sizeof(orom), VMD_PROP, VENDOR_GUID);
+	}
+
 	if (err)
 		return NULL;
 
 	ret = add_orom(&orom);
 	add_orom_device_id(ret, hba->dev_id);
+	ret->type = hba->type;
 
 	return &ret->orom;
 }
@@ -583,6 +625,7 @@ const struct imsm_orom *find_imsm_nvme(struct sys_dev *hba)
 		nvme_orom = add_orom(&nvme_orom_compat);
 	}
 	add_orom_device_id(nvme_orom, hba->dev_id);
+	nvme_orom->type = SYS_DEV_NVME;
 	return &nvme_orom->orom;
 }
 
@@ -667,3 +710,33 @@ int disk_attached_to_hba(int fd, const char *hba_path)
 
 	return rc;
 }
+
+char *vmd_domain_to_controller(struct sys_dev *hba, char *buf)
+{
+	struct dirent *ent;
+	DIR *dir;
+	char path[PATH_MAX];
+
+	if (!hba)
+		return NULL;
+
+	if (hba->type != SYS_DEV_VMD)
+		return NULL;
+
+	dir = opendir("/sys/bus/pci/drivers/vmd");
+
+	for (ent = dir ? readdir(dir) : NULL; ent; ent = readdir(dir)) {
+		sprintf(path, "/sys/bus/pci/drivers/vmd/%s/domain/device",
+			ent->d_name);
+
+		if (!realpath(path, buf))
+			continue;
+
+		if (strncmp(buf, hba->path, strlen(buf)) == 0) {
+			sprintf(path, "/sys/bus/pci/drivers/vmd/%s", ent->d_name);
+			realpath(path, buf);
+			return buf;
+		}
+	}
+	return NULL;
+}
diff --git a/platform-intel.h b/platform-intel.h
index 695d6c6..a8ae85f 100644
--- a/platform-intel.h
+++ b/platform-intel.h
@@ -189,6 +189,7 @@ enum sys_dev_type {
 	SYS_DEV_SAS,
 	SYS_DEV_SATA,
 	SYS_DEV_NVME,
+	SYS_DEV_VMD,
 	SYS_DEV_MAX
 };
 
@@ -213,6 +214,7 @@ struct devid_list {
 struct orom_entry {
 	struct imsm_orom orom;
 	struct devid_list *devid_list;
+	enum sys_dev_type type;
 	struct orom_entry *next;
 };
 
@@ -229,6 +231,7 @@ static inline char *guid_str(char *buf, struct efi_guid guid)
 }
 
 char *diskfd_to_devpath(int fd);
+__u16 devpath_to_vendor(const char *dev_path);
 struct sys_dev *find_driver_devices(const char *bus, const char *driver);
 struct sys_dev *find_intel_devices(void);
 const struct imsm_orom *find_imsm_capability(struct sys_dev *hba);
@@ -241,3 +244,4 @@ const char *get_sys_dev_type(enum sys_dev_type);
 const struct orom_entry *get_orom_entry_by_device_id(__u16 dev_id);
 const struct imsm_orom *get_orom_by_device_id(__u16 device_id);
 struct sys_dev *device_by_id(__u16 device_id);
+char *vmd_domain_to_controller(struct sys_dev *hba, char *buf);
diff --git a/super-intel.c b/super-intel.c
index e609e0c..62f5633 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -510,7 +510,8 @@ static const char *_sys_dev_type[] = {
 	[SYS_DEV_UNKNOWN] = "Unknown",
 	[SYS_DEV_SAS] = "SAS",
 	[SYS_DEV_SATA] = "SATA",
-	[SYS_DEV_NVME] = "NVMe"
+	[SYS_DEV_NVME] = "NVMe",
+	[SYS_DEV_VMD] = "VMD"
 };
 
 const char *get_sys_dev_type(enum sys_dev_type type)
@@ -565,6 +566,10 @@ static int attach_hba_to_super(struct intel_super *super, struct sys_dev *device
 	if (device->type != hba->type)
 		return 2;
 
+	/* Always forbid spanning between VMD domains (seen as different controllers by mdadm) */
+	if (device->type == SYS_DEV_VMD && !path_attached_to_hba(device->path, hba->path))
+		return 2;
+
 	/* Multiple same type HBAs can be used if they share the same OROM */
 	const struct imsm_orom *device_orom = get_orom_by_device_id(device->dev_id);
 
@@ -1761,6 +1766,57 @@ static int ahci_enumerate_ports(const char *hba_path, int port_count, int host_b
 	return err;
 }
 
+static int print_vmd_attached_devs(struct sys_dev *hba)
+{
+	struct dirent *ent;
+	DIR *dir;
+	char path[292];
+	char link[256];
+	char *c, *rp;
+
+	if (hba->type != SYS_DEV_VMD)
+		return 1;
+
+	/* scroll through /sys/dev/block looking for devices attached to
+	 * this hba
+	 */
+	dir = opendir("/sys/bus/pci/drivers/nvme");
+	for (ent = dir ? readdir(dir) : NULL; ent; ent = readdir(dir)) {
+		int n;
+
+		/* is 'ent' a device? check that the 'subsystem' link exists and
+		 * that its target matches 'bus'
+		 */
+		sprintf(path, "/sys/bus/pci/drivers/nvme/%s/subsystem",
+			ent->d_name);
+		n = readlink(path, link, sizeof(link));
+		if (n < 0 || n >= (int)sizeof(link))
+			continue;
+		link[n] = '\0';
+		c = strrchr(link, '/');
+		if (!c)
+			continue;
+		if (strncmp("pci", c+1, strlen("pci")) != 0)
+			continue;
+
+		sprintf(path, "/sys/bus/pci/drivers/nvme/%s", ent->d_name);
+		/* if not a intel NVMe - skip it*/
+		if (devpath_to_vendor(path) != 0x8086)
+			continue;
+
+		rp = realpath(path, NULL);
+		if (!rp)
+			continue;
+
+		if (path_attached_to_hba(rp, hba->path)) {
+			printf(" NVMe under VMD : %s\n", rp);
+		}
+		free(rp);
+	}
+
+	return 0;
+}
+
 static void print_found_intel_controllers(struct sys_dev *elem)
 {
 	for (; elem; elem = elem->next) {
@@ -1771,7 +1827,12 @@ static void print_found_intel_controllers(struct sys_dev *elem)
 			fprintf(stderr, "SAS ");
 		else if (elem->type == SYS_DEV_NVME)
 			fprintf(stderr, "NVMe ");
-		fprintf(stderr, "RAID controller");
+
+		if (elem->type == SYS_DEV_VMD)
+			fprintf(stderr, "VMD domain");
+		else
+			fprintf(stderr, "RAID controller");
+
 		if (elem->pci_id)
 			fprintf(stderr, " at %s", elem->pci_id);
 		fprintf(stderr, ".\n");
@@ -1935,8 +1996,10 @@ static int detail_platform_imsm(int verbose, int enumerate_only, char *controlle
 		if (controller_path && (compare_paths(hba->path, controller_path) != 0))
 			continue;
 		if (!find_imsm_capability(hba)) {
+			char buf[PATH_MAX];
 			pr_err("imsm capabilities not found for controller: %s (type %s)\n",
-				hba->path, get_sys_dev_type(hba->type));
+				  hba->type == SYS_DEV_VMD ? vmd_domain_to_controller(hba, buf) : hba->path,
+				  get_sys_dev_type(hba->type));
 			continue;
 		}
 		result = 0;
@@ -1951,13 +2014,27 @@ static int detail_platform_imsm(int verbose, int enumerate_only, char *controlle
 	const struct orom_entry *entry;
 
 	for (entry = orom_entries; entry; entry = entry->next) {
-		print_imsm_capability(&entry->orom);
+		if (entry->type == SYS_DEV_VMD) {
+			for (hba = list; hba; hba = hba->next) {
+				if (hba->type == SYS_DEV_VMD) {
+					char buf[PATH_MAX];
+					print_imsm_capability(&entry->orom);
+					printf(" I/O Controller : %s (%s)\n",
+						vmd_domain_to_controller(hba, buf), get_sys_dev_type(hba->type));
+					print_vmd_attached_devs(hba);
+					printf("\n");
+				}
+			}
+			continue;
+		}
 
-		if (imsm_orom_is_nvme(&entry->orom)) {
+		print_imsm_capability(&entry->orom);
+		if (entry->type == SYS_DEV_NVME) {
 			for (hba = list; hba; hba = hba->next) {
 				if (hba->type == SYS_DEV_NVME)
 					printf("    NVMe Device : %s\n", hba->path);
 			}
+			printf("\n");
 			continue;
 		}
 
@@ -2000,16 +2077,25 @@ static int export_detail_platform_imsm(int verbose, char *controller_path)
 	for (hba = list; hba; hba = hba->next) {
 		if (controller_path && (compare_paths(hba->path,controller_path) != 0))
 			continue;
-		if (!find_imsm_capability(hba) && verbose > 0)
-			pr_err("IMSM_DETAIL_PLATFORM_ERROR=NO_IMSM_CAPABLE_DEVICE_UNDER_%s\n", hba->path);
+		if (!find_imsm_capability(hba) && verbose > 0) {
+			char buf[PATH_MAX];
+			pr_err("IMSM_DETAIL_PLATFORM_ERROR=NO_IMSM_CAPABLE_DEVICE_UNDER_%s\n",
+			hba->type == SYS_DEV_VMD ? vmd_domain_to_controller(hba, buf) : hba->path);
+		}
 		else
 			result = 0;
 	}
 
 	const struct orom_entry *entry;
 
-	for (entry = orom_entries; entry; entry = entry->next)
+	for (entry = orom_entries; entry; entry = entry->next) {
+		if (entry->type == SYS_DEV_VMD) {
+			for (hba = list; hba; hba = hba->next)
+				print_imsm_capability_export(&entry->orom);
+			continue;
+		}
 		print_imsm_capability_export(&entry->orom);
+	}
 
 	return result;
 }
@@ -3862,12 +3948,14 @@ static int find_intel_hba_capability(int fd, struct intel_super *super, char *de
 		if (devname) {
 			struct intel_hba *hba = super->hba;
 
-			pr_err("%s is attached to Intel(R) %s RAID controller (%s),\n"
-				"    but the container is assigned to Intel(R) %s RAID controller (",
+			pr_err("%s is attached to Intel(R) %s %s (%s),\n"
+				"    but the container is assigned to Intel(R) %s %s (",
 				devname,
 				get_sys_dev_type(hba_name->type),
+				hba_name->type == SYS_DEV_VMD ? "domain" : "RAID controller",
 				hba_name->pci_id ? : "Err!",
-				get_sys_dev_type(super->hba->type));
+				get_sys_dev_type(super->hba->type),
+				hba->type == SYS_DEV_VMD ? "domain" : "RAID controller");
 
 			while (hba) {
 				fprintf(stderr, "%s", hba->pci_id ? : "Err!");
@@ -3876,7 +3964,8 @@ static int find_intel_hba_capability(int fd, struct intel_super *super, char *de
 				hba = hba->next;
 			}
 			fprintf(stderr, ").\n"
-				"    Mixing devices attached to different controllers is not allowed.\n");
+				"    Mixing devices attached to different %s is not allowed.\n",
+				hba_name->type == SYS_DEV_VMD ? "VMD domains" : "controllers");
 		}
 		return 2;
 	}
@@ -5878,7 +5967,6 @@ count_volumes(struct intel_hba *hba, int dpa, int verbose)
 
 	devid_list = entry->devid_list;
 	for (dv = devid_list; dv; dv = dv->next) {
-
 		struct md_list *devlist = NULL;
 		struct sys_dev *device = device_by_id(dv->devid);
 		char *hba_path;
@@ -5889,6 +5977,14 @@ count_volumes(struct intel_hba *hba, int dpa, int verbose)
 		else
 			return 0;
 
+		/* VMD has one orom entry for all domain, but spanning is not allowed.
+		 * VMD arrays should be counted per domain (controller), so skip
+		 * domains that are not the given one.
+		 */
+		if ((hba->type == SYS_DEV_VMD) &&
+		   (strncmp(device->path, hba->path, strlen(device->path)) != 0))
+			continue;
+
 		devlist = get_devices(hba_path);
 		/* if no intel devices return zero volumes */
 		if (devlist == NULL)
@@ -9150,7 +9246,7 @@ int validate_container_imsm(struct mdinfo *info)
 			return 1;
 		}
 
-		if (orom != orom2) {
+		if ((orom != orom2) || ((hba->type == SYS_DEV_VMD) && (hba != hba2))) {
 			pr_err("WARNING - IMSM container assembled with disks under different HBAs!\n"
 				"       This operation is not supported and can lead to data loss.\n");
 			return 1;

