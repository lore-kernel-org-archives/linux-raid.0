From: Pawel Baldysiak <pawel.baldysiak@intel.com>
Subject: [PATCH] IMSM: Add warning message when x8-type device is used
Date: Fri, 21 Oct 2016 11:37:48 +0200
Message-ID: <1477042671-12934-1-git-send-email-pawel.baldysiak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@redhat.com
Cc: linux-raid@vger.kernel.org, Pawel Baldysiak <pawel.baldysiak@intel.com>
List-Id: linux-raid.ids

This patch adds the warning message when x8-type device
is used with IMSM metadata. x8 device is a special
NVMe drive - two of them on a single PCIe card.
This card could be a single point of failure for
RAID levels different than RAID0. x8 devices have
serial number ending with "-A/-B" or "-1/-2".

Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
Reviewed-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 super-intel.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/super-intel.c b/super-intel.c
index 5c6ab05..e860e75 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5139,9 +5139,51 @@ static int add_to_super_imsm(struct supertype *st, mdu_disk_info_t *dk,
 	rv = imsm_read_serial(fd, devname, dd->serial);
 	if (rv) {
 		pr_err("failed to retrieve scsi serial, aborting\n");
+		if (dd->devname)
+			free(dd->devname);
 		free(dd);
 		abort();
 	}
+	if (super->hba && ((super->hba->type == SYS_DEV_NVME) ||
+	   (super->hba->type == SYS_DEV_VMD))) {
+		int i;
+		char *devpath = diskfd_to_devpath(fd);
+		char controller_path[PATH_MAX];
+
+		if (!devpath) {
+			pr_err("failed to get devpath, aborting\n");
+			if (dd->devname)
+				free(dd->devname);
+			free(dd);
+			return 1;
+		}
+
+		snprintf(controller_path, PATH_MAX-1, "%s/device", devpath);
+		free(devpath);
+
+		if (devpath_to_vendor(controller_path) == 0x8086) {
+			/*
+			 * If Intel's NVMe drive has serial ended with
+			 * "-A","-B","-1" or "-2" it means that this is "x8"
+			 * device (double drive on single PCIe card).
+			 * User should be warned about potential data loss.
+			 */
+			for (i = MAX_RAID_SERIAL_LEN-1; i > 0; i--) {
+				/* Skip empty character at the end */
+				if (dd->serial[i] == 0)
+					continue;
+
+				if (((dd->serial[i] == 'A') || (dd->serial[i] == 'B') ||
+				   (dd->serial[i] == '1') || (dd->serial[i] == '2')) &&
+				   (dd->serial[i-1] == '-'))
+					pr_err("\tThe action you are about to take may put your data at risk.\n"
+						"\tPlease note that x8 devices may consist of two separate x4 devices "
+						"located on a single PCIe port.\n"
+						"\tRAID 0 is the only supported configuration for this type of x8 device.\n");
+				break;
+			}
+		}
+	}
 
 	get_dev_size(fd, NULL, &size);
 	/* clear migr_rec when adding disk to container */
-- 
2.7.4

