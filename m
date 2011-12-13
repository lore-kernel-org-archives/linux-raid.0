From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 3/3] imsm: FIX: return correct status from load_imsm_migr_rec()
Date: Tue, 13 Dec 2011 11:12:26 +0100
Message-ID: <20111213101226.15703.61859.stgit@gklab-128-013.igk.intel.com>
References: <20111213101210.15703.14918.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111213101210.15703.14918.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

load_imsm_migr_rec() should see difference between no migration record due
to no migration in progress and loading migration record error.
Additional return value (-2) was introduced to this function.

Using new status load_super_imsm_all() can correctly check loading
migration record status.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index e8e21f4..3a34f5a 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -2120,6 +2120,7 @@ static struct imsm_dev *imsm_get_device_during_migration(
  * Returns:
  *	 0 : success
  *	-1 : fail
+ *	-2 : no migration in progress
  ******************************************************************************/
 static int load_imsm_migr_rec(struct intel_super *super, struct mdinfo *info)
 {
@@ -2137,7 +2138,7 @@ static int load_imsm_migr_rec(struct intel_super *super, struct mdinfo *info)
 	/* nothing to load,no migration in progress?
 	*/
 	if (dev == NULL)
-		return 0;
+		return -2;
 	map = get_imsm_map(dev, MAP_0);
 
 	if (info) {
@@ -4079,13 +4080,16 @@ static int load_super_imsm_all(struct supertype *st, int fd, void **sbp,
 
 	/* load migration record */
 	err = load_imsm_migr_rec(super, NULL);
-	if (err) {
+	if (err == -1) {
+		/* migration is in progress,
+		 * but migr_rec cannot be loaded,
+		 */
 		err = 4;
 		goto error;
 	}
 
 	/* Check migration compatibility */
-	if (check_mpb_migr_compatibility(super) != 0) {
+	if ((err == 0) && (check_mpb_migr_compatibility(super) != 0)) {
 		fprintf(stderr, Name ": Unsupported migration detected");
 		if (devname)
 			fprintf(stderr, " on %s\n", devname);

