From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 6/6] check that no disk over 2TB is used to create container
 when no support
Date: Thu, 29 Mar 2012 12:43:29 +0000
Message-ID: <3F8F31A3BFD1664EAB894D1BD6AF32B918A205F6@IRSMSX102.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Grabowski, Grzegorz" <grzegorz.grabowski@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

Creation of a container using disks over 2TB should be allowed only when orom supports large disks

Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
---
 super-intel.c |   24 ++++++++++++++++--------
 1 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index d0b1442..393a657 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5331,14 +5331,22 @@ static int validate_geometry_imsm_container(struct supertype *st, int level,
 		return 0;
 	}
 	close(fd);
-	if (super->orom && raiddisks > super->orom->tds) {
-		if (verbose)
-			fprintf(stderr, Name ": %d exceeds maximum number of"
-				" platform supported disks: %d\n",
-				raiddisks, super->orom->tds);
-
-		free_imsm(super);
-		return 0;
+	if (super->orom) {
+		if (raiddisks > super->orom->tds) {
+			if (verbose)
+				fprintf(stderr, Name ": %d exceeds maximum number of"
+					" platform supported disks: %d\n",
+					raiddisks, super->orom->tds);
+			free_imsm(super);
+			return 0;
+		}
+		if ((super->orom->attr & IMSM_OROM_ATTR_2TB_DISK) == 0 &&
+		    (ldsize >> 9) >> 32 > 0) {
+			if (verbose) 
+				fprintf(stderr, Name ": %s exceeds maximum platform supported size\n", dev);
+			free_imsm(super);
+			return 0;
+		}
 	}
 
 	*freesize = avail_size_imsm(st, ldsize >> 9);
-- 
1.6.4.2

