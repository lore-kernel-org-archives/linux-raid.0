From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 1/2] Assemble: we need to read policy to know array domains
Date: Tue, 4 Jan 2011 14:05:09 +0000
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F010E759F49@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

From ae360c641fc5c266bb419612e6542b6f9f3e38ca Mon Sep 17 00:00:00 2001
From: Anna Czarnowska <anna.czarnowska@intel.com>
Date: Tue, 4 Jan 2011 11:47:34 +0100
Subject: [PATCH 1/2] Assemble: we need to read policy to know array domains
Cc: linux-raid@vger.kernel.org, Williams, Dan J <dan.j.williams@intel.com>, Ciechanowski, Ed <ed.ciechanowski@intel.com>

Policy must be read on all disks identified as array members
to get array's domains list.
Currently it is only read on first array member in auto assembly mode.

Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
---
 Assemble.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 5725b23..ed59e8b 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -547,7 +547,8 @@ int Assemble(struct supertype *st, char *mddev,
 	loop:
 		/* Collect domain information from members only */
 		if (tmpdev && tmpdev->used == 1)
-			domain_merge(&domains, pol, tst?tst->ss->name:NULL);
+			domain_merge(&domains, pol?pol:devnum_policy(stb.st_rdev),
+				     tst?tst->ss->name:NULL);
 		dev_policy_free(pol);
 		pol = NULL;
 		if (tst)
-- 
1.7.1

