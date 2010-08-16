From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 27/35] Monitor: added function move_spare
Date: Mon, 16 Aug 2010 11:00:01 +0100
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F0101E8FA0C@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Czarnowska, Anna" <anna.czarnowska@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-raid.ids

From 662b22b7f7309e7dc71c17bf5ec20d11a290d96c Mon Sep 17 00:00:00 2001
From: Anna Czarnowska <anna.czarnowska@intel.com>
Date: Fri, 23 Jul 2010 19:30:52 +0100
Subject: [PATCH 27/35] Monitor: added function move_spare

For spare sharing. We try to remove spare from one array/container and
add to another. If add fails we add back to original container.

Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
---
 Monitor.c |   56 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 56 insertions(+), 0 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index a66a9ee..6a203c3 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -595,6 +595,62 @@ fail:
 	return 0;
 }
 
+int move_spare(struct state *st2, struct state *st1, int i,
+		      char *mailaddr, char *mailfrom, char *alert_cmd, 
+		      int dosyslog)
+
+{
+	struct mddev_dev_s devlist;
+	char devname[20];
+	int from_fd, to_fd;
+	if (!st1 || !st2 || st2->devid[i] == 0)
+		return 0;
+	from_fd = open(st2->devname, O_RDONLY);
+	if (from_fd < 0)
+		return 0;
+	to_fd = open(st1->devname, O_RDONLY);
+	if (to_fd < 0) {
+		close(from_fd);
+		return 0;
+	}
+	devlist.next = NULL;
+	devlist.used = 0;
+	devlist.re_add = 0;
+	devlist.writemostly = 0;
+	devlist.devname = devname;
+	char *dv = map_dev(major(st2->devid[i]), minor(st2->devid[i]), 1);
+	if (!dv) {
+		close(from_fd);
+		close(to_fd);
+		return 0;
+	}
+	snprintf(devname, 20, "%s", dv);
+	devlist.disposition = 'r';
+	if (Manage_subdevs(st2->devname, from_fd, &devlist, -1) == 0) {
+		devlist.disposition = 'a';
+		if (Manage_subdevs(st1->devname, to_fd, &devlist,
+				   -1) == 0) {
+			st2->devid[i] = 0;
+			ping_manager(st2->devname);
+			ping_manager(st1->devname);
+			alert("MoveSpare", st1->devname, st2->devname,
+			      mailaddr, mailfrom, alert_cmd, dosyslog);
+			close(from_fd);
+			close(to_fd);
+			return 1;
+		} else if (Manage_subdevs(st2->devname, from_fd,
+					  &devlist, -1) != 0)
+			fprintf(stderr,
+				"Error: Adding back spare device"
+				"%s to container %s failed!\n",
+				st2->devname, dv);
+	}
+	/* Failed to add spare to new container */
+	close(from_fd);
+	close(to_fd);
+	return 0;
+}
+
 /* get states of all disks in each container from metadata*/
 int getinfo_containers(struct state *statelist)
 {
-- 
1.6.4.2

---------------------------------------------------------------------
Intel Technology Poland sp. z o.o.
z siedziba w Gdansku
ul. Slowackiego 173
80-298 Gdansk

Sad Rejonowy Gdansk Polnoc w Gdansku, 
VII Wydzial Gospodarczy Krajowego Rejestru Sadowego, 
numer KRS 101882

NIP 957-07-52-316
Kapital zakladowy 200.000 zl

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

