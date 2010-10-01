From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: [AUTOREBUILD 2/8] Monitor: removed spare-group based spare sharing
 code
Date: Fri, 1 Oct 2010 13:37:18 +0100
Message-ID: <905EDD02F158D948B186911EB64DB3D171D09954@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Czarnowska, Anna" <anna.czarnowska@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-raid.ids

From 11d6b7b32a695b50781367805e44588781580ad2 Mon Sep 17 00:00:00 2001
From: Anna Czarnowska <anna.czarnowska@intel.com>
Date: Tue, 28 Sep 2010 03:30:48 +0200
Subject: [AUTOREBUILD 2/8] Monitor: removed spare-group based spare sharing code
 This will conflict with spare sharing based on domains

Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
---
 Monitor.c |   72 -------------------------------------------------------------
 1 files changed, 0 insertions(+), 72 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index 51df8fb..82ccfb2 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -74,11 +74,6 @@ int Monitor(mddev_dev_t devlist,
 	 *    DeviceDisappeared
 	 *      Couldn't access a device which was previously visible
 	 *
-	 * if we detect an array with active<raid and spare==0
-	 * we look at other arrays that have same spare-group
-	 * If we find one with active==raid and spare>0,
-	 *  and if we can get_disk_info and find a name
-	 *  Then we hot-remove and hot-add to the other array
 	 *
 	 * If devlist is NULL, then we can monitor everything because --scan
 	 * was given.  We get an initial list from config file and add anything
@@ -90,7 +85,6 @@ int Monitor(mddev_dev_t devlist,
 		int devnum;	/* to sync with mdstat info */
 		long utime;
 		int err;
-		char *spare_group;
 		int active, working, failed, spare, raid;
 		int expected_spares;
 		int devstate[MaxDisks];
@@ -173,10 +167,6 @@ int Monitor(mddev_dev_t devlist,
 			st->devnum = INT_MAX;
 			st->percent = -2;
 			st->expected_spares = mdlist->spare_disks;
-			if (mdlist->spare_group)
-				st->spare_group = strdup(mdlist->spare_group);
-			else
-				st->spare_group = NULL;
 			statelist = st;
 		}
 	} else {
@@ -193,11 +183,8 @@ int Monitor(mddev_dev_t devlist,
 			st->devnum = INT_MAX;
 			st->percent = -2;
 			st->expected_spares = -1;
-			st->spare_group = NULL;
 			if (mdlist) {
 				st->expected_spares = mdlist->spare_disks;
-				if (mdlist->spare_group)
-					st->spare_group = strdup(mdlist->spare_group);
 			}
 			statelist = st;
 		}
@@ -439,7 +426,6 @@ int Monitor(mddev_dev_t devlist,
 					st->err = 1;
 					st->devnum = mse->devnum;
 					st->percent = -2;
-					st->spare_group = NULL;
 					st->expected_spares = -1;
 					statelist = st;
 					if (test)
@@ -448,64 +434,6 @@ int Monitor(mddev_dev_t devlist,
 					new_found = 1;
 				}
 		}
-		/* If an array has active < raid && spare == 0 && spare_group != NULL
-		 * Look for another array with spare > 0 and active == raid and same spare_group
-		 *  if found, choose a device and hotremove/hotadd
-		 */
-		for (st = statelist; st; st=st->next)
-			if (st->active < st->raid &&
-			    st->spare == 0 &&
-			    st->spare_group != NULL) {
-				struct state *st2;
-				for (st2=statelist ; st2 ; st2=st2->next)
-					if (st2 != st &&
-					    st2->spare > 0 &&
-					    st2->active == st2->raid &&
-					    st2->spare_group != NULL &&
-					    strcmp(st->spare_group, st2->spare_group) == 0) {
-						/* try to remove and add */
-						int fd1 = open(st->devname, O_RDONLY);
-						int fd2 = open(st2->devname, O_RDONLY);
-						int dev = -1;
-						int d;
-						if (fd1 < 0 || fd2 < 0) {
-							if (fd1>=0) close(fd1);
-							if (fd2>=0) close(fd2);
-							continue;
-						}
-						for (d=st2->raid; d < MaxDisks; d++) {
-							if (st2->devid[d] > 0 &&
-							    st2->devstate[d] == 0) {
-								dev = st2->devid[d];
-								break;
-							}
-						}
-						if (dev > 0) {
-							struct mddev_dev_s devlist;
-							char devname[20];
-							devlist.next = NULL;
-							devlist.used = 0;
-							devlist.re_add = 0;
-							devlist.writemostly = 0;
-							devlist.devname = devname;
-							sprintf(devname, "%d:%d", major(dev), minor(dev));
-
-							devlist.disposition = 'r';
-							if (Manage_subdevs(st2->devname, fd2, &devlist, -1, 0) == 0) {
-								devlist.disposition = 'a';
-								if (Manage_subdevs(st->devname, fd1, &devlist, -1, 0) == 0) {
-									alert("MoveSpare", st->devname, st2->devname, mailaddr, mailfrom, alert_cmd, dosyslog);
-									close(fd1);
-									close(fd2);
-									break;
-								}
-								else Manage_subdevs(st2->devname, fd2, &devlist, -1, 0);
-							}
-						}
-						close(fd1);
-						close(fd2);
-					}
-			}
 		if (!new_found) {
 			if (oneshot)
 				break;
-- 
1.6.4.2

