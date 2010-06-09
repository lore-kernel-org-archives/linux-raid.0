From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: [PATCH 19/23] Expand raid0 array using takeover
Date: Wed, 9 Jun 2010 15:41:30 +0100
Message-ID: <905EDD02F158D948B186911EB64DB3D11EECE8F6@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

(Online Capacity Expansion for IMSM)
For raid0 array grow operation is not possible due to lack of implementation in md for this raid level.
In fact raid0 volume can be represented as degraded raid5 (layout 4) with missing parity disk, so for raid0 grow operation we have execute takeover. From metadata perspective nothing has changed, so no additional metadata update is required.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |   23 ++++++++++++++++++++++-
 1 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/Grow.c b/Grow.c
index 85d7fe0..77e554c 100644
--- a/Grow.c
+++ b/Grow.c
@@ -615,6 +615,14 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 		return 1;
 	}
 
+	/* Online Capacity Expansion uses takeover
+	 */
+	if ((array.level == 0) && (level == UnSet)) {
+		/* for raid0 use takeover to raid5
+		 */
+		level = 5;
+	}
+
 	/* ========= set size =============== */
 	if (size >= 0 && (size == 0 || size != array.size)) {
 		array.size = size;
@@ -878,6 +886,12 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 				/* if raid0 was takeovered by any other
 				 * personality start mdmon */
 				if (level > 0 && orig.level == 0) {
+					/* Online Capacity Expansion uses takeover.
+					 * We have degragated array, so target
+					 * disks number has to be increased
+					 */
+					if ((level == 5) && (raid_disks > 0))
+						raid_disks++;
 					if (!mdmon_running(dn))
 						start_mdmon(dn);
 					ping_monitor(devnum2devname(dn));
@@ -1288,6 +1302,7 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 			int counter = 20;
 			int result = -1;
 			struct mdu_array_info_s test_array;
+			int required_disks = 0;
 
 			array.raid_disks = ndisks;
 			/* check if we have external or native metadata @@ -1321,6 +1336,12 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 			if (result != 0)
 				goto ext_array_setup_exit;
 
+			required_disks = ndisks;
+			/* have in mind degradation (takeover)
+			 */
+			if (ioctl(fd, GET_ARRAY_INFO, &test_array) >= 0)
+				required_disks -= test_array.raid_disks - test_array.working_disks;
+
 			/* prepare meta update and add devices to mdmon
 			 */
 			info.delta_disks = delta_disks;
@@ -1340,7 +1361,7 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 				 */
 				if (ioctl(fd, GET_ARRAY_INFO, &test_array) < 0)
 					counter--;
-				else if (test_array.working_disks == ndisks) {
+				else if (test_array.working_disks == required_disks) {
 						counter = 0;
 						external_meta_status = EXTERNAL_META_STATUS_OK;
 					} else {

