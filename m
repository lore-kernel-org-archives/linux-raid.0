From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 1/2] Create: check for UnSet when looking at chunk
Date: Wed, 30 Mar 2011 12:28:11 +0100
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F012A8EB878@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "neilb@suse.de" <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

From ceb5a3431f27b5030d964567dedb0f983862b347 Mon Sep 17 00:00:00 2001
From: Anna Czarnowska <anna.czarnowska@intel.com>
Date: Wed, 30 Mar 2011 13:21:21 +0200
Subject: [PATCH 1/2] Create: check for UnSet when looking at chunk
Cc: linux-raid@vger.kernel.org, Williams, Dan J <dan.j.williams@intel.com>, Ciechanowski, Ed <ed.ciechanowski@intel.com>

A default chunk size of 0 gets modified to UnSet, so any location that
checks for !chunk really needs to check for !(chunk || chunk == UnSet).

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
---
 Create.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Create.c b/Create.c
index 9f34425..5709baf 100644
--- a/Create.c
+++ b/Create.c
@@ -266,7 +266,7 @@ int Create(struct supertype *st, char *mddev,
 					      &chunk, size*2, NULL, &newsize, verbose>=0))
 		return 1;
 
-	if (chunk) {
+	if (chunk && chunk != UnSet) {
 		newsize &= ~(unsigned long long)(chunk*2 - 1);
 		size &= ~(unsigned long long)(chunk - 1);
 	}
@@ -353,7 +353,7 @@ int Create(struct supertype *st, char *mddev,
 		}
 
 		freesize /= 2; /* convert to K */
-		if (chunk) {
+		if (chunk && chunk != UnSet) {
 			/* round to chunk size */
 			freesize = freesize & ~(chunk-1);
 		}
-- 
1.7.1

