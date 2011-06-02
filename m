From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH 05/22] imsm: check migration compatibility
Date: Thu, 02 Jun 2011 16:48:51 +0200
Message-ID: <20110602144851.27355.91807.stgit@gklab-128-111.igk.intel.com>
References: <20110602144212.27355.3706.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110602144212.27355.3706.stgit@gklab-128-111.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

From: Adam Kwolek <adam.kwolek@intel.com>

Under Windows IMSM can reshape arrays in 2 directions
(ascending and decsending).
Under Linux one (ascending) direction is supported at this moment.
Block loading metadata when decsending reshape is detected

Windows also uses optimalization area during reshaping array.
Linux does not support it.
The patch blocks this operation also.

Signed-off-by: Maciej Trela <maciej.trela@intel.com>
Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
---
 super-intel.c |   61 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 61 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 1f7d008..31fae1e 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -2846,6 +2846,44 @@ struct bbm_log *__get_imsm_bbm_log(struct imsm_super *mpb)
 	return ptr;
 }
 
+/*******************************************************************************
+ * Function:	check_mpb_migr_compatibility
+ * Description:	Function checks for unsupported migration features:
+ *		- migration optimization area (pba_of_lba0)
+ *		- descending reshape (ascending_migr)
+ * Parameters:
+ *	super	: imsm metadata information
+ * Returns:
+ *	 0 : migration is compatible
+ *	-1 : migration is not compatible
+ ******************************************************************************/
+int check_mpb_migr_compatibility(struct intel_super *super)
+{
+	struct imsm_map *map0, *map1;
+	struct migr_record *migr_rec = super->migr_rec;
+	int i;
+
+	for (i = 0; i < super->anchor->num_raid_devs; i++) {
+		struct imsm_dev *dev_iter = __get_imsm_dev(super->anchor, i);
+
+		if (dev_iter &&
+		    dev_iter->vol.migr_state == 1 &&
+		    dev_iter->vol.migr_type == MIGR_GEN_MIGR) {
+			/* This device is migrating */
+			map0 = get_imsm_map(dev_iter, 0);
+			map1 = get_imsm_map(dev_iter, 1);
+			if (map0->pba_of_lba0 != map1->pba_of_lba0)
+				/* migration optimization area was used */
+				return -1;
+			if (migr_rec->ascending_migr == 0
+				&& migr_rec->dest_depth_per_unit > 0)
+				/* descending reshape not supported yet */
+				return -1;
+		}
+	}
+	return 0;
+}
+
 static void __free_imsm(struct intel_super *super, int free_disks);
 
 /* load_imsm_mpb - read matrix metadata
@@ -3575,6 +3613,19 @@ static int load_super_imsm_all(struct supertype *st, int fd, void **sbp,
 		err = 4;
 		goto error;
 	}
+
+	/* Check migration compatibility */
+	if (check_mpb_migr_compatibility(super) != 0) {
+		fprintf(stderr, Name ": Unsupported migration detected");
+		if (devname)
+			fprintf(stderr, " on %s\n", devname);
+		else
+			fprintf(stderr, " (IMSM).\n");
+
+		err = 5;
+		goto error;
+	}
+
 	err = 0;
 
  error:
@@ -3657,6 +3708,16 @@ static int load_super_imsm(struct supertype *st, int fd, char *devname)
 	/* load migration record */
 	load_imsm_migr_rec(super, NULL);
 
+	/* Check for unsupported migration features */
+	if (check_mpb_migr_compatibility(super) != 0) {
+		fprintf(stderr, Name ": Unsupported migration detected");
+		if (devname)
+			fprintf(stderr, " on %s\n", devname);
+		else
+			fprintf(stderr, " (IMSM).\n");
+		return 3;
+	}
+
 	return 0;
 }
 

