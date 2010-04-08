From: "Hawrylewicz Czarnowski, Przemyslaw"
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH] imsm: assign UUID  of spare device based on ARRAY *device*
 keyword in mdadm configuration file.
Date: Thu, 8 Apr 2010 15:48:18 +0100
Message-ID: <66C59AD0932712458090B447266D638CD3DBE917@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

If config has list of devices associated with container and it comprises given spare drive, UUID is set apporopriately to this container.
It allows to assign spare with proper container according
to content in devices parameter in configuration file.

Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
---
 super-intel.c |   48 +++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 43 insertions(+), 5 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index a196ca3..41a4cc6 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1497,10 +1497,19 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info)
 	uuid_from_super_imsm(st, info->uuid);
 }
 
+static int matchfd2devnum(int fd, int maj, int min)
+{
+	struct stat st;
+	if (fstat(fd, &st) != 0)
+		return 1;
+	return ((int)major(st.st_rdev) == maj && (int)minor(st.st_rdev) == min);
+}
+
+
 /* check the config file to see if we can return a real uuid for this spare */
-static void fixup_container_spare_uuid(struct mdinfo *inf)
+static void fixup_container_spare_uuid(struct mdinfo *inf, struct dl *disk)
 {
-	struct mddev_ident_s *array_list;
+	struct mddev_ident_s *array_list, *first_match = NULL;
 
 	if (inf->array.level != LEVEL_CONTAINER ||
 	    memcmp(inf->uuid, uuid_match_any, sizeof(int[4])) != 0)
@@ -1520,12 +1529,41 @@ static void fixup_container_spare_uuid(struct mdinfo *inf)
 				_sst = NULL;
 
 			if (_sst) {
-				memcpy(inf->uuid, array_list->uuid, sizeof(int[4]));
+				char *devices = array_list->devices;
+
+				if (!first_match)
+					first_match = array_list;
+
+				while (disk && devices && *devices) {
+					char path[PATH_MAX];
+					char *p = devices;
+					int fd;
+
+					devices = strchr(devices, ',');
+					if (!devices)
+						devices = p + strlen(p);
+					if (devices-p < PATH_MAX) {
+						strncpy(path, p, devices - p);
+						if ((fd = open(path, O_RDONLY)) >= 0) {
+							if (matchfd2devnum(fd, disk->major, disk->minor)) {
+								free(_sst);
+								close(fd);
+								goto match;
+							}
+							close(fd);
+						}
+						if (*devices == ',')
+							devices++;
+					}
+				}
 				free(_sst);
-				break;
 			}
 		}
 	}
+match:;
+	if (!array_list)
+		array_list = first_match;
+	memcpy(inf->uuid, array_list->uuid, sizeof(int[4]));
 }
 
 static void getinfo_super_imsm(struct supertype *st, struct mdinfo *info)
@@ -1584,7 +1622,7 @@ static void getinfo_super_imsm(struct supertype *st, struct mdinfo *info)
 		uuid_from_super_imsm(st, info->uuid);
 	else {
 		memcpy(info->uuid, uuid_match_any, sizeof(int[4]));
-		fixup_container_spare_uuid(info);
+		fixup_container_spare_uuid(info, super->disks);
 	}
 }
 
-- 
1.6.4.2

