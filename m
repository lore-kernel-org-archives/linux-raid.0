From: Dan Williams <dan.j.williams@intel.com>
Subject: [RFC mdadm PATCH 05/11] Examine: support for coalescing "cache legs"
Date: Thu, 24 Apr 2014 00:22:45 -0700
Message-ID: <20140424072245.4515.46257.stgit@viggo.jf.intel.com>
References: <20140424071902.4515.19684.stgit@viggo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140424071902.4515.19684.stgit@viggo.jf.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, jes.sorensen@redhat.com, artur.paszkiewicz@intel.com, dave.jiang@intel.com
List-Id: linux-raid.ids

'isrt' volumes introduce a new category of a array.  They have
components that are subarrays from separate containers (likely thanks to
the constraint that all active members in an imsm container must be
members of all subarrays).  We want '-Eb' to identify the composite
volume uuid, but the default coalescing (by container) results in
duplicated output of the cache volume uuid.

Instead, introduce infrastructure to handle this directly.

1/ add ->cache_legs to struct mdinfo to indicate how many subarrays in a given
   container are components (legs) of a cache association.

2/ add ->cache_leg to struct supertype to indicate a cache leg to
   enumerate via ->getinfo_super()

3/ teach Examine to coalesce cache volumes across containers by uuid and
   dump their details via ->brief_examine_cache() extension to struct
   superswitch.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Examine.c |   92 +++++++++++++++++++++++++++++++++++++++++++++++++++++--------
 mdadm.h   |    3 ++
 2 files changed, 83 insertions(+), 12 deletions(-)

diff --git a/Examine.c b/Examine.c
index 953b8eee2360..945af8454a5f 100644
--- a/Examine.c
+++ b/Examine.c
@@ -30,6 +30,73 @@
 #endif
 #include	"md_u.h"
 #include	"md_p.h"
+
+struct array {
+	struct supertype *st;
+	struct mdinfo info;
+	void *devs;
+	struct array *next;
+	int spares;
+	int cache_leg;
+};
+
+static struct array *add_cache_legs(struct array *caches, struct supertype *st,
+				    struct mdinfo *info, struct array *arrays)
+{
+	struct mdinfo cache_info;
+	struct array *ap;
+	int i;
+
+	for (i = 1; i <= info->cache_legs; i++) {
+		/* in the case where the cache leg is assembled its uuid
+		 * may appear in the arrays list, so we need to check
+		 * both the caches list and the arrays list for
+		 * duplicates
+		 */
+		struct array *lists[] = { caches, arrays };
+		int j;
+
+		st->cache_leg = i;
+		st->ss->getinfo_super(st, &cache_info, NULL);
+		st->cache_leg = 0;
+		for (j = 0; j < 2; j++) {
+			for (ap = lists[j]; ap; ap = ap->next) {
+				if (st->ss == ap->st->ss
+				    && same_uuid(ap->info.uuid, cache_info.uuid,
+						 st->ss->swapuuid))
+					break;
+			}
+			if (ap)
+				break;
+		}
+		if (!ap) {
+			ap = xcalloc(1, sizeof(*ap));
+			ap->devs = dl_head();
+			ap->next = caches;
+			ap->st = st;
+			ap->cache_leg = i;
+			caches = ap;
+			memcpy(&ap->info, &cache_info, sizeof(cache_info));
+		}
+	}
+
+	return caches;
+}
+
+static void free_arrays(struct array *arrays)
+{
+	struct array *ap;
+
+	while (arrays) {
+		ap = arrays;
+		arrays = ap->next;
+
+		ap->st->ss->free_super(ap->st);
+		free(ap);
+	}
+}
+
+
 int Examine(struct mddev_dev *devlist,
 	    struct context *c,
 	    struct supertype *forcest)
@@ -54,14 +121,7 @@ int Examine(struct mddev_dev *devlist,
 	int fd;
 	int rv = 0;
 	int err = 0;
-
-	struct array {
-		struct supertype *st;
-		struct mdinfo info;
-		void *devs;
-		struct array *next;
-		int spares;
-	} *arrays = NULL;
+	struct array *arrays = NULL, *caches = NULL;
 
 	for (; devlist ; devlist = devlist->next) {
 		struct supertype *st;
@@ -131,13 +191,14 @@ int Examine(struct mddev_dev *devlist,
 					break;
 			}
 			if (!ap) {
-				ap = xmalloc(sizeof(*ap));
+				ap = xcalloc(1, sizeof(*ap));
 				ap->devs = dl_head();
 				ap->next = arrays;
-				ap->spares = 0;
 				ap->st = st;
 				arrays = ap;
 				st->ss->getinfo_super(st, &ap->info, NULL);
+				caches = add_cache_legs(caches, st, &ap->info,
+							arrays);
 			} else
 				st->ss->getinfo_super(st, &ap->info, NULL);
 			if (!have_container &&
@@ -179,11 +240,18 @@ int Examine(struct mddev_dev *devlist,
 					printf("\n");
 				ap->st->ss->brief_examine_subarrays(ap->st, c->verbose);
 			}
-			ap->st->ss->free_super(ap->st);
-			/* FIXME free ap */
 			if (ap->spares || c->verbose > 0)
 				printf("\n");
 		}
+		/* list container caches after their parent containers
+		 * and subarrays
+		 */
+		for (ap = caches; ap; ap = ap->next)
+			if (ap->st->ss->brief_examine_cache)
+				ap->st->ss->brief_examine_cache(ap->st, ap->cache_leg);
+		free_arrays(arrays);
+		free_arrays(caches);
+
 	}
 	return rv;
 }
diff --git a/mdadm.h b/mdadm.h
index f6a614e19316..111f90f599af 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -233,6 +233,7 @@ struct mdinfo {
 	int container_enough; /* flag external handlers can set to
 			       * indicate that subarrays have not enough (-1),
 			       * enough to start (0), or all expected disks (1) */
+	int cache_legs; /* number of cross-container cache members in this 'array' */
 	char		sys_name[20];
 	struct mdinfo *devs;
 	struct mdinfo *next;
@@ -684,6 +685,7 @@ extern struct superswitch {
 	void (*examine_super)(struct supertype *st, char *homehost);
 	void (*brief_examine_super)(struct supertype *st, int verbose);
 	void (*brief_examine_subarrays)(struct supertype *st, int verbose);
+	void (*brief_examine_cache)(struct supertype *st, int cache);
 	void (*export_examine_super)(struct supertype *st);
 	int (*examine_badblocks)(struct supertype *st, int fd, char *devname);
 	int (*copy_metadata)(struct supertype *st, int from, int to);
@@ -1006,6 +1008,7 @@ struct supertype {
 				 Used when examining metadata to display content of disk
 				 when user has no hw/firmare compatible system.
 			      */
+	int cache_leg; /* hack to interrogate cache legs within containers */
 	struct metadata_update *updates;
 	struct metadata_update **update_tail;
 

