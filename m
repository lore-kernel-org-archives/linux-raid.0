From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 1/9] imsm: fix max disks per array
Date: Thu, 25 Aug 2011 19:14:04 -0700
Message-ID: <20110826021404.28015.39211.stgit@localhost6.localdomain6>
References: <20110826020908.28015.52384.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110826020908.28015.52384.stgit@localhost6.localdomain6>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, Marcin Labun <marcin.labun@intel.com>, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

Validate geometry is incorrectly looking at max disks support which is
irrelevant for md/mdadm.  ->dpa (disks per array) is how many disks the
orom will allow per volume.

Also cleanup an unnecessary ->orom check, is_raid_level_supported()
already does the right thing in the !orom case.

Cc: Marcin Labun <marcin.labun@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 super-intel.c |   19 +++++--------------
 1 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index ddf4de9..a921cbc 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -4933,28 +4933,19 @@ static int imsm_default_chunk(const struct imsm_orom *orom)
 }
 
 #define pr_vrb(fmt, arg...) (void) (verbose && fprintf(stderr, Name fmt, ##arg))
-/*
- * validate volume parameters with OROM/EFI capabilities
- */
 static int
 validate_geometry_imsm_orom(struct intel_super *super, int level, int layout,
 			    int raiddisks, int *chunk, int verbose)
 {
-#if DEBUG
-	verbose = 1;
-#endif
-	/* validate container capabilities */
-	if (super->orom && raiddisks > super->orom->tds) {
-		if (verbose)
-			fprintf(stderr, Name ": %d exceeds maximum number of"
-				" platform supported disks: %d\n",
-				raiddisks, super->orom->tds);
+	/* check/set platform and metadata limits/defaults */
+	if (super->orom && raiddisks > super->orom->dpa) {
+		pr_vrb(": platform supports a maximum of %d disks per array\n",
+		       super->orom->dpa);
 		return 0;
 	}
 
         /* capabilities of OROM tested - copied from validate_geometry_imsm_volume */
-	if (super->orom && (!is_raid_level_supported(super->orom, level,
-						     raiddisks))) {
+	if (!is_raid_level_supported(super->orom, level, raiddisks)) {
 		pr_vrb(": platform does not support raid%d with %d disk%s\n",
 			level, raiddisks, raiddisks > 1 ? "s" : "");
 		return 0;

