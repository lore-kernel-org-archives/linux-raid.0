From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 1/3] imsm: FIX: Chunk size migration is not possible
Date: Wed, 14 Dec 2011 16:07:05 +0100
Message-ID: <20111214150704.21483.66299.stgit@gklab-128-013.igk.intel.com>
References: <20111214150448.21483.16231.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111214150448.21483.16231.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

Chunk size only migration for raid0 and raid5 is not possible.
(mdadm UT 15* fails). Mdadm exits with information:
   mdadm: imsm unknown layout 0xffffffff for this raid level 0

Problem was introduced in patch (2011-11-16):
   imsm: platform capabilities are not validated during level migration

During chunk size migration layout variable is not set correctly.
Set it correctly for this migration type.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   19 ++++++++++++-------
 1 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 3a34f5a..e1073ef 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -9050,8 +9050,10 @@ enum imsm_reshape_type imsm_analyze_change(struct supertype *st,
 	int change = -1;
 	int check_devs = 0;
 	int chunk;
-	int devNumChange=0;
-	int layout = -1;
+	/* number of added/removed disks in operation result */
+	int devNumChange = 0;
+	/* imsm compatible layout value for array geometry verification */
+	int imsm_layout = -1;
 
 	getinfo_super_imsm_volume(st, &info, NULL);
 	if ((geo->level != info.array.level) &&
@@ -9069,14 +9071,14 @@ enum imsm_reshape_type imsm_analyze_change(struct supertype *st,
 					change = -1;
 					goto analyse_change_exit;
 				}
-				layout =  geo->layout;
+				imsm_layout =  geo->layout;
 				check_devs = 1;
 				devNumChange = 1; /* parity disk added */
 			} else if (geo->level == 10) {
 				change = CH_TAKEOVER;
 				check_devs = 1;
 				devNumChange = 2; /* two mirrors added */
-				layout = 0x102; /* imsm supported layout */
+				imsm_layout = 0x102; /* imsm supported layout */
 			}
 			break;
 		case 1:
@@ -9085,7 +9087,7 @@ enum imsm_reshape_type imsm_analyze_change(struct supertype *st,
 				change = CH_TAKEOVER;
 				check_devs = 1;
 				devNumChange = -(geo->raid_disks/2);
-				layout = 0; /* imsm raid0 layout */
+				imsm_layout = 0; /* imsm raid0 layout */
 			}
 			break;
 		}
@@ -9120,8 +9122,11 @@ enum imsm_reshape_type imsm_analyze_change(struct supertype *st,
 			change = -1;
 			goto analyse_change_exit;
 		}
-	} else
+	} else {
 		geo->layout = info.array.layout;
+		if (imsm_layout == -1)
+			imsm_layout = info.array.layout;
+	}
 
 	if ((geo->chunksize > 0) && (geo->chunksize != UnSet)
 	    && (geo->chunksize != info.array.chunk_size))
@@ -9132,7 +9137,7 @@ enum imsm_reshape_type imsm_analyze_change(struct supertype *st,
 	chunk = geo->chunksize / 1024;
 	if (!validate_geometry_imsm(st,
 				    geo->level,
-				    layout,
+				    imsm_layout,
 				    geo->raid_disks + devNumChange,
 				    &chunk,
 				    geo->size,

