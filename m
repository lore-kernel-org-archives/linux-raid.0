From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: [mdadm PATCH 11/11] Enable OLCE for external IMSM metadata
Date: Wed, 24 Feb 2010 07:45:18 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D1016F65C5@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "Neil Brown (neilb@suse.de)" <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

From 09b869282f477a7d645949383f591a0ddf801b26 Mon Sep 17 00:00:00 2001
From: Adam Kwolek <adam.kwolek@intel.com>
Date: Tue, 23 Feb 2010 11:29:04 +0100
Subject: [PATCH] OLCE: Rebuild FIX

Changes to be committed:
	modified:   managemon.c
	modified:   monitor.c

Rebuild and OLCE has a conflict for Raid0 (when not fully initialized) array
(not monitored, but visible to monitor for a while)

In such case no degradation check (without breaking rebuild)

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---
 managemon.c |   10 ++++++++--
 monitor.c   |    3 ++-
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/managemon.c b/managemon.c
index b42a00b..5a4117f 100644
--- a/managemon.c
+++ b/managemon.c
@@ -437,7 +437,8 @@ static void manage_member(struct mdstat_ent *mdstat,
 	if ((a->takeover == requested) && (a->container)) {
 		struct metadata_update *updates = NULL;
 		int level_before_takeover = a->container->ss->takeover(a, &updates);
-		if (level_before_takeover != a->curr_level) {
+		if ((level_before_takeover != a->curr_level) &&
+		    (level_before_takeover > -1)) {
 			/* maintain return level after reshape */
 			if (a->reshape_return_level > -1) {
 				/* check if return level can be cleaned */
@@ -561,8 +562,13 @@ static void manage_member(struct mdstat_ent *mdstat,
 
 		a->check_degraded = 0;
 
-		if (a->reshape_return_level <= 0)
+		/* if current array level is 0
+		 * possible in result of takeover (it will be changed in a while)
+		 * so we do not chack for degradation
+		 */
+		if (a->curr_level == 0)
 			goto out;
+
 		/* The array may not be degraded, this is just a good time
 		 * to check.
 		 */
diff --git a/monitor.c b/monitor.c
index 7742202..be889a3 100644
--- a/monitor.c
+++ b/monitor.c
@@ -277,7 +277,8 @@ static int read_and_act(struct active_array *a)
  		a->takeover = none;		
  	}
     
- 	if (a->takeover == none) {
+ 	if ((a->takeover == none) &&
+ 	   (a->prev_level > -1)) {
 		/* check for raid level change */
  		if (a->curr_level != a->prev_level)	{
  			/* start takeover procedure */
-- 
1.6.0.2

