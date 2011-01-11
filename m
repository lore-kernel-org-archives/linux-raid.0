From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH] Monitor: skip array if error getting size
Date: Tue, 11 Jan 2011 13:09:55 +0000
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F010E87582C@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

From 10d178721c3870ea5802a30ea3f008f9f379551a Mon Sep 17 00:00:00 2001
From: Anna Czarnowska <anna.czarnowska@intel.com>
Date: Tue, 11 Jan 2011 12:36:37 +0100
Subject: [PATCH] Monitor: skip array if error getting size
Cc: linux-raid@vger.kernel.org, Williams, Dan J <dan.j.williams@intel.com>, Ciechanowski, Ed <ed.ciechanowski@intel.com>

load_super tries to load container first anyway but if it fails
eg. after physically removing a disk
then it tries to read metadata from container device.
This will always fail and print confusing errors.
So use load_container instead of load_super on container.

On failure to read metadata we should skip this array.
It will be dealt with the next time round.

Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
---
 Monitor.c |   21 +++++++++++++--------
 1 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index 18462f2..db4e8cc 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -702,24 +702,28 @@ static int add_new_arrays(struct mdstat_ent *mdstat, struct state **statelist,
 	return new_found;
 }
 
-unsigned long long min_spare_size_required(struct state *st)
+static int get_min_spare_size_required(struct state *st, unsigned long long *sizep)
 {
 	int fd;
-	unsigned long long rv = 0;
 
 	if (!st->metadata ||
 	    !st->metadata->ss->min_acceptable_spare_size)
-		return rv;
+		return 0;
 
 	fd = open(st->devname, O_RDONLY);
 	if (fd < 0)
-		return 0;
-	st->metadata->ss->load_super(st->metadata, fd, st->devname);
+		return 1;
+	if (st->metadata->ss->external)
+		st->metadata->ss->load_container(st->metadata, fd, st->devname);
+	else
+		st->metadata->ss->load_super(st->metadata, fd, st->devname);
 	close(fd);
-	rv = st->metadata->ss->min_acceptable_spare_size(st->metadata);
+	if (!st->metadata->sb)
+		return 1;
+	*sizep = st->metadata->ss->min_acceptable_spare_size(st->metadata);
 	st->metadata->ss->free_super(st->metadata);
 
-	return rv;
+	return 0;
 }
 
 static int check_donor(struct state *from, struct state *to)
@@ -833,7 +837,8 @@ static void try_spare_migration(struct state *statelist, struct alert_info *info
 				/* member of a container */
 				to = to->parent;
 
-			min_size = min_spare_size_required(to);
+			if (get_min_spare_size_required(to, &min_size))
+				continue;
 			if (to->metadata->ss->external) {
 				/* We must make sure there is
 				 * no suitable spare in container already.
-- 
1.7.1

