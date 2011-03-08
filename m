From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: [PATCH 05/14] read platform capabilities from EFI
Date: Tue, 8 Mar 2011 15:20:51 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D17A8AEC8E@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: linux-raid.ids

From 647217dd3a30e853936f15bb34cad6a43c75cd51 Mon Sep 17 00:00:00 2001
From: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
Date: Tue, 8 Mar 2011 13:36:26 +0100
Subject: [PATCH 05/14] read platform capabilities from EFI

If operating system is installed using efi, IMSM platform capabilities are
 not available via option ROM, but are stored as efi variables. New
 mechanism has been introduced to obtain capabilities by variables.

Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
Signed-off-by: Marcin Labun <marcin.labun@intel.com>
---
 platform-intel.c |   64 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 64 insertions(+), 0 deletions(-)

diff --git a/platform-intel.c b/platform-intel.c
index 31d76f1..2742305 100644
--- a/platform-intel.c
+++ b/platform-intel.c
@@ -304,6 +304,67 @@ static const struct imsm_orom *find_imsm_hba_orom(enum sys_dev_type hba_id)
   (c) & 0xff, ((c) >> 8) & 0xff, \
   (d0), (d1), (d2), (d3), (d4), (d5), (d6), (d7) }})
 
+
+#define SYS_EFI_VAR_PATH "/sys/firmware/efi/vars"
+#define SCU_PROP "RstScuV"
+#define AHCI_PROP "RstSataV"
+
+#define VENDOR_GUID \
+	EFI_GUID(0x193dfefa, 0xa445, 0x4302, 0x99, 0xd8, 0xef, 0x3a, 0xad, 0x1a, 0x04, 0xc6)
+
+int populated_efi[SYS_DEV_MAX] = { 0, 0 };
+
+static struct imsm_orom imsm_efi[SYS_DEV_MAX];
+
+const struct imsm_orom *find_imsm_efi(enum sys_dev_type hba_id)
+{
+	int dfd=-1;
+	char path[PATH_MAX];
+	char buf[GUID_STR_MAX];
+	int n;
+
+	if (hba_id >= SYS_DEV_MAX)
+		return NULL;
+
+	dprintf("EFI CAP: %p,  pid: %d pop: %d\n",
+		&imsm_efi[hba_id], (int) getpid(), populated_efi[hba_id]);
+
+	/* it's static data so we only need to read it once */
+	if (populated_efi[hba_id]) {
+		dprintf("EFI CAP: %p, pid: %d pop: %d\n",
+			&imsm_efi[hba_id], (int) getpid(), populated_efi[hba_id]);
+		return &imsm_efi[hba_id];
+	}
+	if (check_env("IMSM_TEST_AHCI_EFI") ||
+	    check_env("IMSM_TEST_SCU_EFI")) {
+		dprintf("OROM CAP: %p,  pid: %d pop: %d\n",
+			&imsm_efi[hba_id], (int) getpid(), populated_efi[hba_id]);
+		return imsm_platform_test(hba_id, &populated_efi[hba_id], &imsm_efi[hba_id]);
+	}
+	/* OROM test is set, return that there is no EFI capabilities */
+	if (check_env("IMSM_TEST_OROM")) {
+		return NULL;
+	}
+	if (hba_id == SYS_DEV_SAS)
+		snprintf(path, PATH_MAX, "%s/%s-%s", SYS_EFI_VAR_PATH, SCU_PROP, guid_str(buf, VENDOR_GUID));
+	else
+		snprintf(path, PATH_MAX, "%s/%s-%s", SYS_EFI_VAR_PATH, AHCI_PROP, guid_str(buf, VENDOR_GUID));
+
+	dprintf("EFI VAR: path=%s\n", path);
+
+	if ((dfd = open(path, O_RDONLY)) < 0) {
+		populated_efi[hba_id] = 0;
+		return NULL;
+	}
+	n = read(dfd, &imsm_efi[hba_id], sizeof(imsm_efi[0]));
+	close(dfd);
+	if (n  <  (int) (sizeof(imsm_efi[0]))) {
+		return NULL;
+	}
+	populated_efi[hba_id] = 1;
+	return &imsm_efi[hba_id];
+}
+
 /* 
  * backward interface compatibility 
  */
@@ -316,6 +377,9 @@ const struct imsm_orom *find_imsm_capability(enum sys_dev_type hba_id)
 {
 	const struct imsm_orom *cap=NULL;
 
+
+	if ((cap = find_imsm_efi(hba_id)) != NULL)
+		return cap;
 	if ((cap = find_imsm_hba_orom(hba_id)) != NULL)
 		return cap;
 	return NULL;
-- 
1.6.4.2

