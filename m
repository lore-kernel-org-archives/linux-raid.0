From: "Baldysiak, Pawel" <pawel.baldysiak@intel.com>
Subject: RE: [PATCH] Forbid merging with partially assembled IMSM array
Date: Mon, 30 Jun 2014 12:22:22 +0000
Message-ID: <84A53BEA6EAC69439B7E311E9B17A76F19CBF8F4@IRSMSX105.ger.corp.intel.com>
References: <84A53BEA6EAC69439B7E311E9B17A76F07918BDA@IRSMSX105.ger.corp.intel.com>
	<20140602121955.10a72b32@notabene.brown>
	<84A53BEA6EAC69439B7E311E9B17A76F0791C0DD@IRSMSX105.ger.corp.intel.com>
	<20140604123046.02e224d6@notabene.brown>
	<84A53BEA6EAC69439B7E311E9B17A76F0791D2DE@IRSMSX105.ger.corp.intel.com>
	<20140605162730.33e36f25@notabene.brown>
	<84A53BEA6EAC69439B7E311E9B17A76F0792870C@IRSMSX105.ger.corp.intel.com>
 <20140625141551.04c262a4@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140625141551.04c262a4@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Paszkiewicz, Artur" <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

> On Wednesday, June 25, 2014 6:16 AM NeilBrown wrote:
> To: Baldysiak, Pawel
> Cc: linux-raid@vger.kernel.org; Paszkiewicz, Artur
> Subject: Re: [PATCH] Forbid merging with partially assembled IMSM array
> (...)
> Could you please:
> 
>  1/ move the code to super-intel.c and add a new superswitch method called
>   "validate_array" or something like that.
>   You can't pass the 'devices' array in as only Assemble.c knows about that,
>   so filling the ->links in the mdinfo structure and pass the devices in as a
>   list.
> 
>  2/ Don't use a signed variable when you really want an unsigned variable!
>     ('i' in the above code)
>  3/ Don't break strings to fit 80 columns.  I know we have done that in the
>     past, but I think it is more trouble than it is worth.  Do break the
>     string after "\n", but not elsewhere.
> 
> Then I'll apply it.
> 
> Thanks,
> NeilBrown

Hi Neil
Below is the patch with changes.
Thanks
Pawel Baldysiak

From 7c18b28b7df82f35863674f3674b2a7e6a3f4040 Mon Sep 17 00:00:00 2001
From: Pawel Baldysiak <pawel.baldysiak@intel.com>
Date: Mon, 30 Jun 2014 14:15:27 +0200
Subject: [PATCH 1/1] IMSM: Add warning message when assemble spanned container

Due to several changes in code assemble with disks
spanned between different controllers can be obtained
in some cases. After IMSM container will be assembled, check HBA of
disks, and print proper warning if mismatch is detected.

Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 Assemble.c       | 16 ++++++++++++++++
 mdadm.h          |  3 +++
 platform-intel.h |  1 +
 super-intel.c    | 43 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 63 insertions(+)

diff --git a/Assemble.c b/Assemble.c
index 63e09ac..aca28be 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -1001,6 +1001,22 @@ static int start_array(int mdfd,
 					content->array.raid_disks);
 			fprintf(stderr, "\n");
 		}
+
+		if (st->ss->validate_container) {
+			struct mdinfo *devices_list;
+			struct mdinfo *info_devices = xmalloc(sizeof(struct mdinfo)*(okcnt+sparecnt));
+			unsigned int count;
+			devices_list = NULL;
+			for (count = 0; count < okcnt+sparecnt; count++) {
+				info_devices[count] = devices[count].i;
+				info_devices[count].next = devices_list;
+				devices_list = &info_devices[count];
+			}
+			if (st->ss->validate_container(devices_list))
+				pr_err("Mismatch detected!\n");
+			free(info_devices);
+		}
+
 		st->ss->free_super(st);
 		sysfs_uevent(content, "change");
 		if (err_ok && okcnt < (unsigned)content->array.raid_disks)
diff --git a/mdadm.h b/mdadm.h
index 1734cfd..f60866c 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -965,6 +965,9 @@ extern struct superswitch {
 	/* for external backup area */
 	int (*recover_backup)(struct supertype *st, struct mdinfo *info);
 
+	/* validate container after assemble */
+	int (*validate_container)(struct mdinfo *info);
+
 	int swapuuid; /* true if uuid is bigending rather than hostendian */
 	int external;
 	const char *name; /* canonical metadata name */
diff --git a/platform-intel.h b/platform-intel.h
index bcd84b7..8226be3 100644
--- a/platform-intel.h
+++ b/platform-intel.h
@@ -204,6 +204,7 @@ struct sys_dev *find_intel_devices(void);
 const struct imsm_orom *find_imsm_capability(enum sys_dev_type hba_id);
 const struct imsm_orom *find_imsm_orom(void);
 int disk_attached_to_hba(int fd, const char *hba_path);
+int devt_attached_to_hba(dev_t dev, const char *hba_path);
 char *devt_to_devpath(dev_t dev);
 int path_attached_to_hba(const char *disk_path, const char *hba_path);
 const char *get_sys_dev_type(enum sys_dev_type);
diff --git a/super-intel.c b/super-intel.c
index 9dd807a..a4d1e17 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -10484,6 +10484,48 @@ abort:
 
 	return ret_val;
 }
+
+/*******************************************************************************
+ * Function:	validate_container_imsm
+ * Description: This routine validates container after assemble,
+ *		eg. if devices in container are under the same controller.
+ *
+ * Parameters:
+ *	info	: linked list with info about devices used in array
+ * Returns:
+ *	1 : HBA mismatch
+ *	0 : Success
+ ******************************************************************************/
+int validate_container_imsm(struct mdinfo *info)
+{
+	if (!check_env("IMSM_NO_PLATFORM")) {
+		struct sys_dev *idev;
+		struct mdinfo *dev;
+		char *hba_path = NULL;
+		char *dev_path = devt_to_devpath(makedev(info->disk.major,
+										info->disk.minor));
+
+		for (idev = find_intel_devices(); idev; idev = idev->next) {
+			if (strstr(dev_path, idev->path)) {
+				hba_path = idev->path;
+				break;
+			}
+		}
+		free(dev_path);
+
+		if (hba_path) {
+			for (dev = info->next; dev; dev = dev->next) {
+				if (!devt_attached_to_hba(makedev(dev->disk.major,
+						dev->disk.minor), hba_path)) {
+					pr_err("WARNING - IMSM container assembled with disks under different HBAs!\n"
+						"       This operation is not supported and can lead to data loss.\n");
+					return 1;
+				}
+			}
+		}
+	}
+	return 0;
+}
 #endif /* MDASSEMBLE */
 
 struct superswitch super_imsm = {
@@ -10527,6 +10569,7 @@ struct superswitch super_imsm = {
 	.free_super	= free_super_imsm,
 	.match_metadata_desc = match_metadata_desc_imsm,
 	.container_content = container_content_imsm,
+	.validate_container = validate_container_imsm,
 
 	.external	= 1,
 	.name = "imsm",
-- 
1.9.3

