From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: [PATCH] imsm: control number of active imsm volumes in the system
Date: Wed, 9 Nov 2011 11:11:37 +0000
Message-ID: <F9123E44003394499FDD2B17C60621D404EB0C@IRSMSX101.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

From: Marcin Labun <Marcin.Labun@intel.com>
Subject: [PATCH] imsm: control number of active imsm volumes in the system

IMSM supports maximum supported volumes in the system according to OROM defined value.
Block creation and activation of volume if number of active volumes is greater then OROM defined maximum.

Signed-off-by: Marcin Labun <marcin.labun@intel.com>
---
 super-intel.c |   67 ++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 64 insertions(+), 3 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index e4d71e7..eb76e95 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -531,6 +531,7 @@ static int attach_hba_to_super(struct intel_super *super, struct sys_dev *device
 	return 1;
 }
 
+
 static struct sys_dev* find_disk_attached_hba(int fd, const char *devname)
 {
 	struct sys_dev *list, *elem, *prev;
@@ -1665,8 +1666,9 @@ static void print_imsm_capability(const struct imsm_orom *orom)
 	       imsm_orom_has_chunk(orom, 1024*16) ? " 16M" : "",
 	       imsm_orom_has_chunk(orom, 1024*32) ? " 32M" : "",
 	       imsm_orom_has_chunk(orom, 1024*64) ? " 64M" : "");
-	printf("      Max Disks : %d\n", orom->tds);
-	printf("    Max Volumes : %d\n", orom->vpa);
+	printf("    Max Disks                 : %d\n", orom->tds);
+	printf("    Max Volumes per array     : %d\n", orom->vpa);
+	printf("    Max Volumes per controller: %d\n", orom->vphba);
 	return;
 }
 
@@ -5089,11 +5091,61 @@ static int imsm_default_chunk(const struct imsm_orom *orom)
 	return min(512, (1 << fs));
 }
 
+static int count_external_arrays_by_format(char *name, char* hba, int verbose)
+{
+	struct mdstat_ent *mdstat = mdstat_read(0, 0);
+	struct mdstat_ent *memb = NULL;
+	struct mdstat_ent *vol = NULL;
+	int fd = -1;
+	int count = 0;
+	struct dev_member *dev = NULL;
+	char *path = NULL;
+	int num = 0;
+
+	for (memb = mdstat ; memb ; memb = memb->next) {
+		if (memb->metadata_version &&
+		    strncmp(memb->metadata_version, "external:", 9) == 0  &&
+		    (strcmp(&mdstat->metadata_version[9], name) == 0) &&
+		    !is_subarray(memb->metadata_version+9) &&
+		    memb->members) {
+			dev = memb->members;
+			fd = -1;
+			while(dev && (fd < 0)) {
+				path = malloc(strlen(dev->name) + strlen("/dev/") + 1);
+				if (path) {
+					num = sprintf(path, "%s%s", "/dev/", dev->name);
+					if (num > 0)
+						fd = open(path, O_RDONLY, 0);
+					if ((num <= 0) || (fd < 0)) {
+						if (verbose)
+							fprintf(stderr, Name ": Cannot open %s: %s\n",
+								dev->name, strerror(errno));
+					}
+					free(path);
+				}
+				dev = dev->next;
+			}
+			if ((fd >= 0) && disk_attached_to_hba(fd, hba)) {
+				for (vol = mdstat ; vol ; vol = vol->next) {
+					if (vol->metadata_version &&
+					    is_container_member(vol, memb->dev))
+						count++;
+				}
+			}
+			if (fd >= 0)
+				close(fd);
+		}
+	}
+	free_mdstat(mdstat);
+	return count;
+}
+
 #define pr_vrb(fmt, arg...) (void) (verbose && fprintf(stderr, Name fmt, ##arg))
 static int
 validate_geometry_imsm_orom(struct intel_super *super, int level, int layout,
 			    int raiddisks, int *chunk, int verbose)
 {
+	int count = 0;
 	/* check/set platform and metadata limits/defaults */
 	if (super->orom && raiddisks > super->orom->dpa) {
 		pr_vrb(": platform supports a maximum of %d disks per array\n",
@@ -5101,7 +5153,16 @@ validate_geometry_imsm_orom(struct intel_super *super, int level, int layout,
 		return 0;
 	}
 
-        /* capabilities of OROM tested - copied from validate_geometry_imsm_volume */
+	if (super->orom) {
+		count = count_external_arrays_by_format("imsm", super->hba->path, verbose);
+		if (super->orom->vphba <= count) {
+			pr_vrb(":  platform does not support more then %d raid volumes.\n",
+			       super->orom->vphba);
+			return 0;
+		}
+	}
+
+	/* capabilities of OROM tested - copied from validate_geometry_imsm_volume */
 	if (!is_raid_level_supported(super->orom, level, raiddisks)) {
 		pr_vrb(": platform does not support raid%d with %d disk%s\n",
 			level, raiddisks, raiddisks > 1 ? "s" : "");
-- 
1.7.1


