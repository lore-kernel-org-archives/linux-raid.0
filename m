From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: [PATCH] Don't assume VMD sysfs path ends with a disk entry
Date: Wed,  4 Jan 2017 11:45:24 +0100
Message-ID: <1483526724-29456-1-git-send-email-tomasz.majchrzak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Jes.Sorensen@redhat.com, tomasz.majchrzak@intel.com, Alexey Obitotskiy <aleksey.obitotskiy@intel.com>
List-Id: linux-raid.ids

From: Alexey Obitotskiy <aleksey.obitotskiy@intel.com>

From: Alexey Obitotskiy <aleksey.obitotskiy@intel.com>
Date: Wed, 4 Jan 2017 11:31:23 +0100

When VMD is enabled but no drive is attached to the PCIe port, mdadm
crashes trying to parse the path. Skip entry if valid path has not been
returned. Do it early to avoid unnecessary memory allocation.

Signed-off-by: Alexey Obitotskiy <aleksey.obitotskiy@intel.com>
Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
---
 platform-intel.c | 33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

diff --git a/platform-intel.c b/platform-intel.c
index c60fd9e..7ad8831 100644
--- a/platform-intel.c
+++ b/platform-intel.c
@@ -48,9 +48,9 @@ static void free_sys_dev(struct sys_dev **list)
 struct sys_dev *find_driver_devices(const char *bus, const char *driver)
 {
 	/* search sysfs for devices driven by 'driver' */
-	char path[292];
-	char link[256];
-	char *c;
+	char path[PATH_MAX];
+	char link[PATH_MAX];
+	char *c, *p;
 	DIR *driver_dir;
 	struct dirent *de;
 	struct sys_dev *head = NULL;
@@ -123,6 +123,22 @@ struct sys_dev *find_driver_devices(const char *bus, const char *driver)
 		if (devpath_to_ll(path, "class", &class) != 0)
 			continue;
 
+		/*
+		 * Each VMD device (domain) adds separate PCI bus, it is better
+		 * to store path as a path to that bus (easier further
+		 * determination which NVMe dev is connected to this particular
+		 * VMD domain).
+		 */
+		if (type == SYS_DEV_VMD) {
+			sprintf(path, "/sys/bus/%s/drivers/%s/%s/domain/device",
+				bus, driver, de->d_name);
+		}
+		p = realpath(path, NULL);
+		if (p == NULL) {
+			pr_err("Unable to get real path for '%s'\n", path);
+			continue;
+		}
+
 		/* start / add list entry */
 		if (!head) {
 			head = xmalloc(sizeof(*head));
@@ -140,16 +156,9 @@ struct sys_dev *find_driver_devices(const char *bus, const char *driver)
 		list->dev_id = (__u16) dev_id;
 		list->class = (__u32) class;
 		list->type = type;
-		/* Each VMD device (domain) adds separate PCI bus, it is better to
-		 * store path as a path to that bus (easier further determination which
-		 * NVMe dev is connected to this particular VMD domain).
-		 */
-		if (type == SYS_DEV_VMD) {
-			sprintf(path, "/sys/bus/%s/drivers/%s/%s/domain/device",
-			bus, driver, de->d_name);
-		}
-		list->path = realpath(path, NULL);
 		list->next = NULL;
+		list->path = p;
+
 		if ((list->pci_id = strrchr(list->path, '/')) != NULL)
 			list->pci_id++;
 	}
-- 
1.8.3.1

