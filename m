From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 2/2] fix: memory leak in Create
Date: Thu, 17 Feb 2011 22:46:00 +0000
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F01118FAADE@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "neilb@suse.de" <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

From 8307153207e20e218896adbb3ca9dfef63b0742c Mon Sep 17 00:00:00 2001
From: Anna Czarnowska <anna.czarnowska@intel.com>
Date: Thu, 17 Feb 2011 22:47:23 +0100
Subject: [PATCH 2/2] fix: memory leak in Create
Cc: linux-raid@vger.kernel.org, Williams, Dan J <dan.j.williams@intel.com>, Ciechanowski, Ed <ed.ciechanowski@intel.com>

match_metadata_desc allocates memory for st
which is not needed after validate_geometry fails

Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
---
 Create.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/Create.c b/Create.c
index a0669fe..ccda07b 100644
--- a/Create.c
+++ b/Create.c
@@ -309,8 +309,10 @@ int Create(struct supertype *st, char *mddev,
 				if (st && !st->ss->validate_geometry
 					    	(st, level, layout, raiddisks,
 						 chunk, size*2, dname, &freesize,
-						 verbose > 0))
+						 verbose > 0)) {
+					free(st);
 					st = NULL;
+				}
 			}
 
 			if (!st) {
-- 
1.7.1

