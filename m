From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 25/35] Monitor: fill devstate of containers based on
 supertype
Date: Mon, 16 Aug 2010 10:58:49 +0100
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F0101E8FA07@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Czarnowska, Anna" <anna.czarnowska@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-raid.ids

From 4921d3d110d1bf4b70eabedf7aaabca06ef767e8 Mon Sep 17 00:00:00 2001
From: Anna Czarnowska <anna.czarnowska@intel.com>
Date: Tue, 20 Jul 2010 16:16:29 +0100
Subject: [PATCH 25/35] Monitor: fill devstate of containers based on supertype

Normally containers have no information in devstate. Volumes have states
of their members. To get state of all disks in container we use
load_super on container and create mdinfo list with all disk states.
We will use it later to find spares.

Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
---
 Monitor.c |   54 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index 91a8b69..776cf54 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -549,6 +549,60 @@ int Monitor(mddev_dev_t devlist,
 	return 0;
 }
 
+/* get states of all disks in each container from metadata*/
+int getinfo_containers(struct state *statelist)
+{
+	struct state *st;
+	struct supertype *sty;
+	int fd, id, i, rv = 1;
+	struct mdinfo *infolist = NULL, *info;
+	for (st = statelist; st; st = st->next) {
+		if (st->err || !is_external(st->metadata_version) ||
+		    is_subarray(st->metadata_version+9))
+			continue;
+		fd = open(st->devname, O_RDONLY);
+		if (fd < 0)
+			return 0;
+		sty = guess_super(fd);
+		if (!sty) {
+			close(fd);
+			return 0;
+		}
+		if (sty->ss->load_super(sty, fd, st->devname)) {
+			rv = 0;
+			goto cleanup;
+		}
+		infolist = sty->ss->getinfo_super_disks(sty);
+		if (!infolist) {
+			rv = 0;
+			goto cleanup;
+		}
+		for (i = 0; i<st->total; i++) {
+			if (st->devid[i] == 0)
+				continue;
+			for (info = infolist; info; info = info->next) {
+				id = makedev(info->disk.major, info->disk.minor);
+				if (st->devid[i] == id) {
+					st->devstate[i] = info->disk.state;
+					break;
+				}
+			}
+			if (!info)
+				st->devstate[i] = 1<<MD_DISK_FAULTY;
+		}
+cleanup:
+		close(fd);
+		sty->ss->free_super(sty);
+		free(sty);
+		if (infolist)
+			sysfs_free(infolist);
+		infolist = NULL;
+		if (!rv)
+			return 0;
+	}
+	return 1;
+}
+
 static void alert(char *event, char *dev, char *disc, char *mailaddr, char *mailfrom, char *cmd,
 		  int dosyslog)
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

