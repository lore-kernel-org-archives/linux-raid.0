From: "Hawrylewicz Czarnowski, Przemyslaw"
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH 2/2] imsm: reading of UEFI variables needs an update
Date: Fri, 25 Mar 2011 15:19:20 +0000
Message-ID: <66C59AD0932712458090B447266D638C012841F2CB@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

Content of EFI variable is stored in "data" file. Moreover size of data
provided by given variable can be initially validated by reading value of
"size" file.
Function read_efi_variable() has been introduced to simplify the code.

Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
---
 platform-intel.c |   62 +++++++++++++++++++++++++++++++++++++++--------------
 1 files changed, 45 insertions(+), 17 deletions(-)

diff --git a/platform-intel.c b/platform-intel.c
index fe6785c..cb6c7dc 100644
--- a/platform-intel.c
+++ b/platform-intel.c
@@ -357,13 +357,52 @@ int populated_efi[SYS_DEV_MAX] = { 0, 0 };
 
 static struct imsm_orom imsm_efi[SYS_DEV_MAX];
 
-const struct imsm_orom *find_imsm_efi(enum sys_dev_type hba_id)
+int read_efi_variable(void *buffer, ssize_t buf_size, char *variable_name, struct efi_guid guid)
 {
-	int dfd=-1;
 	char path[PATH_MAX];
 	char buf[GUID_STR_MAX];
-	int n;
+	int dfd;
+	ssize_t n, var_data_len;
+
+	snprintf(path, PATH_MAX, "%s/%s-%s/size", SYS_EFI_VAR_PATH, variable_name, guid_str(buf, guid));
+
+	dprintf("EFI VAR: path=%s\n", path);
+	/* get size of variable data */
+	dfd = open(path, O_RDONLY);
+	if (dfd < 0)
+		return 1;
+
+	n = read(dfd, &buf, sizeof(buf));
+	close(dfd);
+	if (n < 0)
+		return 1;
+	buf[n] = '\0';
+
+	errno = 0;
+	var_data_len = strtoul(buf, NULL, 16);
+	if ((errno == ERANGE && (var_data_len == LONG_MAX))
+            || (errno != 0 && var_data_len == 0))
+		return 1;
 
+	/* get data */
+	snprintf(path, PATH_MAX, "%s/%s-%s/data", SYS_EFI_VAR_PATH, variable_name, guid_str(buf, guid));
+
+	dprintf("EFI VAR: path=%s\n", path);
+	dfd = open(path, O_RDONLY);
+	if (dfd < 0)
+		return 1;
+
+	n = read(dfd, buffer, buf_size);
+	close(dfd);
+	if (n != var_data_len || n < buf_size) {
+		return 1;
+	}
+
+	return 0;
+}
+
+const struct imsm_orom *find_imsm_efi(enum sys_dev_type hba_id)
+{
 	if (hba_id >= SYS_DEV_MAX)
 		return NULL;
 
@@ -383,25 +422,14 @@ const struct imsm_orom *find_imsm_efi(enum sys_dev_type hba_id)
 		return imsm_platform_test(hba_id, &populated_efi[hba_id], &imsm_efi[hba_id]);
 	}
 	/* OROM test is set, return that there is no EFI capabilities */
-	if (check_env("IMSM_TEST_OROM")) {
+	if (check_env("IMSM_TEST_OROM"))
 		return NULL;
-	}
-	if (hba_id == SYS_DEV_SAS)
-		snprintf(path, PATH_MAX, "%s/%s-%s", SYS_EFI_VAR_PATH, SCU_PROP, guid_str(buf, VENDOR_GUID));
-	else
-		snprintf(path, PATH_MAX, "%s/%s-%s", SYS_EFI_VAR_PATH, AHCI_PROP, guid_str(buf, VENDOR_GUID));
 
-	dprintf("EFI VAR: path=%s\n", path);
-	dfd = open(path, O_RDONLY);
-	if (dfd < 0) {
+	if (read_efi_variable(&imsm_efi[hba_id], sizeof(imsm_efi[0]), hba_id == SYS_DEV_SAS ? SCU_PROP : AHCI_PROP, VENDOR_GUID)) {
 		populated_efi[hba_id] = 0;
 		return NULL;
 	}
-	n = read(dfd, &imsm_efi[hba_id], sizeof(imsm_efi[0]));
-	close(dfd);
-	if (n  <  (int) (sizeof(imsm_efi[0]))) {
-		return NULL;
-	}
+
 	populated_efi[hba_id] = 1;
 	return &imsm_efi[hba_id];
 }
-- 
1.7.3.4

