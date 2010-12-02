From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 2/2] Monitor: don't add more spares than needed
Date: Thu, 2 Dec 2010 21:59:27 +0000
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F010C172D60@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: linux-raid.ids

From ce59ecdb2b6a6e1fc65c645d0ca8733056e4979a Mon Sep 17 00:00:00 2001
From: Anna Czarnowska <anna.czarnowska@intel.com>
Date: Thu, 2 Dec 2010 22:48:19 +0100
Subject: [PATCH 2/2] Monitor: don't add more spares than needed
Cc: linux-raid@vger.kernel.org, Williams, Dan J <dan.j.williams@intel.com>, Ciechanowski, Ed <ed.ciechanowski@intel.com>

When we add a spare to a container it takes a while
before it is noticed by mdmon and recovery starts.
During this time the array remains degraded but we don't want to add
any more spares to this container. Therefore we must check container
with degraded array if it doesn't already have a suitable spare.
container_choose_spare is reused with from=to
Domain check is not needed in this situation.

Ping_manager after moving disk is needed to be able to see
newly added disk in container after coming back through the loop.

Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
---
 Monitor.c |   33 +++++++++++++++++++++++----------
 1 files changed, 23 insertions(+), 10 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index ab6eb2d..c75b2c1 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -743,6 +743,8 @@ static int move_spare(struct state *from, struct state *to,
 		devlist.disposition = 'a';
 		if (Manage_subdevs(to->devname, fd1, &devlist, -1, 0) == 0) {
 			alert("MoveSpare", to->devname, from->devname, info);
+			ping_manager(to->devname);
+			ping_manager(from->devname);
 			close(fd1);
 			close(fd2);
 			return 1;
@@ -842,7 +844,6 @@ static dev_t container_choose_spare(struct state *from, struct state *to,
 	
 	for (d = disks->devs ; d && !dev ; d = d->next) {
 		if (d->disk.state == 0) {
-			struct dev_policy *pol;
 			unsigned long long dev_size;
 			dev = makedev(d->disk.major,d->disk.minor);
 			
@@ -852,14 +853,17 @@ static dev_t container_choose_spare(struct state *from, struct state *to,
 				dev = 0;
 				continue;
 			}
-			pol = devnum_policy(dev);
-			if (from->spare_group)
-				pol_add(&pol, pol_domain,
-					from->spare_group, NULL);
-			if (!domain_test(domlist, pol, to->metadata->ss->name))
-				dev = 0;
-			
-			dev_policy_free(pol);
+			if (from != to) {
+				struct dev_policy *pol
+					= devnum_policy(dev);
+				if (from->spare_group)
+					pol_add(&pol, pol_domain,
+						from->spare_group, NULL);
+				if (!domain_test(domlist, pol,
+						 to->metadata->ss->name))
+					dev = 0;
+				dev_policy_free(pol);
+			}
 		}
 	}
 	sysfs_free(disks);
@@ -880,12 +884,22 @@ static void try_spare_migration(struct state *statelist, struct alert_info *info
 			int d;
 			struct state *to = st;
 			unsigned long long min_size;
+			dev_t devid;
 			
 			if (to->parent)
 				/* member of a container */
 				to = to->parent;
 
 			min_size = min_spare_size_required(to);
+			if (to->metadata->ss->external) {
+				/* We must make sure there is
+				 * no suitable spare in container already.
+				 * If there is we don't add more */
+				devid = container_choose_spare(
+					to, to, NULL, min_size);
+				if (devid > 0)
+					continue;
+			}
 			for (d = 0; d < MaxDisks; d++)
 				if (to->devid[d])
 					domainlist_add_dev(&domlist,
@@ -895,7 +909,6 @@ static void try_spare_migration(struct state *statelist, struct alert_info *info
 				domain_add(&domlist, to->spare_group);
 
 			for (from=statelist ; from ; from=from->next) {
-				dev_t devid;
 				if (!check_donor(from, to, domlist))
 					continue;
 				if (from->metadata->ss->external)
-- 
1.7.1

