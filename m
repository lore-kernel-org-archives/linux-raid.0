From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH] Monitor: few bug fixes for spare migration
Date: Thu, 25 Nov 2010 17:28:29 +0000
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F010C00972F@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Czarnowska, Anna" <anna.czarnowska@intel.com>
List-Id: linux-raid.ids

From bbe35756559c6bee0309ce7ebae668c53d5e1a74 Mon Sep 17 00:00:00 2001
From: Anna Czarnowska <anna.czarnowska@intel.com>
Date: Thu, 25 Nov 2010 18:25:03 +0100
Subject: [PATCH] Monitor: few bug fixes for spare migration
Cc: linux-raid@vger.kernel.org, Williams, Dan J <dan.j.williams@intel.com>, Ciechanowski, Ed <ed.ciechanowski@intel.com>

1. If array not changed we should still report anydegraded
- another array may have got a new spare that we can move.
2. Array with err=1 can't give a spare.
3. Spares can't be migrated between different metadata arrays.
4. We look for spares in "from" not "st" which is supertype
and has devname=NULL.

Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
---
 Monitor.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index 9ba49f2..f1d0c9d 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -497,7 +497,10 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
 		    ))) {
 		close(fd);
 		st->err = 0;
-		return 0;
+		if ((st->active < st->raid) && st->spare == 0)
+			return 1;
+		else
+			return 0;
 	}
 	if (st->utime == 0 && /* new array */
 	    mse->pattern && strchr(mse->pattern, '_') /* degraded */
@@ -751,6 +754,10 @@ static int check_donor(struct state *from, struct state *to,
 	if (from->parent)
 		/* Cannot move from a member */
 		return 0;
+	if (from->err)
+		return 0;
+	if (from->metadata->ss != to->metadata->ss)
+		return 0;
 	for (sub = from->subarray; sub; sub = sub->subarray)
 		/* If source array has degraded subarrays, don't
 		 * remove anything
@@ -806,7 +813,7 @@ static int container_choose_spare(struct state *from, struct state *to,
 	 */
 
 	struct supertype *st = from->metadata;
-	int fd = open(st->devname, O_RDONLY);
+	int fd = open(from->devname, O_RDONLY);
 	int err;
 	struct mdinfo *disks, *d;
 	unsigned long long min_size
-- 
1.7.1

