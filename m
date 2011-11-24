From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH] imsm: do not fail load_container when first 2 disks are
 missing
Date: Thu, 24 Nov 2011 11:24:16 +0000
Message-ID: <3F8F31A3BFD1664EAB894D1BD6AF32B9053871@IRSMSX102.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

Failure to find migration record should not fail the whole load_container.
It causes that degraded raid10 with first 2 disks missing cannot be assembled.

Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
---
 super-intel.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index a0672bf..21147c2 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -3953,15 +3953,9 @@ static int load_super_imsm_all(struct supertype *st, int fd, void **sbp,
 		goto error;
 	}
 
-	/* load migration record */
-	err = load_imsm_migr_rec(super, NULL);
-	if (err) {
-		err = 4;
-		goto error;
-	}
-
 	/* Check migration compatibility */
-	if (check_mpb_migr_compatibility(super) != 0) {
+	if (load_imsm_migr_rec(super, NULL) == 0 &&
+	    check_mpb_migr_compatibility(super) != 0) {
 		fprintf(stderr, Name ": Unsupported migration detected");
 		if (devname)
 			fprintf(stderr, " on %s\n", devname);
-- 


