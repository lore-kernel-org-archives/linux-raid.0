From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 15/21] imsm: FIX: Remove unused variables and code
Date: Wed, 08 Jun 2011 18:11:34 +0200
Message-ID: <20110608161134.24327.78184.stgit@gklab-128-013.igk.intel.com>
References: <20110608160222.24327.71439.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110608160222.24327.71439.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Unused variables and code can be removed from imsm_manage_reshape()

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   14 +-------------
 1 files changed, 1 insertions(+), 13 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 55829cf..2dd73c0 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -8695,7 +8695,7 @@ static int imsm_manage_reshape(
 	struct intel_super *super = st->sb;
 	struct intel_dev *dv = NULL;
 	struct imsm_dev *dev = NULL;
-	struct imsm_map *map_src, *map_dest;
+	struct imsm_map *map_src;
 	int migr_vol_qan = 0;
 	int ndata, odata; /* [bytes] */
 	int chunk; /* [bytes] */
@@ -8705,7 +8705,6 @@ static int imsm_manage_reshape(
 	unsigned long long max_position; /* array size [bytes] */
 	unsigned long long next_step; /* [blocks]/[bytes] */
 	unsigned long long old_data_stripe_length;
-	unsigned long long new_data_stripe_length;
 	unsigned long long start_src; /* [bytes] */
 	unsigned long long start; /* [bytes] */
 	unsigned long long start_buf_shift; /* [bytes] */
@@ -8734,7 +8733,6 @@ static int imsm_manage_reshape(
 	map_src = get_imsm_map(dev, 1);
 	if (map_src == NULL)
 		goto abort;
-	map_dest = get_imsm_map(dev, 0);
 
 	ndata = imsm_num_data_members(dev, 0);
 	odata = imsm_num_data_members(dev, 1);
@@ -8744,11 +8742,6 @@ static int imsm_manage_reshape(
 
 	migr_rec = super->migr_rec;
 
-	/* [bytes] */
-	sra->new_chunk = __le16_to_cpu(map_dest->blocks_per_strip) * 512;
-	sra->new_level = map_dest->raid_level;
-	new_data_stripe_length = sra->new_chunk * ndata;
-
 	/* initialize migration record for start condition */
 	if (sra->reshape_progress == 0)
 		init_migr_record_imsm(st, dev, sra);
@@ -8847,11 +8840,6 @@ static int imsm_manage_reshape(
 					"migration record (UNIT_SRC_IN_CP_AREA)\n");
 				goto abort;
 			}
-			/* decrease backup_blocks */
-			if (backup_blocks > (unsigned long)next_step)
-				backup_blocks -= next_step;
-			else
-				backup_blocks = 0;
 		}
 		/* When data backed up, checkpoint stored,
 		 * kick the kernel to reshape unit of data

