From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 2/2] Create: fix size after setting default chunk
Date: Wed, 30 Mar 2011 12:34:04 +0100
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F012A8EB88E@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "neilb@suse.de" <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

Hi Neil,
a small bit of code is duplicated in this patch but we decided it is not worth creating a helper function.
Regards
Anna

From fcc6aa15a590d4194c790a2d27dc2eee81a24631 Mon Sep 17 00:00:00 2001
From: Anna Czarnowska <anna.czarnowska@intel.com>
Date: Wed, 30 Mar 2011 11:45:02 +0200
Subject: [PATCH 2/2] Create: fix size after setting default chunk
Cc: linux-raid@vger.kernel.org, Williams, Dan J <dan.j.williams@intel.com>, Ciechanowski, Ed <ed.ciechanowski@intel.com>

When -e option is given then the first validate_geometry
sets default chunk. Size must be rounded there and do_default_chunk
needs to be set to 0 so that we don't repeat the message below.

If we start without st then what we find on the the first disk determines
the st and sets chunk. So after running
validate_geometry on the first disk we need to fix the size too.
At this point chunk should always be set but it is safer to keep the check.

Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
---
 Create.c |   25 ++++++++++++++++++-------
 1 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/Create.c b/Create.c
index 5709baf..fec96f1 100644
--- a/Create.c
+++ b/Create.c
@@ -268,8 +268,16 @@ int Create(struct supertype *st, char *mddev,
 
 	if (chunk && chunk != UnSet) {
 		newsize &= ~(unsigned long long)(chunk*2 - 1);
-		size &= ~(unsigned long long)(chunk - 1);
+		if (do_default_chunk) {
+			/* default chunk was just set */
+			if (verbose > 0)
+				fprintf(stderr, Name ": chunk size "
+					"defaults to %dK\n", chunk);
+			size &= ~(unsigned long long)(chunk - 1);
+			do_default_chunk = 0;
+		}
 	}
+
 	if (size == 0) {
 		size = newsize / 2;
 		if (size && verbose > 0)
@@ -316,7 +324,7 @@ int Create(struct supertype *st, char *mddev,
 						 verbose > 0)) {
 					free(st);
 					st = NULL;
-					chunk = do_default_chunk ? 0 : chunk;
+					chunk = do_default_chunk ? UnSet : chunk;
 				}
 			}
 
@@ -346,16 +354,19 @@ int Create(struct supertype *st, char *mddev,
 				continue;
 			}
 		}
-		if (verbose > 0 && do_default_chunk) {
-			do_default_chunk = 0;
-			fprintf(stderr, Name ": chunk size "
-				"defaults to %dK\n", chunk);
-		}
 
 		freesize /= 2; /* convert to K */
 		if (chunk && chunk != UnSet) {
 			/* round to chunk size */
 			freesize = freesize & ~(chunk-1);
+			if (do_default_chunk) {
+			/* default chunk was just set */
+				if (verbose > 0)
+					fprintf(stderr, Name ": chunk size "
+						"defaults to %dK\n", chunk);
+				size &= ~(unsigned long long)(chunk - 1);
+				do_default_chunk = 0;
+			}
 		}
 
 		if (size && freesize < size) {
-- 
1.7.1

