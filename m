From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 1/2] Monitor: only get min_size once
Date: Thu, 2 Dec 2010 21:58:29 +0000
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F010C172D5F@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: linux-raid.ids

From 558fea1534f09051156480daf6c786f54369144e Mon Sep 17 00:00:00 2001
From: Anna Czarnowska <anna.czarnowska@intel.com>
Date: Thu, 2 Dec 2010 16:44:58 +0100
Subject: [PATCH 1/2] Monitor: only get min_size once
Cc: linux-raid@vger.kernel.org, Williams, Dan J <dan.j.williams@intel.com>, Ciechanowski, Ed <ed.ciechanowski@intel.com>

We may call chose_spare several times before we find a suitable one
so it is better to get the size beforehand.

Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
---
 Monitor.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index e7f6d03..ab6eb2d 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -783,12 +783,10 @@ static int check_donor(struct state *from, struct state *to,
 }
 
 static dev_t choose_spare(struct state *from, struct state *to,
-			struct domainlist *domlist)
+			struct domainlist *domlist, unsigned long long min_size)
 {
 	int d;
 	dev_t dev = 0;
-	unsigned long long min_size
-		= min_spare_size_required(to);
 
 	for (d = from->raid; !dev && d < MaxDisks; d++) {
 		if (from->devid[d] > 0 &&
@@ -814,7 +812,7 @@ static dev_t choose_spare(struct state *from, struct state *to,
 }
 
 static dev_t container_choose_spare(struct state *from, struct state *to,
-				  struct domainlist *domlist)
+				  struct domainlist *domlist, unsigned long long min_size)
 {
 	/* This is similar to choose_spare, but we cannot trust devstate,
 	 * so we need to read the metadata instead
@@ -824,8 +822,6 @@ static dev_t container_choose_spare(struct state *from, struct state *to,
 	int fd = open(from->devname, O_RDONLY);
 	int err;
 	struct mdinfo *disks, *d;
-	unsigned long long min_size
-		= min_spare_size_required(to);
 	dev_t dev = 0;
 
 	if (fd < 0)
@@ -883,11 +879,13 @@ static void try_spare_migration(struct state *statelist, struct alert_info *info
 			struct domainlist *domlist = NULL;
 			int d;
 			struct state *to = st;
-
+			unsigned long long min_size;
+			
 			if (to->parent)
 				/* member of a container */
 				to = to->parent;
 
+			min_size = min_spare_size_required(to);
 			for (d = 0; d < MaxDisks; d++)
 				if (to->devid[d])
 					domainlist_add_dev(&domlist,
@@ -902,9 +900,10 @@ static void try_spare_migration(struct state *statelist, struct alert_info *info
 					continue;
 				if (from->metadata->ss->external)
 					devid = container_choose_spare(
-						from, to, domlist);
+						from, to, domlist, min_size);
 				else
-					devid = choose_spare(from, to, domlist);
+					devid = choose_spare(from, to, domlist,
+							     min_size);
 				if (devid > 0
 				    && move_spare(from, to, devid, info))
 						break;
-- 
1.7.1

