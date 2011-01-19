From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: [PATCH 5/5] imsm: support for Intel SAS controller in
 get_disk_controller_domain handler
Date: Wed, 19 Jan 2011 17:13:59 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D176EFD550@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "neilb@suse.de" <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

From 90d6284900559fa62abe918c71d3d47c844dab3d Mon Sep 17 00:00:00 2001
From: Marcin Labun <marcin.labun@intel.com>
Date: Wed, 19 Jan 2011 15:57:36 +0100
Subject: [PATCH 5/5] imsm: support for Intel SAS controller in get_disk_controller_domain handler

get_disk_controller_domain recognizes Intel (R) SAS controller (isci).
The function returns three different strings that differentiate disk attached
to AHCI, ISCI or unknown controller types to create separate domains
for each case.

Signed-off-by: Marcin Labun <marcin.labun@intel.com>
---
 super-intel.c |   49 ++++++++++++++++++++++++-------------------------
 1 files changed, 24 insertions(+), 25 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 8f8e062..62307a1 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -6459,34 +6459,33 @@ static char disk_by_path[] = "/dev/disk/by-path/";
 
 static const char *imsm_get_disk_controller_domain(const char *path)
 {
-	struct sys_dev *list, *hba = NULL;
 	char disk_path[PATH_MAX];
-	int ahci = 0;
-	char *dpath = NULL;
-
-	list = find_driver_devices("pci", "ahci");
-	for (hba = list; hba; hba = hba->next)
-		if (devpath_to_vendor(hba->path) == 0x8086)
-			break;
-
-	if (hba) {
-		struct stat st;
+	char *drv=NULL;
+	struct stat st;
 
-		strncpy(disk_path, disk_by_path, PATH_MAX - 1);
-		strncat(disk_path, path, PATH_MAX - strlen(disk_path) - 1);
-		if (stat(disk_path, &st) == 0) {
-			dpath = devt_to_devpath(st.st_rdev);
-			if (dpath)
-				ahci = path_attached_to_hba(dpath, hba->path);
-		}
+	strncpy(disk_path, disk_by_path, PATH_MAX - 1);
+	strncat(disk_path, path, PATH_MAX - strlen(disk_path) - 1);
+	if (stat(disk_path, &st) == 0) {
+		struct sys_dev* hba;
+		char *path=NULL;
+
+		path = devt_to_devpath(st.st_rdev);
+		if (path == NULL)
+			return "unknown";
+		hba = find_disk_attached_hba(-1, path);
+		if (hba && hba->type == SYS_DEV_SAS)
+			drv = "isci";
+		else if (hba && hba->type == SYS_DEV_SATA)
+			drv = "ahci";
+		else 
+			drv = "unknown";
+		dprintf("path: %s hba: %s attached: %s\n",
+			path, (hba) ? hba->path : "NULL", drv);
+		free(path);
+		if (hba)
+			free_sys_dev(&hba);
 	}
-	dprintf("path: %s(%s) hba: %s attached: %d\n",
-		path, dpath, (hba) ? hba->path : "NULL", ahci);
-	free_sys_dev(&list);
-	if (ahci)
-		return "ahci";
-	else
-		return NULL;
+	return drv;
 }
 
 static int imsm_find_array_minor_by_subdev(int subdev, int container, int *minor)
-- 
1.6.4.2

