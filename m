Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A993FB85
	for <linux-raid@vger.kernel.org>; Fri, 22 Mar 2024 11:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711108317; cv=none; b=qTtf3cseSRFY+w4s4EC4ShW2B3lLqcdWdDD9FG3h7/rNKCBbcfyo/Olp5NvpHkwmBC8/+HkFz8kjuxwC/eT1sV1X7EXZxn6uvVhlSVWokC5tEJBp17bF8buBJv9MrosN2Q5EWU3Gk9B2VVfW6apx/X44j6iB3qspSpd/e3Ua6rY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711108317; c=relaxed/simple;
	bh=wJXAa/SWHj1HzTYht7D+4xkQX1r3o3J8BK1f1mpEexw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pBul50V1sY82/50Lh7a+ZclGRG8RkSoPQ0xAh6f7YkwM2pWO50qU8C9KT7WrbdN/Erm8N7hhS6Fw+HG3IAH0cJRnnsO3X+HrSsKKbQWnGGfcESWiczSwta8Uonxjnh7imMiLwWVD6vgcFoTXAEwbP05HG+M03TK+cn10GGenKew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CO7D7vUp; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CO7D7vUp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711108315; x=1742644315;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wJXAa/SWHj1HzTYht7D+4xkQX1r3o3J8BK1f1mpEexw=;
  b=CO7D7vUpeALxHLj4oNg9jqI/XFSFP7h/MYlwQB14qkJD/8cbIagTr9cn
   Ut9+fd1BxLVc2cXyq8V/rZXkNLaVrkPLCpnD2ZJ/Jh3SGiUiT62L/Hbc5
   AvWsNvt3XUtDimFYaDH80p8B6X8q6Vwt+aA/M+742ka/8taeuIIDHaJNm
   yLDpjRdzR0bJ6qbxIaUOmf21q+l0VbthXa/Fyjfr9tHn9fq7U57PAHYxZ
   A9HuPI7KX4D9OBHwM9MwqfaCvIiG0Emy5kJ/gbp+Fy1istraTLyNFM+fT
   uM6Asp2uWwssP9slCE32v+rFpgIQwS8+6nlNvrC/y4upXTYyRlMt93N1M
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11020"; a="6006805"
X-IronPort-AV: E=Sophos;i="6.07,145,1708416000"; 
   d="scan'208";a="6006805"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2024 04:51:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,145,1708416000"; 
   d="scan'208";a="46001019"
Received: from linux-myjy.igk.intel.com ([10.102.108.92])
  by fmviesa001.fm.intel.com with ESMTP; 22 Mar 2024 04:51:54 -0700
From: Blazej Kucman <blazej.kucman@intel.com>
To: mariusz.tkaczyk@linux.intel.com,
	jes@trained-monkey.org
Cc: linux-raid@vger.kernel.org
Subject: [PATCH v2 5/6] imsm: print disk encryption information
Date: Fri, 22 Mar 2024 12:51:19 +0100
Message-Id: <20240322115120.12325-6-blazej.kucman@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20240322115120.12325-1-blazej.kucman@intel.com>
References: <20240322115120.12325-1-blazej.kucman@intel.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Print SATA/NVMe disk encryption information in --detail-platform.
Encryption Ability and Status will be printed for each disk.

There is one exception, Opal SATA drives encryption is not checked when
ENCRYPTION_NO_VERIFY key with "sata_opal" value is set in conf, for this
reason such drives are treated as without encryption support.

To test this feature, drives SATA/NVMe with Opal support or SATA drives
with encryption support have to be used.

Example outputs of --detail-platform:

Non Opal, encryption enabled, SATA drive:
Port0 : /dev/sdc (CVPR050600G3120LGN)
        Encryption(Ability|Status): Other|Unlocked

NVMe drive without Opal support:
NVMe under VMD : /dev/nvme2n1 (PHLF737302GB1P0GGN)
        Encryption(Ability|Status): None|Unencrypted

Unencrypted SATA drive with OPAL support:

- default allow_tpm, we will get an error from mdadm:
          Port6 : /dev/sdi (CVTS4246015V180IGN)
mdadm: Detected SATA drive /dev/sdi with Trusted Computing support.
mdadm: Cannot verify encryption state. Requires libata.tpm_enabled=1.
mdadm: Failed to get drive encrytpion information.

-  default "allow_tpm" and config entry "ENCRYPTION_NO_VERIFY sata_opal":
Port6 : /dev/sdi (CVTS4246015V180IGN)
        Encryption(Ability|Status): None|Unencrypted

- added "libata.allow_tpm=1" to boot parameters(requires reboot),
the status will be read correctly:
Port6 : /dev/sdi (CVTS4246015V180IGN)
        Encryption(Ability|Status): SED|Unencrypted

Signed-off-by: Blazej Kucman <blazej.kucman@intel.com>
---
 drive_encryption.c | 36 ++++++++++++++++++++++++++++++++++++
 drive_encryption.h |  2 ++
 mdadm.conf.5.in    |  3 +++
 super-intel.c      | 42 ++++++++++++++++++++++++++++++++++++++----
 4 files changed, 79 insertions(+), 4 deletions(-)

diff --git a/drive_encryption.c b/drive_encryption.c
index 6b2bd358..27da9621 100644
--- a/drive_encryption.c
+++ b/drive_encryption.c
@@ -141,6 +141,42 @@ typedef struct ata_trusted_computing {
 	__u16 var2 : 1;
 } __attribute__((__packed__)) ata_trusted_computing_t;
 
+mapping_t encryption_ability_map[] = {
+	{ "None", ENC_ABILITY_NONE },
+	{ "Other", ENC_ABILITY_OTHER },
+	{ "SED", ENC_ABILITY_SED },
+	{ NULL, UnSet }
+};
+
+mapping_t encryption_status_map[] = {
+	{ "Unencrypted", ENC_STATUS_UNENCRYPTED },
+	{ "Locked", ENC_STATUS_LOCKED },
+	{ "Unlocked", ENC_STATUS_UNLOCKED },
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
index 77c7f10f..0cb8ff1b 100644
--- a/drive_encryption.h
+++ b/drive_encryption.h
@@ -33,3 +33,5 @@ get_nvme_opal_encryption_information(int disk_fd, struct encryption_information
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
index 806b6248..885d7a91 100644
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
+void print_encryption_information(int disk_fd, enum sys_dev_type hba_type)
+{
+	struct encryption_information information = {0};
+	mdadm_status_t status = MDADM_STATUS_SUCCESS;
+	const char *indent = "                  ";
+
+	switch (hba_type) {
+	case SYS_DEV_VMD:
+	case SYS_DEV_NVME:
+		status = get_nvme_opal_encryption_information(disk_fd, &information, 1);
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
+		pr_err("Failed to get drive encryption information.\n");
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
+			print_encryption_information(fd, hba->type);
 			close(fd);
 		}
 		free(path);
@@ -2557,6 +2589,8 @@ static int print_nvme_info(struct sys_dev *hba)
 		else
 			printf("()\n");
 
+		print_encryption_information(fd, hba->type);
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

