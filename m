Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B19375339B
	for <linux-raid@vger.kernel.org>; Mon, 18 Mar 2024 16:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710779180; cv=none; b=Kl9qt5QzCS3fkfnRPrEACcNOnhfzbp28H09LJsOmo+uznB4qkAgKvGREmUdQHNhKig4nCxJDKhttUo5Y71Yn14USwdS6Y/QApeAF79/7WSki65gmXIk0ddREUkhK37536SyGjjyrhe28F2icDNB3dkqNEs69gQerVYy9khLUiYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710779180; c=relaxed/simple;
	bh=K35V8DfDMUbzSbpUtdXFFU6QjjvDe1jBau+486kXFLo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=a8R1oVizfMWItl/eAsogl7he2nlKoObTCQHcFO80HwhpzJxnx4xY5guzgoYrtr41ehoI8h/69QM3PSSRL1jzXPKsqhylLDNaB9u5ypskIb5rtUB7lifcGo8ldSaEzSf25GVEoTJEpe2hzageuAkaKJeiUEOltc8exiPAleKnoF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gFh5jgT6; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gFh5jgT6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710779177; x=1742315177;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=K35V8DfDMUbzSbpUtdXFFU6QjjvDe1jBau+486kXFLo=;
  b=gFh5jgT6z+SwKEQNYUE6PwELTqq/nMnISd+VSzJPG5TXfDapts3VfCw5
   G+BcP8uQAK6F10yRUMNoNQx3sFPXwORihAvxts7Nve3PB23BNJAdN47Xx
   ecMrq7oDwWriKA8ixc2riOjE3J9f66o5V91bWgP+uoT/VYSQ+dV/tm/NP
   cXTZiOciUy1WySeM4w1HJ/XCmIryN7RXoN9HdV42ZDw8PxDaoSz4sAori
   N6CKKG+PXvnONdimdM0SZwGFyZ5hcX+mZEduZEuPD4A14R4D0W1CE1vVI
   /eX9cOdJhwGNUyfOikyHggE5UL6xhiHvaO+31KKuAPrae+zC/U+47DecB
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11017"; a="5453377"
X-IronPort-AV: E=Sophos;i="6.07,134,1708416000"; 
   d="scan'208";a="5453377"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2024 09:26:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,134,1708416000"; 
   d="scan'208";a="13554012"
Received: from linux-myjy.igk.intel.com ([10.102.108.92])
  by orviesa009.jf.intel.com with ESMTP; 18 Mar 2024 09:26:09 -0700
From: Blazej Kucman <blazej.kucman@intel.com>
To: mariusz.tkaczyk@linux.intel.com,
	jes@trained-monkey.org
Cc: linux-raid@vger.kernel.org
Subject: [PATCH 4/5] imsm: print disk encryption information
Date: Mon, 18 Mar 2024 17:25:34 +0100
Message-Id: <20240318162535.13674-5-blazej.kucman@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20240318162535.13674-1-blazej.kucman@intel.com>
References: <20240318162535.13674-1-blazej.kucman@intel.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Print SATA/NVMe disk encryption information in detail-platform.
Encryption Ability and Status will be printed for each disk.

There is one exception, Opal SATA drives encryption is not checked when
ENCRYPTION_NO_VERIFY key with "sata_opal" value is set in conf,
for this reason such drives are treated as with encryption disabled.

Signed-off-by: Blazej Kucman <blazej.kucman@intel.com>
---
 drive_encryption.c | 36 ++++++++++++++++++++++++++++++++++++
 drive_encryption.h |  2 ++
 mdadm.conf.5.in    |  3 +++
 super-intel.c      | 42 ++++++++++++++++++++++++++++++++++++++----
 4 files changed, 79 insertions(+), 4 deletions(-)

diff --git a/drive_encryption.c b/drive_encryption.c
index 5b9cdc00..8ead9062 100644
--- a/drive_encryption.c
+++ b/drive_encryption.c
@@ -141,6 +141,42 @@ typedef struct ata_trusted_computing {
 	__u16 var2 : 1;
 } __attribute__((__packed__)) ata_trusted_computing_t;
 
+mapping_t encryption_ability_map[] = {
+	{ "None", ENA_NONE },
+	{ "Other", ENA_OTHER },
+	{ "SED", ENA_SED },
+	{ NULL, UnSet }
+};
+
+mapping_t encryption_status_map[] = {
+	{ "Unencrypted", ENS_UNENCRYPTED },
+	{ "Locked", ENS_LOCKED },
+	{ "Unlocked", ENS_UNLOCKED },
+	{ NULL, UnSet }
+};
+
+/**
+ * get_encryption_ability_string() - get encryption ability name string.
+ * @ability: encryption ability enum.
+ *
+ * Return: encryption ability string.
+ */
+const char *get_encryption_ability_string(enum encryption_ability ability)
+{
+	return map_num_s(encryption_ability_map, ability);
+}
+
+/**
+ * get_encryption_status_string() - get encryption status name string.
+ * @ability: encryption status enum.
+ *
+ * Return: encryption status string.
+ */
+const char *get_encryption_status_string(enum encryption_status status)
+{
+	return map_num_s(encryption_status_map, status);
+}
+
 /**
  * get_opal_locking_feature_description() - get opal locking feature description.
  * @response: response from Opal Discovery Level 0.
diff --git a/drive_encryption.h b/drive_encryption.h
index 01405e1e..3abcef70 100644
--- a/drive_encryption.h
+++ b/drive_encryption.h
@@ -33,3 +33,5 @@ get_nvme_opal_encryption_informations(int disk_fd, struct encryption_information
 mdadm_status_t
 get_ata_encryption_information(int disk_fd, struct encryption_information *information,
 			       const int verbose);
+const char *get_encryption_ability_string(enum encryption_ability ability);
+const char *get_encryption_status_string(enum encryption_status status);
diff --git a/mdadm.conf.5.in b/mdadm.conf.5.in
index afb0a296..14302a91 100644
--- a/mdadm.conf.5.in
+++ b/mdadm.conf.5.in
@@ -643,6 +643,9 @@ The
 disables encryption verification for devices with particular encryption support detected.
 Currently, only verification of SATA OPAL encryption can be disabled.
 It does not disable ATA security encryption verification.
+Currently effective only for
+.I IMSM
+metadata.
 Available parameter
 .I "sata_opal".
 
diff --git a/super-intel.c b/super-intel.c
index 806b6248..c5eff352 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -27,6 +27,7 @@
 #include <scsi/sg.h>
 #include <ctype.h>
 #include <dirent.h>
+#include "drive_encryption.h"
 
 /* MPB == Metadata Parameter Block */
 #define MPB_SIGNATURE "Intel Raid ISM Cfg Sig. "
@@ -2349,12 +2350,41 @@ static int imsm_read_serial(int fd, char *devname, __u8 *serial,
 			    size_t serial_buf_len);
 static void fd2devname(int fd, char *name);
 
-static int ahci_enumerate_ports(const char *hba_path, int port_count, int host_base, int verbose)
+void print_encrytpion_information(int disk_fd, enum sys_dev_type hba_type)
+{
+	struct encryption_information information = {0};
+	mdadm_status_t status = MDADM_STATUS_SUCCESS;
+	const char *indent = "                  ";
+
+	switch (hba_type) {
+	case SYS_DEV_VMD:
+	case SYS_DEV_NVME:
+		status = get_nvme_opal_encryption_informations(disk_fd, &information, 1);
+		break;
+	case SYS_DEV_SATA:
+	case SYS_DEV_SATA_VMD:
+		status = get_ata_encryption_information(disk_fd, &information, 1);
+		break;
+	default:
+		return;
+	}
+
+	if (status) {
+		pr_err("Failed to get drive encrytpion information.\n");
+		return;
+	}
+
+	printf("%sEncryption(Ability|Status): %s|%s\n", indent,
+	       get_encryption_ability_string(information.ability),
+	       get_encryption_status_string(information.status));
+}
+
+static int ahci_enumerate_ports(struct sys_dev *hba, int port_count, int host_base, int verbose)
 {
 	/* dump an unsorted list of devices attached to AHCI Intel storage
 	 * controller, as well as non-connected ports
 	 */
-	int hba_len = strlen(hba_path) + 1;
+	int hba_len = strlen(hba->path) + 1;
 	struct dirent *ent;
 	DIR *dir;
 	char *path = NULL;
@@ -2390,7 +2420,7 @@ static int ahci_enumerate_ports(const char *hba_path, int port_count, int host_b
 		path = devt_to_devpath(makedev(major, minor), 1, NULL);
 		if (!path)
 			continue;
-		if (!path_attached_to_hba(path, hba_path)) {
+		if (!path_attached_to_hba(path, hba->path)) {
 			free(path);
 			path = NULL;
 			continue;
@@ -2493,6 +2523,8 @@ static int ahci_enumerate_ports(const char *hba_path, int port_count, int host_b
 				printf(" (%s)\n", buf);
 			else
 				printf(" ()\n");
+
+			print_encrytpion_information(fd, hba->type);
 			close(fd);
 		}
 		free(path);
@@ -2557,6 +2589,8 @@ static int print_nvme_info(struct sys_dev *hba)
 		else
 			printf("()\n");
 
+		print_encrytpion_information(fd, hba->type);
+
 skip:
 		close_fd(&fd);
 	}
@@ -2812,7 +2846,7 @@ static int detail_platform_imsm(int verbose, int enumerate_only, char *controlle
 				hba->path, get_sys_dev_type(hba->type));
 			if (hba->type == SYS_DEV_SATA || hba->type == SYS_DEV_SATA_VMD) {
 				host_base = ahci_get_port_count(hba->path, &port_count);
-				if (ahci_enumerate_ports(hba->path, port_count, host_base, verbose)) {
+				if (ahci_enumerate_ports(hba, port_count, host_base, verbose)) {
 					if (verbose > 0)
 						pr_err("failed to enumerate ports on %s controller at %s.\n",
 							get_sys_dev_type(hba->type), hba->pci_id);
-- 
2.35.3

