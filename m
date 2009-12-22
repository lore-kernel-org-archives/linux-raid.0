From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 02/13] imsm: honor orom constraints for auto-layout
Date: Tue, 22 Dec 2009 16:59:29 -0700
Message-ID: <20091222235929.31628.32471.stgit@dwillia2-linux.ch.intel.com>
References: <20091222235807.31628.23231.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091222235807.31628.23231.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com
List-Id: linux-raid.ids

Factor out the orom checking bits to validate_geometry_imsm_orom() and
share it between validate_geometry_imsm_volume() and the entry path to
reserve_space().

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 super-intel.c |   52 +++++++++++++++++++++++++++++++++-------------------
 1 files changed, 33 insertions(+), 19 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 6fe5e0d..4372ab4 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -3421,6 +3421,34 @@ static int is_raid_level_supported(const struct imsm_orom *orom, int level, int
 }
 
 #define pr_vrb(fmt, arg...) (void) (verbose && fprintf(stderr, Name fmt, ##arg))
+static int
+validate_geometry_imsm_orom(struct intel_super *super, int level, int layout,
+			    int raiddisks, int chunk, int verbose)
+{
+	if (!is_raid_level_supported(super->orom, level, raiddisks)) {
+		pr_vrb(": platform does not support raid%d with %d disk%s\n",
+			level, raiddisks, raiddisks > 1 ? "s" : "");
+		return 0;
+	}
+	if (super->orom && level != 1 &&
+	    !imsm_orom_has_chunk(super->orom, chunk)) {
+		pr_vrb(": platform does not support a chunk size of: %d\n", chunk);
+		return 0;
+	}
+	if (layout != imsm_level_to_layout(level)) {
+		if (level == 5)
+			pr_vrb(": imsm raid 5 only supports the left-asymmetric layout\n");
+		else if (level == 10)
+			pr_vrb(": imsm raid 10 only supports the n2 layout\n");
+		else
+			pr_vrb(": imsm unknown layout %#x for this raid level %d\n",
+				layout, level);
+		return 0;
+	}
+
+	return 1;
+}
+
 /* validate_geometry_imsm_volume - lifted from validate_geometry_ddf_bvd 
  * FIX ME add ahci details
  */
@@ -3443,26 +3471,8 @@ static int validate_geometry_imsm_volume(struct supertype *st, int level,
 	if (!super)
 		return 0;
 
-	if (!is_raid_level_supported(super->orom, level, raiddisks)) {
-		pr_vrb(": platform does not support raid%d with %d disk%s\n",
-			level, raiddisks, raiddisks > 1 ? "s" : "");
+	if (!validate_geometry_imsm_orom(super, level, layout, raiddisks, chunk, verbose))
 		return 0;
-	}
-	if (super->orom && level != 1 &&
-	    !imsm_orom_has_chunk(super->orom, chunk)) {
-		pr_vrb(": platform does not support a chunk size of: %d\n", chunk);
-		return 0;
-	}
-	if (layout != imsm_level_to_layout(level)) {
-		if (level == 5)
-			pr_vrb(": imsm raid 5 only supports the left-asymmetric layout\n");
-		else if (level == 10)
-			pr_vrb(": imsm raid 10 only supports the n2 layout\n");
-		else
-			pr_vrb(": imsm unknown layout %#x for this raid level %d\n",
-				layout, level);
-		return 0;
-	}
 
 	if (!dev) {
 		/* General test:  make sure there is space for
@@ -3689,6 +3699,10 @@ static int validate_geometry_imsm(struct supertype *st, int level, int layout,
 			 * created.  add_to_super and getinfo_super
 			 * detect when autolayout is in progress.
 			 */
+			if (!validate_geometry_imsm_orom(st->sb, level, layout,
+							 raiddisks, chunk,
+							 verbose))
+				return 0;
 			return reserve_space(st, raiddisks, size, chunk, freesize);
 		}
 		return 1;

