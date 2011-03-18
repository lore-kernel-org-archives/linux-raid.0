From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH] FIX: Do not count as backup devices,
	spare disks used for reshape
Date: Fri, 18 Mar 2011 11:55:12 +0100
Message-ID: <20110318105511.6462.93752.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Problem:
Reshape is run without specified backup file when all spares are used for expansion.

When spare disks are used for reshape, they should not be counted as backup devices.
Md still thinks about them as about spares until reshape will not be started.
mdadm should have all it in mind.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/Grow.c b/Grow.c
index b639585..17c22fc 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1660,6 +1660,7 @@ static int reshape_array(char *container, int fd, char *devname,
 	unsigned long long array_size;
 	int done;
 	struct mdinfo *sra = NULL;
+	int used_spares = 0;
 
 	/* when reshaping a RAID0, the component_size might be zero.
 	 * So try to fix that up.
@@ -1793,6 +1794,7 @@ static int reshape_array(char *container, int fd, char *devname,
 					 * be part of the array.
 					 */
 					add_disk(fd, st, info2, d);
+					used_spares++;
 				}
 			}
 			sysfs_free(info2);
@@ -1956,7 +1958,7 @@ started:
 				Name ": %s: Cannot grow - need backup-file\n", 
 				devname);
 			goto release;
-		} else if (sra->array.spare_disks == 0) {
+		} else if (sra->array.spare_disks - used_spares == 0) {
 			fprintf(stderr, Name ": %s: Cannot grow - need a spare or "
 				"backup-file to backup critical section\n",
 				devname);

