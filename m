From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: [PATCH 2/5] imsm: support for Intel(R) SAS controller in imsm
 handler
Date: Wed, 19 Jan 2011 17:13:42 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D176EFD54C@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "neilb@suse.de" <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

From 9b3d407ee20526b0e57d2c70bb11d9b7ca0a69fe Mon Sep 17 00:00:00 2001
From: Marcin Labun <marcin.labun@intel.com>
Date: Wed, 19 Jan 2011 11:58:22 +0100
Subject: [PATCH 2/5] imsm: support for Intel(R) SAS controller in imsm handler

add_to_super_imsm handler is able to recognize new type of controller.
It stores the controller information in its structures and blocks
mixing of different controller type in the same container.
In this way it maintains compatibility between Linux and Windows IMSM RAID
stacks. IMSM metadata does not allow arrays to span on devices attached to
different storage controllers.

Based on code From: Artur Wojcik <artur.wojcik@intel.com>
Signed-off-by: Marcin Labun <marcin.labun@intel.com>
---
 super-intel.c |  201 +++++++++++++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 173 insertions(+), 28 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index cb2b51b..d0bbd54 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -233,6 +233,13 @@ struct intel_dev {
 	unsigned index;
 };
 
+struct intel_hba {
+	enum sys_dev_type type;
+	char *path;
+	char *pci_id;
+	struct intel_hba *next;
+};
+
 enum action {
 	DISK_REMOVE = 1,
 	DISK_ADD
@@ -268,7 +275,7 @@ struct intel_super {
 				      active */
 	struct dl *missing; /* disks removed while we weren't looking */
 	struct bbm_log *bbm_log;
-	const char *hba; /* device path of the raid controller for this metadata */
+	struct intel_hba *hba; /* device path of the raid controller for this metadata */
 	const struct imsm_orom *orom; /* platform firmware support */
 	struct intel_super *next; /* (temp) list for disambiguating family_num */
 };
@@ -352,6 +359,115 @@ struct imsm_update_add_remove_disk {
 	enum imsm_update_type type;
 };
 
+
+static const char *_sys_dev_type[] = {
+	[SYS_DEV_UNKNOWN] = "Unknown",
+	[SYS_DEV_SAS] = "SAS",
+	[SYS_DEV_SATA] = "SATA"
+};
+
+const char *get_sys_dev_type(enum sys_dev_type type)
+{
+	if (type >= SYS_DEV_MAX)
+		type = SYS_DEV_UNKNOWN;
+
+	return _sys_dev_type[type];
+}
+
+static struct intel_hba * alloc_intel_hba(struct sys_dev *device)
+{
+	struct intel_hba *result = malloc(sizeof(*result));
+	if (result) {
+		result->type = device->type;
+		result->path = strdup(device->path);
+		result->next = NULL;
+		if (result->path && (result->pci_id = strrchr(result->path, '/')) != NULL)
+			result->pci_id++;
+	}
+	return result;
+}
+
+static struct intel_hba * find_intel_hba(struct intel_hba *hba, struct sys_dev *device)
+{
+	struct intel_hba *result=NULL;
+	for (result = hba; result; result = result->next) {
+		if (result->type == device->type && strcmp(result->path, device->path) == 0)
+			break;
+	}
+	return result;
+}
+
+
+
+static int attach_hba_to_super(struct intel_super *super, struct sys_dev *device,
+			       const char *devname)
+{
+	struct intel_hba *hba;
+
+	/* check if disk attached to Intel HBA */
+	hba = find_intel_hba(super->hba, device);
+	if (hba != NULL)
+		return 1;
+	/* Check if HBA is already attached to super */
+	if (super->hba == NULL) {
+		super->hba = alloc_intel_hba(device);
+		return 1;
+	}
+
+	hba = super->hba;
+	/* Intel metadata allows for all disks attached to the same type HBA.
+	 *  Do not sypport odf HBA types mixing 
+	 */
+	if (device->type != hba->type) {
+	
+		return 2;
+	}
+	while (hba->next)
+		hba = hba->next;
+
+	hba->next = alloc_intel_hba(device);
+	return 1;
+}
+
+static struct sys_dev* find_disk_attached_hba(int fd, const char *devname)
+{
+	struct sys_dev *list, *elem, *prev;
+	char *disk_path;
+
+	if ((list = find_intel_devices()) == NULL)
+		return 0;
+
+	if (fd < 0) 
+		disk_path  = (char *) devname;
+	else
+		disk_path = diskfd_to_devpath(fd);
+
+	if (!disk_path) {
+		free_sys_dev(&list);
+		return 0;
+	}
+
+	for (prev = NULL, elem = list; elem; prev = elem, elem = elem->next) {
+		if (path_attached_to_hba(disk_path, elem->path)) {
+			if (prev == NULL) 
+				list = list->next;
+			else
+				prev->next = elem->next;
+			elem->next = NULL;
+			if (disk_path != devname)
+				free(disk_path);
+			free_sys_dev(&list);
+			return elem;
+		}
+	}
+	if (disk_path != devname)
+		free(disk_path);
+	free_sys_dev(&list);
+
+	return NULL;
+}
+
+
 static struct supertype *match_metadata_desc_imsm(char *arg)
 {
 	struct supertype *st;
@@ -2541,6 +2657,8 @@ static void free_imsm_disks(struct intel_super *super)
 /* free all the pieces hanging off of a super pointer */
 static void __free_imsm(struct intel_super *super, int free_disks)
 {
+	struct intel_hba *elem, *next;
+
 	if (super->buf) {
 		free(super->buf);
 		super->buf = NULL;
@@ -2548,10 +2666,15 @@ static void __free_imsm(struct intel_super *super, int free_disks)
 	if (free_disks)
 		free_imsm_disks(super);
 	free_devlist(super);
-	if (super->hba) {
-		free((void *) super->hba);
-		super->hba = NULL;
-	}
+	elem = super->hba;
+	while (elem) {
+		if (elem->path)
+			free((void *)elem->path);
+		next = elem->next;
+		free(elem);
+		elem = next;
+ 	}
+	super->hba = NULL;
 }
 
 static void free_imsm(struct intel_super *super)
@@ -2581,20 +2704,6 @@ static struct intel_super *alloc_super(void)
 		super->create_offset = ~((__u32 ) 0);
 		if (!check_env("IMSM_NO_PLATFORM"))
 			super->orom = find_imsm_orom();
-		if (super->orom && !check_env("IMSM_TEST_OROM")) {
-			struct sys_dev *list, *ent;
-
-			/* find the first intel ahci controller */
-			list = find_driver_devices("pci", "ahci");
-			for (ent = list; ent; ent = ent->next)
-				if (devpath_to_vendor(ent->path) == 0x8086)
-					break;
-			if (ent) {
-				super->hba = ent->path;
-				ent->path = NULL;
-			}
-			free_sys_dev(&list);
-		}
 	}
 
 	return super;
@@ -3444,8 +3553,9 @@ static int add_to_super_imsm_volume(struct supertype *st, mdu_disk_info_t *dk,
 	return 0;
 }
 
+
 static int add_to_super_imsm(struct supertype *st, mdu_disk_info_t *dk,
-			      int fd, char *devname)
+			     int fd, char *devname)
 {
 	struct intel_super *super = st->sb;
 	struct dl *dd;
@@ -3454,16 +3564,51 @@ static int add_to_super_imsm(struct supertype *st, mdu_disk_info_t *dk,
 	int rv;
 	struct stat stb;
 
-	/* if we are on an RAID enabled platform check that the disk is
-	 * attached to the raid controller
+	/* If we are on an RAID enabled platform check that the disk is
+	 * attached to the raid controller.
+	 * We do not need to test disks attachment for container based additions,
+	 * they shall be already tested when container was created/assembled.
 	 */
-	if (super->hba && !disk_attached_to_hba(fd, super->hba)) {
-		fprintf(stderr,
-			Name ": %s is not attached to the raid controller: %s\n",
-			devname ? : "disk", super->hba);
-		return 1;
-	}
+	if ((fd != -1) && !check_env("IMSM_NO_PLATFORM")) {
+		struct sys_dev *hba_name;
+		struct intel_hba *hba;
+		
 
+		hba_name = find_disk_attached_hba(fd, NULL);
+		if (!hba_name) {
+			fprintf(stderr,
+				Name ": %s is not attached to Intel(R) RAID controller.\n",
+				devname ? : "disk");
+			return 1;
+		}
+		rv = attach_hba_to_super(super, hba_name, devname);
+		switch (rv) {
+		case 2:
+			fprintf(stderr, Name ": %s is attached to Intel(R) %s RAID "
+				"controller (%s),\n    but the container is assigned to Intel(R) "
+				"%s RAID controller (",
+				devname,
+				get_sys_dev_type(hba_name->type),
+				hba_name->pci_id ? : "Err!",
+				get_sys_dev_type(hba_name->type));
+			
+			hba = super->hba;
+			while (hba) {
+				fprintf(stderr, "%s", hba->pci_id ? : "Err!");
+				if (hba->next)
+					fprintf(stderr, ", ");
+				hba = hba->next;
+			}
+
+			fprintf(stderr, ").\n"
+				"    Mixing devices attached to different controllers "
+				"is not allowed.\n");
+			free_sys_dev(&hba_name);
+			return 1;
+		}
+		free_sys_dev(&hba_name);
+	}
+		
 	if (super->current_vol >= 0)
 		return add_to_super_imsm_volume(st, dk, fd, devname);
 
-- 
1.6.4.2

