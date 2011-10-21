From: Jes.Sorensen@redhat.com
Subject: [PATCH 1/3] Remove race for starting container devices.
Date: Fri, 21 Oct 2011 15:33:18 +0200
Message-ID: <1319204000-6661-2-git-send-email-Jes.Sorensen@redhat.com>
References: <1319204000-6661-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1319204000-6661-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, lukasz.dorau@intel.com, adam.kwolek@intel.com, dledford@redhat.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This moves the lock handling out of Incremental_container() and relies
on the caller holding the lock. This prevents conflict with a
follow-on mdadm comment which may try and launch the device in
parallel.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 Incremental.c |   29 ++++++++++++++---------------
 1 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/Incremental.c b/Incremental.c
index b90089b..1a9a97b 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -139,10 +139,16 @@ int Incremental(char *devname, int verbose, int runstop,
 			rv = st->ss->load_container(st, dfd, NULL);
 
 		close(dfd);
-		if (!rv && st->ss->container_content)
-			return Incremental_container(st, devname, homehost,
-						     verbose, runstop, autof,
-						     freeze_reshape);
+		if (!rv && st->ss->container_content) {
+			if (map_lock(&map))
+				fprintf(stderr, Name ": failed to get "
+					"exclusive lock on mapfile\n");
+			rv = Incremental_container(st, devname, homehost,
+						   verbose, runstop, autof,
+						   freeze_reshape);
+			map_unlock(&map);
+			return rv;
+		}
 
 		fprintf(stderr, Name ": %s is not part of an md array.\n",
 			devname);
@@ -440,7 +446,6 @@ int Incremental(char *devname, int verbose, int runstop,
 	if (info.array.level == LEVEL_CONTAINER) {
 		int devnum = devnum; /* defined and used iff ->external */
 		/* Try to assemble within the container */
-		map_unlock(&map);
 		sysfs_uevent(&info, "change");
 		if (verbose >= 0)
 			fprintf(stderr, Name
@@ -451,9 +456,10 @@ int Incremental(char *devname, int verbose, int runstop,
 			devnum = fd2devnum(mdfd);
 		close(mdfd);
 		sysfs_free(sra);
-		rv = Incremental(chosen_name, verbose, runstop,
-				 NULL, homehost, require_homehost, autof,
-				 freeze_reshape);
+		rv = Incremental_container(st, chosen_name, homehost,
+					   verbose, runstop, autof,
+					   freeze_reshape);
+		map_unlock(&map);
 		if (rv == 1)
 			/* Don't fail the whole -I if a subarray didn't
 			 * have enough devices to start yet
@@ -1463,16 +1469,12 @@ static int Incremental_container(struct supertype *st, char *devname,
 		trustworthy = FOREIGN;
 
 	list = st->ss->container_content(st, NULL);
-	if (map_lock(&map))
-		fprintf(stderr, Name ": failed to get exclusive lock on "
-			"mapfile\n");
 	/* do not assemble arrays that might have bad blocks */
 	if (list && list->array.state & (1<<MD_SB_BBM_ERRORS)) {
 		fprintf(stderr, Name ": BBM log found in metadata. "
 					"Cannot activate array(s).\n");
 		/* free container data and exit */
 		sysfs_free(list);
-		map_unlock(&map);
 		return 2;
 	}
 
@@ -1536,7 +1538,6 @@ static int Incremental_container(struct supertype *st, char *devname,
 					fprintf(stderr, Name ": array %s/%s is "
 						"explicitly ignored by mdadm.conf\n",
 						match->container, match->member);
-				map_unlock(&map);
 				return 2;
 			}
 			if (match)
@@ -1552,7 +1553,6 @@ static int Incremental_container(struct supertype *st, char *devname,
 		if (mdfd < 0) {
 			fprintf(stderr, Name ": failed to open %s: %s.\n",
 				chosen_name, strerror(errno));
-			map_unlock(&map);
 			return 2;
 		}
 
@@ -1607,7 +1607,6 @@ static int Incremental_container(struct supertype *st, char *devname,
 			close(sfd);
 	}
 	domain_free(domains);
-	map_unlock(&map);
 	return 0;
 }
 
-- 
1.7.4.4

