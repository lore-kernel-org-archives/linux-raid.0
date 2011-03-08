From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: [PATCH 09/14] imsm: print-out error message when volume validation
 fails
Date: Tue, 8 Mar 2011 15:21:11 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D17A8AEC92@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

From 54ad2b943c730e162d9cc69cf6746256eb2cb651 Mon Sep 17 00:00:00 2001
From: Marcin Labun <marcin.labun@intel.com>
Date: Thu, 3 Mar 2011 15:13:08 +0100
Subject: [PATCH 09/14] imsm: print-out error message when volume validation fails

Print-out error message when volume geometry fails to comply with
OROM/EFI controller's capabilities.

Signed-off-by: Marcin Labun <marcin.labun@intel.com>
---
 super-intel.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index e65a46c..2539efd 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -4284,9 +4284,11 @@ static int validate_geometry_imsm_volume(struct supertype *st, int level,
 	if (!super)
 		return 0;
 
-	if (!validate_geometry_imsm_orom(super, level, layout, raiddisks, chunk, verbose))
+	if (!validate_geometry_imsm_orom(super, level, layout, raiddisks, chunk, verbose)) {
+		fprintf(stderr, Name ": RAID gemetry validation failed. "
+			"Cannot proceed with the action(s).\n");
 		return 0;
-
+	}
 	if (!dev) {
 		/* General test:  make sure there is space for
 		 * 'raiddisks' device extents of size 'size' at a given
@@ -4493,7 +4495,8 @@ static int validate_geometry_imsm(struct supertype *st, int level, int layout,
 	struct mdinfo *sra;
 	int is_member = 0;
 
-	/* if given unused devices create a container 
+	/* load capability
+	 * if given unused devices create a container
 	 * if given given devices in a container create a member volume
 	 */
 	if (level == LEVEL_CONTAINER) {
-- 
1.6.4.2

