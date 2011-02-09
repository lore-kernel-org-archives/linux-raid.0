From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 2/4] imsm: Use single migration type for all migrations
Date: Wed, 09 Feb 2011 14:47:46 +0100
Message-ID: <20110209134746.4559.28788.stgit@gklab-128-013.igk.intel.com>
References: <20110209134737.4559.34527.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110209134737.4559.34527.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Use single enum definition/migration type for all migrations.
Using separate definitions causes limitation for number of changes
in metadata implementation during single update for migration/reshape.
Single CH_MIGRATION enum allows for many mtadata parameters change
in single update. It will be possible to change i.e. chunk size together
with raid level. In current implementation 2 metadata updates would be
required for such action, one using CH_CHUNK_MIGR and second using
CH_LEVEL_MIGRATION migration type.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   16 ++++++----------
 1 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 2875ade..876cc4c 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -294,8 +294,7 @@ struct extent {
 /* definitions of reshape process types */
 enum imsm_reshape_type {
 	CH_TAKEOVER,
-	CH_CHUNK_MIGR,
-	CH_LEVEL_MIGRATION
+	CH_MIGRATION
 };
 
 /* definition of messages passed to imsm_process_update */
@@ -6919,7 +6918,7 @@ enum imsm_reshape_type imsm_analyze_change(struct supertype *st,
 		switch (info.array.level) {
 		case 0:
 			if (geo->level == 5) {
-				change = CH_LEVEL_MIGRATION;
+				change = CH_MIGRATION;
 				check_devs = 1;
 			}
 			if (geo->level == 10) {
@@ -6935,7 +6934,7 @@ enum imsm_reshape_type imsm_analyze_change(struct supertype *st,
 			break;
 		case 5:
 			if (geo->level == 0)
-				change = CH_LEVEL_MIGRATION;
+				change = CH_MIGRATION;
 			break;
 		case 10:
 			if (geo->level == 0) {
@@ -6956,7 +6955,7 @@ enum imsm_reshape_type imsm_analyze_change(struct supertype *st,
 
 	if ((geo->layout != info.array.layout)
 	    && ((geo->layout != UnSet) && (geo->layout != -1))) {
-		change = CH_LEVEL_MIGRATION;
+		change = CH_MIGRATION;
 		if ((info.array.layout == 0)
 		    && (info.array.level == 5)
 		    && (geo->layout == 5)) {
@@ -6980,7 +6979,7 @@ enum imsm_reshape_type imsm_analyze_change(struct supertype *st,
 
 	if ((geo->chunksize > 0) && (geo->chunksize != UnSet)
 	    && (geo->chunksize != info.array.chunk_size))
-		change = CH_CHUNK_MIGR;
+		change = CH_MIGRATION;
 	else
 		geo->chunksize = info.array.chunk_size;
 
@@ -7128,10 +7127,7 @@ static int imsm_reshape_super(struct supertype *st, long long size, int level,
 		case CH_TAKEOVER:
 			ret_val = imsm_takeover(st, &geo);
 			break;
-		case CH_CHUNK_MIGR:
-			ret_val = 0;
-			break;
-		case CH_LEVEL_MIGRATION:
+		case CH_MIGRATION:
 			ret_val = 0;
 			break;
 		default:

