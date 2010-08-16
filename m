From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 24/35] imsm: create mdinfo list of disks in a container from
 supertype
Date: Mon, 16 Aug 2010 10:58:26 +0100
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F0101E8FA02@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Czarnowska, Anna" <anna.czarnowska@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-raid.ids

From 815729fe80f1046a5ec8762cd4cb2507ab5526e7 Mon Sep 17 00:00:00 2001
From: Anna Czarnowska <anna.czarnowska@intel.com>
Date: Tue, 20 Jul 2010 16:56:44 +0200
Subject: [PATCH 24/35] imsm: create mdinfo list of disks in a container from supertype

If getinfo_super is called on a container supertype we only get information
on first disk. As a parameter it uses reference to preallocated
mdinfo structure. Amending getinfo_super to return full list of disks
would require ammending all previous calls and subsequently freeing memory
allocated for mdinfo list. As an alternative a new function
getinfo_super_disks is created to obtain information about all disks
in container. Existing function sysfs_free is used to free memory
allocated by getinfo_super_disks.

Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
---
 mdadm.h       |    2 +-
 super-intel.c |   39 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+), 1 deletions(-)

diff --git a/mdadm.h b/mdadm.h
index ffb4634..a6a8fc0 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -597,7 +597,7 @@ extern struct superswitch {
 	 *   The device the metadata was loaded from by load_super
 	 */
 	void (*getinfo_super)(struct supertype *st, struct mdinfo *info);
-
+	struct mdinfo *(*getinfo_super_disks)(struct supertype *st);
 	/* Check if the given metadata is flagged as belonging to "this"
 	 * host.  0 for 'no', 1 for 'yes', -1 for "Don't record homehost"
 	 */
diff --git a/super-intel.c b/super-intel.c
index 4dcc654..a31ed57 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1615,6 +1615,44 @@ static void getinfo_super_imsm(struct supertype *st, struct mdinfo *info)
 	}
 }
 
+/* allocates memory and fills disk in mdinfo structure
+ * for each disk in container
+ * returns number of created elements of mdinfo list
+ * this memory must be later freed by sysfs_free */
+struct mdinfo *getinfo_super_disks_imsm(struct supertype *st)
+{
+	struct mdinfo *info = NULL;
+	struct intel_super *super = st->sb;
+	struct imsm_disk *disk;
+	int count = 0;
+	struct dl *dl;
+	if (!st->loaded_container || !(dl = super->disks))
+		return NULL;
+	while (dl) {
+		struct mdinfo *tmp;
+		disk = &dl->disk;
+		tmp = malloc(sizeof(*tmp));
+		if (!tmp) {
+			fprintf(stderr, Name ": Failed to allocate memory.\n");
+			if (info)
+				sysfs_free(info);
+			return NULL;
+		}
+		tmp->devs = NULL;
+		tmp->disk.number = count++;
+		tmp->disk.major = dl->major;
+		tmp->disk.minor = dl->minor;
+		tmp->disk.state = is_configured(disk) ? (1 << MD_DISK_ACTIVE) : 0;
+		tmp->disk.state |= is_failed(disk) ? (1 << MD_DISK_FAULTY) : 0;
+		tmp->disk.state |= is_spare(disk) ? 0 : (1 << MD_DISK_SYNC);
+		tmp->disk.raid_disk = -1;
+		tmp->next = info;
+		info = tmp;
+		dl = dl->next;
+	}
+	return info;
+}
+
 static int update_super_imsm(struct supertype *st, struct mdinfo *info,
 			     char *update, char *devname, int verbose,
 			     int uuid_set, char *homehost)
@@ -5333,6 +5371,7 @@ struct superswitch super_imsm = {
 	.match_home	= match_home_imsm,
 	.uuid_from_super= uuid_from_super_imsm,
 	.getinfo_super  = getinfo_super_imsm,
+	.getinfo_super_disks = getinfo_super_disks_imsm,
 	.update_super	= update_super_imsm,
 
 	.avail_size	= avail_size_imsm,
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

