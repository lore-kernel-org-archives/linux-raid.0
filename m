From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 03/21] imsm: FIX: Verify if migration record is loaded
	correctly
Date: Wed, 08 Jun 2011 18:09:58 +0200
Message-ID: <20110608160958.24327.15155.stgit@gklab-128-013.igk.intel.com>
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

Migration compatibility can be checked when general migration record
is present.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   32 +++++++++++++++++++-------------
 1 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 01ffcc8..269cb0a 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -3038,8 +3038,8 @@ static int load_imsm_mpb(int fd, struct intel_super *super, char *devname)
 
 	if (lseek64(fd, dsize - (512 * 2), SEEK_SET) < 0) {
 		if (devname)
-			fprintf(stderr,
-				Name ": Cannot seek to anchor block on %s: %s\n",
+			fprintf(stderr, Name
+				": Cannot seek to anchor block on %s: %s\n",
 				devname, strerror(errno));
 		return 1;
 	}
@@ -3836,16 +3836,17 @@ static int load_super_imsm(struct supertype *st, int fd, char *devname)
 	}
 
 	/* load migration record */
-	load_imsm_migr_rec(super, NULL);
-
-	/* Check for unsupported migration features */
-	if (check_mpb_migr_compatibility(super) != 0) {
-		fprintf(stderr, Name ": Unsupported migration detected");
-		if (devname)
-			fprintf(stderr, " on %s\n", devname);
-		else
-			fprintf(stderr, " (IMSM).\n");
-		return 3;
+	if (load_imsm_migr_rec(super, NULL) == 0) {
+		/* Check for unsupported migration features */
+		if (check_mpb_migr_compatibility(super) != 0) {
+			fprintf(stderr,
+				Name ": Unsupported migration detected");
+			if (devname)
+				fprintf(stderr, " on %s\n", devname);
+			else
+				fprintf(stderr, " (IMSM).\n");
+			return 3;
+		}
 	}
 
 	return 0;
@@ -7763,7 +7764,12 @@ abort:
 int save_checkpoint_imsm(struct supertype *st, struct mdinfo *info, int state)
 {
 	struct intel_super *super = st->sb;
-	load_imsm_migr_rec(super, info);
+	if (load_imsm_migr_rec(super, info) != 0) {
+		dprintf("imsm: ERROR: Cannot read migration record "
+			"for checkpoint save.\n");
+		return 1;
+	}
+
 	if (__le32_to_cpu(super->migr_rec->blocks_per_unit) == 0) {
 		dprintf("ERROR: blocks_per_unit = 0!!!\n");
 		return 1;

