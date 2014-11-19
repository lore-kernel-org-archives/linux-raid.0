From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH 5/5] imsm: use efivarfs interface for reading UEFI variables
Date: Wed, 19 Nov 2014 13:53:30 +0100
Message-ID: <1416401610-16209-6-git-send-email-artur.paszkiewicz@intel.com>
References: <1416401610-16209-1-git-send-email-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1416401610-16209-1-git-send-email-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, pawel.baldysiak@intel.com, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

Read UEFI variables using the new efivarfs interface, fallback to
sysfs-efivars if that fails.

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 platform-intel.c | 37 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

diff --git a/platform-intel.c b/platform-intel.c
index 54ef37f..586a2f6 100644
--- a/platform-intel.c
+++ b/platform-intel.c
@@ -416,6 +416,7 @@ static const struct imsm_orom *find_imsm_hba_orom(struct sys_dev *hba)
   (d0), (d1), (d2), (d3), (d4), (d5), (d6), (d7) }})
 
 #define SYS_EFI_VAR_PATH "/sys/firmware/efi/vars"
+#define SYS_EFIVARS_PATH "/sys/firmware/efi/efivars"
 #define SCU_PROP "RstScuV"
 #define AHCI_PROP "RstSataV"
 #define AHCI_SSATA_PROP "RstsSatV"
@@ -426,10 +427,44 @@ static const struct imsm_orom *find_imsm_hba_orom(struct sys_dev *hba)
 
 #define PCI_CLASS_RAID_CNTRL 0x010400
 
-int read_efi_variable(void *buffer, ssize_t buf_size, char *variable_name, struct efi_guid guid)
+static int read_efi_var(void *buffer, ssize_t buf_size, char *variable_name, struct efi_guid guid)
 {
 	char path[PATH_MAX];
 	char buf[GUID_STR_MAX];
+	int fd;
+	ssize_t n;
+
+	snprintf(path, PATH_MAX, "%s/%s-%s", SYS_EFIVARS_PATH, variable_name, guid_str(buf, guid));
+
+	fd = open(path, O_RDONLY);
+	if (fd < 0)
+		return 1;
+
+	/* read the variable attributes and ignore it */
+	n = read(fd, buf, sizeof(__u32));
+	if (n < 0) {
+		close(fd);
+		return 1;
+	}
+
+	/* read the variable data */
+	n = read(fd, buffer, buf_size);
+	close(fd);
+	if (n < buf_size)
+		return 1;
+
+	return 0;
+}
+
+static int read_efi_variable(void *buffer, ssize_t buf_size, char *variable_name, struct efi_guid guid)
+{
+	/* Try to read the variable using the new efivarfs interface first.
+	 * If that fails, fall back to the old sysfs-efivars interface. */
+	if (!read_efi_var(buffer, buf_size, variable_name, guid))
+		return 0;
+
+	char path[PATH_MAX];
+	char buf[GUID_STR_MAX];
 	int dfd;
 	ssize_t n, var_data_len;
 
-- 
1.8.4.5

