From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 15/17] Monitor: more accurate size check when looking for
 spares
Date: Fri, 29 Oct 2010 15:26:13 +0100
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F010BAF0FD3@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Czarnowska, Anna" <anna.czarnowska@intel.com>
List-Id: linux-raid.ids

From 1e6de2b744115224be88da674e633c33934e5cb6 Mon Sep 17 00:00:00 2001
From: Anna Czarnowska <anna.czarnowska@intel.com>
Date: Wed, 27 Oct 2010 12:06:42 +0100
Subject: [PATCH 15/17] Monitor: more accurate size check when looking for spares

Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
---
 Monitor.c     |   23 ++++++++++++++++++++++-
 mdadm.h       |    1 +
 super-intel.c |   32 ++++++++++++++++++++++++++++++++
 3 files changed, 55 insertions(+), 1 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index aa2856e..efe36eb 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -766,6 +766,27 @@ unsigned long long min_active_disk_size_in_array(struct state *st)
 	return min;
 }
 
+unsigned long long min_spare_size_required(struct state *st,
+					   struct supertype *sty)
+{
+	int fd;
+	unsigned long long rv = 0;
+
+	if (!sty)
+		return rv;
+	if (sty->ss->min_acceptable_spare_size) {
+		fd = open(st->devname, O_RDONLY);
+		if (fd < 0)
+			return 0;
+		sty->ss->load_super(sty, fd, st->devname);
+		close(fd);
+		rv = sty->ss->min_acceptable_spare_size(sty);
+		sty->ss->free_super(sty);
+	} else
+		rv = min_active_disk_size_in_array(st);
+	return rv;
+}
+
 struct state *get_parent(struct state *st)
 {
 	if (is_external(st->metadata_version))
@@ -892,7 +913,7 @@ static void spare_sharing(struct state *statelist, char *mailaddr,
 			dprintf("no sra for device: %s\n", stp->devname);
 			continue;
 		}
-		min_size = min_active_disk_size_in_array(st);
+		min_size = min_spare_size_required(stp, super);
 		if (min_size == 0)
 			continue;
 		for (i = 0; i < stp->total; i++)
diff --git a/mdadm.h b/mdadm.h
index 4ef3ee5..7047fdf 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -605,6 +605,7 @@ extern struct superswitch {
 	int (*load_super)(struct supertype *st, int fd, char *devname);
 	struct supertype * (*match_metadata_desc)(char *arg);
 	__u64 (*avail_size)(struct supertype *st, __u64 size);
+	unsigned long long (*min_acceptable_spare_size)(struct supertype *st);
 	int (*add_internal_bitmap)(struct supertype *st, int *chunkp,
 				   int delay, int write_behind,
 				   unsigned long long size, int may_change, int major);
diff --git a/super-intel.c b/super-intel.c
index bcc202e..77c9d7f 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -646,6 +646,37 @@ static int is_failed(struct imsm_disk *disk)
 	return (disk->status & FAILED_DISK) == FAILED_DISK;
 }
 
+/* Return minimum size of a spare that can be used in this array*/
+static unsigned long long min_acceptable_spare_size_imsm(struct supertype *st)
+{
+	struct intel_super *super = st->sb;
+	struct dl *dl;
+	struct extent *e;
+	int i;
+	unsigned long long rv = 0;
+
+	if (!super)
+		return rv;
+	/* find first active disk in array */
+	dl = super->disks;
+	while (dl && (is_failed(&dl->disk) || dl->index == -1))
+		dl = dl->next;
+	if (!dl)
+		return rv;
+	/* find last lba used by subarrays */
+	e = get_extents(super, dl);
+	if (!e)
+		return rv;
+	for (i = 0; e[i].size; i++)
+		continue;
+	if (i > 0)
+		rv = e[i-1].start + e[i-1].size;
+	free(e);
+	/* add the amount of space needed for metadata */
+	rv = rv + MPB_SECTOR_CNT + IMSM_RESERVED_SECTORS;
+	return rv * 512;
+}
+
 #ifndef MDASSEMBLE
 static __u64 blocks_per_migr_unit(struct imsm_dev *dev);
 
@@ -5629,6 +5660,7 @@ struct superswitch super_imsm = {
 	.update_super	= update_super_imsm,
 
 	.avail_size	= avail_size_imsm,
+	.min_acceptable_spare_size = min_acceptable_spare_size_imsm,
 
 	.compare_super	= compare_super_imsm,
 
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

