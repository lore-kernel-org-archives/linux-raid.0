From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 4/4] Monitor: array that has disappeared doesn't need spares
Date: Fri, 26 Nov 2010 18:28:57 +0000
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F010C009E40@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: linux-raid.ids

From 4d1f9e34397a7e9f0af8a68025a9f9e76ead57c3 Mon Sep 17 00:00:00 2001
From: Anna Czarnowska <anna.czarnowska@intel.com>
Date: Fri, 26 Nov 2010 15:31:15 +0100
Subject: [PATCH 4/4] Monitor: array that has disappeared doesn't need spares
Cc: linux-raid@vger.kernel.org, Williams, Dan J <dan.j.williams@intel.com>, Ciechanowski, Ed <ed.ciechanowski@intel.com>

If a degraded array disappears we still have it in statelist
with active<raid but it is pointless to look for spares for it.

Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
---
 Monitor.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index b78a66b..0a7c25f 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -877,7 +877,7 @@ static void try_spare_migration(struct state *statelist, struct alert_info *info
 	link_containers_with_subarrays(statelist);
 	for (st = statelist; st; st = st->next)
 		if (st->active < st->raid &&
-		    st->spare == 0) {
+		    st->spare == 0 && !st->err) {
 			struct domainlist *domlist = NULL;
 			int d;
 			struct state *to = st;
-- 
1.7.1

