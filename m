From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 31/53] imsm: FIX: Fill delta_disks field in getinfo_super()
Date: Fri, 26 Nov 2010 09:07:53 +0100
Message-ID: <20101126080753.5221.40967.stgit@gklab-170-024.igk.intel.com>
References: <20101126075407.5221.62582.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101126075407.5221.62582.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

delta_disks field is not always filled during getinfo_super() call.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 3243132..3f75550 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1487,6 +1487,7 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info)
 	struct intel_super *super = st->sb;
 	struct imsm_dev *dev = get_imsm_dev(super, super->current_vol);
 	struct imsm_map *map = get_imsm_map(dev, 0);
+	struct imsm_map *map2 = get_imsm_map(dev, 1);
 	struct dl *dl;
 	char *devname;
 	int minor;
@@ -1566,6 +1567,12 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info)
 	 */
 	if (find_array_minor2(info->text_version, 1, st->devnum, &minor) == 0)
 		sprintf(info->sys_name, "md%i", minor);
+
+	/* fill delta_disks field
+	 */
+	info->delta_disks = 0;
+	if (map2)
+		info->delta_disks = map->num_members - map2->num_members;
 }
 
 /* check the config file to see if we can return a real uuid for this spare */

