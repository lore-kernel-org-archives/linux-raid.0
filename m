From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: [PATCH 3/5] imsm: prepare detail_platform_imsm to support different
 types of controllers
Date: Wed, 19 Jan 2011 17:13:50 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D176EFD54E@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "neilb@suse.de" <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

From f16509e68d6007daca14ca4b03dfab0008c6a8dc Mon Sep 17 00:00:00 2001
From: Marcin Labun <marcin.labun@intel.com>
Date: Wed, 19 Jan 2011 12:04:58 +0100
Subject: [PATCH 3/5] imsm: prepare detail_platform_imsm to support different types of controllers

Pull out the AHCI specific parts of detail_platform_imsm to separate functions.
Introduce support new types of controllers.

Based on code From: Artur Wojcik <artur.wojcik@intel.com>
Signed-off-by: Marcin Labun <marcin.labun@intel.com>
---
 super-intel.c |   96 ++++++++++++++++++++++++++++++++++++--------------------
 1 files changed, 62 insertions(+), 34 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index d0bbd54..d77d61c 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1124,10 +1124,10 @@ static void brief_detail_super_imsm(struct supertype *st)
 static int imsm_read_serial(int fd, char *devname, __u8 *serial);
 static void fd2devname(int fd, char *name);
 
-static int imsm_enumerate_ports(const char *hba_path, int port_count, int host_base, int verbose)
+static int ahci_enumerate_ports(const char *hba_path, int port_count, int host_base, int verbose)
 {
-	/* dump an unsorted list of devices attached to ahci, as well as
-	 * non-connected ports
+	/* dump an unsorted list of devices attached to AHCI Intel storage
+	 * controller, as well as non-connected ports
 	 */
 	int hba_len = strlen(hba_path) + 1;
 	struct dirent *ent;
@@ -1287,6 +1287,49 @@ static int imsm_enumerate_ports(const char *hba_path, int port_count, int host_b
 	return err;
 }
 
+
+static void print_found_intel_controllers(struct sys_dev *elem)
+{
+	for (; elem; elem = elem->next) {
+		fprintf(stderr, Name ": found Intel(R) ");
+		if (elem->type == SYS_DEV_SATA)
+			fprintf(stderr, "SATA ");
+		fprintf(stderr, "RAID controller");
+		if (elem->pci_id)
+			fprintf(stderr, " at %s", elem->pci_id);
+		fprintf(stderr, ".\n");
+	}
+	fflush(stderr);
+}
+
+
+static int ahci_get_port_count(const char *hba_path, int *port_count)
+{
+	struct dirent *ent;
+	DIR *dir;
+	int host_base = -1;
+
+	*port_count = 0;
+	if ((dir = opendir(hba_path)) == NULL)
+		return -1;
+
+	for (ent = readdir(dir); ent; ent = readdir(dir)) {
+		int host;
+
+		if (sscanf(ent->d_name, "host%d", &host) != 1)
+			continue;
+		if (*port_count == 0)
+			host_base = host;
+		else if (host < host_base)
+			host_base = host;
+
+		if (host + 1 > *port_count + host_base)
+			*port_count = host + 1 - host_base;
+	}
+	closedir(dir);
+	return host_base;
+}
+
 static int detail_platform_imsm(int verbose, int enumerate_only)
 {
 	/* There are two components to imsm platform support, the ahci SATA
@@ -1302,11 +1345,9 @@ static int detail_platform_imsm(int verbose, int enumerate_only)
 	 */
 	const struct imsm_orom *orom;
 	struct sys_dev *list, *hba;
-	DIR *dir;
-	struct dirent *ent;
-	const char *hba_path;
 	int host_base = 0;
 	int port_count = 0;
+	int result=0;
 
 	if (enumerate_only) {
 		if (check_env("IMSM_NO_PLATFORM") || find_imsm_orom())
@@ -1326,10 +1367,8 @@ static int detail_platform_imsm(int verbose, int enumerate_only)
 		return 2;
 	} else if (verbose)
 		fprintf(stderr, Name ": found Intel SATA AHCI Controller\n");
-	hba_path = hba->path;
-	hba->path = NULL;
-	free_sys_dev(&list);
 
+	print_found_intel_controllers(list);
 	orom = find_imsm_orom();
 	if (!orom) {
 		if (verbose)
@@ -1365,35 +1404,24 @@ static int detail_platform_imsm(int verbose, int enumerate_only)
 	       imsm_orom_has_chunk(orom, 1024*64) ? " 64M" : "");
 	printf("      Max Disks : %d\n", orom->tds);
 	printf("    Max Volumes : %d\n", orom->vpa);
-	printf(" I/O Controller : %s\n", hba_path);
-
-	/* find the smallest scsi host number to determine a port number base */
-	dir = opendir(hba_path);
-	for (ent = dir ? readdir(dir) : NULL; ent; ent = readdir(dir)) {
-		int host;
 
-		if (sscanf(ent->d_name, "host%d", &host) != 1)
-			continue;
-		if (port_count == 0)
-			host_base = host;
-		else if (host < host_base)
-			host_base = host;
 
-		if (host + 1 > port_count + host_base)
-			port_count = host + 1 - host_base;
+	for (hba = list; hba; hba = hba->next) {
+		printf(" I/O Controller : %s (%s)\n",
+			hba->path, get_sys_dev_type(hba->type));
 
+		if (hba->type == SYS_DEV_SATA) {
+			host_base = ahci_get_port_count(hba->path, &port_count);
+			if (ahci_enumerate_ports(hba->path, port_count, host_base, verbose)) {
+				if (verbose)
+					fprintf(stderr, Name ": failed to enumerate "
+						"ports on SATA controller at %s.", hba->pci_id);
+				result |= 2;
+			}
+		}
 	}
-	if (dir)
-		closedir(dir);
-
-	if (!port_count || imsm_enumerate_ports(hba_path, port_count,
-						host_base, verbose) != 0) {
-		if (verbose)
-			fprintf(stderr, Name ": failed to enumerate ports\n");
-		return 2;
-	}
-
-	return 0;
+	free_sys_dev(&list);
+	return result;
 }
 #endif
 
-- 
1.6.4.2

