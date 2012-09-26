From: Maciej Naruszewicz <maciej.naruszewicz@intel.com>
Subject: [PATCH 1/6] imsm: Add --export option for --detail-platform
Date: Wed, 26 Sep 2012 13:42:43 +0200
Message-ID: <20120926114243.328.15028.stgit@gklab-128-174.igk.intel.com>
References: <20120926114202.328.71156.stgit@gklab-128-174.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120926114202.328.71156.stgit@gklab-128-174.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, maciej.patelczyk@intel.com
List-Id: linux-raid.ids

This option will provide most of information we can get via
mdadm --detail-platform [-e format] in the key=value format.
Example output:

$ mdadm --detail-platform
       Platform : Intel(R) Matrix Storage Manager
        Version : 9.5.0.1037
    RAID Levels : raid0 raid1 raid10 raid5
    Chunk Sizes : 4k 8k 16k 32k 64k 128k
    2TB volumes : supported
      2TB disks : not supported
      Max Disks : 7
    Max Volumes : 2 per array, 4 per controller
 I/O Controller : /sys/devices/pci0000:00/0000:00:1f.2 (SATA)

$ mdadm --detail-platform --export
MD_FIRMWARE_TYPE=imsm
IMSM_VERSION=9.5.0.1037
IMSM_SUPPORTED_RAID_LEVELS=raid0 raid1 raid10 raid5
IMSM_SUPPORTED_CHUNK_SIZES=4k 8k 16k 32k 64k 128k
IMSM_2TB_VOLUMES=yes
IMSM_2TB_DISKS=no
IMSM_MAX_DISKS=7
IMSM_MAX_VOLUMES_PER_ARRAY=2
IMSM_MAX_VOLUMES_PER_CONTROLLER=4

Signed-off-by: Maciej Naruszewicz <maciej.naruszewicz@intel.com>
---
 Detail.c      |    8 +++++--
 ReadMe.c      |    4 ++-
 mdadm.8.in    |    2 +-
 mdadm.c       |    2 +-
 mdadm.h       |    3 ++
 super-intel.c |   70 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 82 insertions(+), 7 deletions(-)

diff --git a/Detail.c b/Detail.c
index f633d93..b0c31e6 100644
--- a/Detail.c
+++ b/Detail.c
@@ -616,7 +616,7 @@ out:
 	return rv;
 }
 
-int Detail_Platform(struct superswitch *ss, int scan, int verbose)
+int Detail_Platform(struct superswitch *ss, int scan, int verbose, int export)
 {
 	/* display platform capabilities for the given metadata format
 	 * 'scan' in this context means iterate over all metadata types
@@ -624,7 +624,9 @@ int Detail_Platform(struct superswitch *ss, int scan, int verbose)
 	int i;
 	int err = 1;
 
-	if (ss && ss->detail_platform)
+	if (ss && export && ss->export_detail_platform)
+		err = ss->export_detail_platform(verbose);
+	else if (ss && ss->detail_platform)
 		err = ss->detail_platform(verbose, 0);
 	else if (ss) {
 		if (verbose > 0)
@@ -650,6 +652,8 @@ int Detail_Platform(struct superswitch *ss, int scan, int verbose)
 			if (verbose > 0)
 				pr_err("%s metadata is platform independent\n",
 					meta->name ? : "[no name]");
+		} else if (export){
+			err |= meta->export_detail_platform(verbose);
 		} else
 			err |= meta->detail_platform(verbose, 0);
 	}
diff --git a/ReadMe.c b/ReadMe.c
index 35ffeaa..346f08c 100644
--- a/ReadMe.c
+++ b/ReadMe.c
@@ -238,8 +238,8 @@ char OptionHelp[] =
 "  --verbose     -v   : Be more verbose about what is happening\n"
 "  --quiet       -q   : Don't print un-necessary messages\n"
 "  --brief       -b   : Be less verbose, more brief\n"
-"  --export      -Y   : With --detail, use key=value format for easy\n"
-"                       import into environment\n"
+"  --export      -Y   : With --detail, --detail-platform or --examine use\n"
+"                       key=value format for easy import into environment\n"
 "  --force       -f   : Override normal checks and be more forceful\n"
 "\n"
 "  --assemble    -A   : Assemble an array\n"
diff --git a/mdadm.8.in b/mdadm.8.in
index 33919bd..38c8bc8 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -1321,7 +1321,7 @@ topology) for a given metadata format.
 .TP
 .BR \-Y ", " \-\-export
 When used with
-.B \-\-detail
+.B \-\-detail , \-\-detail-platform
 or
 .BR \-\-examine ,
 output will be formatted as
diff --git a/mdadm.c b/mdadm.c
index 4c7c5ea..3ee7ddb 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -1344,7 +1344,7 @@ int main(int argc, char *argv[])
 			}
 			rv = Examine(devlist, &c, ss);
 		} else if (devmode == DetailPlatform) {
-			rv = Detail_Platform(ss ? ss->ss : NULL, ss ? c.scan : 1, c.verbose);
+			rv = Detail_Platform(ss ? ss->ss : NULL, ss ? c.scan : 1, c.verbose, c.export);
 		} else if (devlist == NULL) {
 			if (devmode == 'S' && c.scan)
 				rv = stop_scan(c.verbose);
diff --git a/mdadm.h b/mdadm.h
index f202ffa..6d219f7 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -655,6 +655,7 @@ extern struct superswitch {
 
 	/* Optional: platform hardware / firmware details */
 	int (*detail_platform)(int verbose, int enumerate_only);
+	int (*export_detail_platform)(int verbose);
 
 	/* Used:
 	 *   to get uuid to storing in bitmap metadata
@@ -1121,7 +1122,7 @@ extern int Create(struct supertype *st, char *mddev,
 		  struct context *c);
 
 extern int Detail(char *dev, struct context *c);
-extern int Detail_Platform(struct superswitch *ss, int scan, int verbose);
+extern int Detail_Platform(struct superswitch *ss, int scan, int verbose, int export);
 extern int Query(char *dev);
 extern int Examine(struct mddev_dev *devlist, struct context *c,
 		   struct supertype *forcest);
diff --git a/super-intel.c b/super-intel.c
index 107550f..fdf441a 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1798,6 +1798,41 @@ static void print_imsm_capability(const struct imsm_orom *orom)
 	return;
 }
 
+static void print_imsm_capability_export(const struct imsm_orom *orom)
+{
+	printf("MD_FIRMWARE_TYPE=imsm\n");
+	printf("IMSM_VERSION=%d.%d.%d.%d\n",orom->major_ver, orom->minor_ver,
+			orom->hotfix_ver, orom->build);
+	printf("IMSM_SUPPORTED_RAID_LEVELS=%s%s%s%s%s\n",
+			imsm_orom_has_raid0(orom) ? "raid0 " : "",
+			imsm_orom_has_raid1(orom) ? "raid1 " : "",
+			imsm_orom_has_raid1e(orom) ? "raid1e " : "",
+			imsm_orom_has_raid5(orom) ? "raid10 " : "",
+			imsm_orom_has_raid10(orom) ? "raid5 " : "");
+	printf("IMSM_SUPPORTED_CHUNK_SIZES=%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s\n",
+			imsm_orom_has_chunk(orom, 2) ? "2k " : "",
+			imsm_orom_has_chunk(orom, 4) ? "4k " : "",
+			imsm_orom_has_chunk(orom, 8) ? "8k " : "",
+			imsm_orom_has_chunk(orom, 16) ? "16k " : "",
+			imsm_orom_has_chunk(orom, 32) ? "32k " : "",
+			imsm_orom_has_chunk(orom, 64) ? "64k " : "",
+			imsm_orom_has_chunk(orom, 128) ? "128k " : "",
+			imsm_orom_has_chunk(orom, 256) ? "256k " : "",
+			imsm_orom_has_chunk(orom, 512) ? "512k " : "",
+			imsm_orom_has_chunk(orom, 1024*1) ? "1M " : "",
+			imsm_orom_has_chunk(orom, 1024*2) ? "2M " : "",
+			imsm_orom_has_chunk(orom, 1024*4) ? "4M " : "",
+			imsm_orom_has_chunk(orom, 1024*8) ? "8M " : "",
+			imsm_orom_has_chunk(orom, 1024*16) ? "16M " : "",
+			imsm_orom_has_chunk(orom, 1024*32) ? "32M " : "",
+			imsm_orom_has_chunk(orom, 1024*64) ? "64M " : "");
+	printf("IMSM_2TB_VOLUMES=%s\n",(orom->attr & IMSM_OROM_ATTR_2TB) ? "yes" : "no");
+	printf("IMSM_2TB_DISKS=%s\n",(orom->attr & IMSM_OROM_ATTR_2TB_DISK) ? "yes" : "no");
+	printf("IMSM_MAX_DISKS=%d\n",orom->tds);
+	printf("IMSM_MAX_VOLUMES_PER_ARRAY=%d\n",orom->vpa);
+	printf("IMSM_MAX_VOLUMES_PER_CONTROLLER=%d\n",orom->vphba);
+}
+
 static int detail_platform_imsm(int verbose, int enumerate_only)
 {
 	/* There are two components to imsm platform support, the ahci SATA
@@ -1871,6 +1906,40 @@ static int detail_platform_imsm(int verbose, int enumerate_only)
 	free_sys_dev(&list);
 	return result;
 }
+
+static int export_detail_platform_imsm(int verbose)
+{
+	const struct imsm_orom *orom;
+	struct sys_dev *list, *hba;
+	int result=1;
+
+	list = find_intel_devices();
+	if (!list) {
+		if (verbose > 0)
+			pr_err("IMSM_DETAIL_PLATFORM_ERROR=NO_INTEL_DEVICES\n");
+		result = 2;
+		free_sys_dev(&list);
+		return result;
+	}
+
+	for (hba = list; hba; hba = hba->next) {
+		orom = find_imsm_capability(hba->type);
+		if (!orom) {
+			if (verbose > 0)
+				pr_err("IMSM_DETAIL_PLATFORM_ERROR=NO_IMSM_CAPABLE_DEVICE_UNDER_%s\n",hba->path);
+		}
+		else {
+			print_imsm_capability_export(orom);
+			result = 0;
+		}
+	}
+
+	if (result == 1 && verbose > 0)
+		pr_err("IMSM_DETAIL_PLATFORM_ERROR=NO_IMSM_CAPABLE_DEVICES\n");
+
+	return result;
+}
+
 #endif
 
 static int match_home_imsm(struct supertype *st, char *homehost)
@@ -10397,6 +10466,7 @@ struct superswitch super_imsm = {
 	.add_to_super	= add_to_super_imsm,
 	.remove_from_super = remove_from_super_imsm,
 	.detail_platform = detail_platform_imsm,
+	.export_detail_platform = export_detail_platform_imsm,
 	.kill_subarray = kill_subarray_imsm,
 	.update_subarray = update_subarray_imsm,
 	.load_container	= load_container_imsm,

