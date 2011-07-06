From: Milan Broz <mbroz@redhat.com>
Subject: [PATCH] mdadm: fix build failures (ppc64)
Date: Wed,  6 Jul 2011 21:48:00 +0200
Message-ID: <1309981680-7714-1-git-send-email-mbroz@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, Milan Broz <mbroz@redhat.com>
List-Id: linux-raid.ids

This patch fixes these build issues:

super-intel.c: In function 'getinfo_super_imsm_volume':
super-intel.c:2327:4: error: format '%llu' expects argument of type 'long long
unsigned int', but argument 3 has type '__u64' [-Werror=format]

super-intel.c: In function 'imsm_reshape_super':
super-intel.c:8665:7: error: 'devnum' may be used uninitialized in this function [-Werror=uninitialized]

Signed-off-by: Milan Broz <mbroz@redhat.com>
---
 super-intel.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 2ef2b3c..572b710 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -2326,7 +2326,9 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
 
 			dprintf("IMSM: General Migration checkpoint : %llu "
 			       "(%llu) -> read reshape progress : %llu\n",
-				units, blocks_per_unit, info->reshape_progress);
+				(unsigned long long)units,
+				(unsigned long long)blocks_per_unit,
+				info->reshape_progress);
 
 			used_disks = imsm_num_data_members(dev, 1);
 			if (used_disks > 0) {
@@ -8661,7 +8663,11 @@ static int imsm_reshape_super(struct supertype *st, long long size, int level,
 		dprintf("imsm: info: Volume operation\n");
 		/* find requested device */
 		while (dev) {
-			imsm_find_array_minor_by_subdev(dev->index, st->container_dev, &devnum);
+			if (imsm_find_array_minor_by_subdev(dev->index,
+			    st->container_dev, &devnum) < 0) {
+				dprintf("imsm: cannot find array\n");
+				goto exit_imsm_reshape_super;
+			}
 			if (devnum == geo.dev_id)
 				break;
 			dev = dev->next;
-- 
1.7.5.4

