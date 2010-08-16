From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 26/35] Monitor: get array domain and subset function added
Date: Mon, 16 Aug 2010 10:59:38 +0100
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F0101E8FA0B@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Czarnowska, Anna" <anna.czarnowska@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-raid.ids

From c4eef57173368acd3bcb8196b92804b764f0a505 Mon Sep 17 00:00:00 2001
From: Anna Czarnowska <anna.czarnowska@intel.com>
Date: Fri, 23 Jul 2010 21:16:39 +0100
Subject: [PATCH 26/35] Monitor: get array domain and subset function added

Domain of all devices in an array is the same.
We can get array domain from any of it's devices.
Used for spare sharing.

Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
---
 Monitor.c |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 46 insertions(+), 0 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index 776cf54..a66a9ee 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -549,6 +549,52 @@ int Monitor(mddev_dev_t devlist,
 	return 0;
 }
 
+/* domain of an array is the domain of any of its members */
+int get_array_domain_and_subset(struct state *st,
+				struct domain_ent **domain,
+				struct subset **subset)
+{
+	struct supertype *sty;
+	char *devname;
+	int fd, i;
+
+	if (!st)
+		return 0;
+	for (i = 0; i < st->total && st->devid[i] == 0 ; i++);
+	if (i == st->total)
+		return 0;
+	devname = map_dev(major(st->devid[i]), minor(st->devid[i]), 1);
+	if (!devname)
+		return 0;
+	fd = open(devname, O_RDONLY);
+	if (fd < 0)
+		return 0;
+	sty = guess_super(fd);
+	if (!sty) {
+		close(fd);
+		return 0;
+	}
+	if (sty->ss->load_super(sty, fd, devname))
+		goto fail;
+	*domain = conf_get_domain(strrchr(devname, '/'), st->metadata_version);
+	if (*domain == NULL) {
+		*subset = NULL;
+		goto fail;
+	}
+	*subset = conf_get_subset(strrchr(devname, '/'), sty, *domain);
+	if (*subset == NULL)
+		goto fail;
+	sty->ss->free_super(sty);
+	free(sty);
+	return 1;
+fail:
+	if (fd >= 0)
+		close(fd);
+	sty->ss->free_super(sty);
+	free(sty);
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

