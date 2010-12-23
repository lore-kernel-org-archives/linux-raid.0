From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 2/3] Assemble imsm spares in matching domain only
Date: Thu, 23 Dec 2010 15:13:15 +0000
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F010E5CFBA0@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

From 9aa8c183c10c121d663bcf0f715cf9c17daa048d Mon Sep 17 00:00:00 2001
From: Anna Czarnowska <anna.czarnowska@intel.com>
Date: Thu, 23 Dec 2010 12:12:19 +0100
Subject: [PATCH 2/3] Assemble imsm spares in matching domain only
Cc: linux-raid@vger.kernel.org, Williams, Dan J <dan.j.williams@intel.com>, Ciechanowski, Ed <ed.ciechanowski@intel.com>

Imsm spare will only be taken if it matches domain of
identified members of currently assembled array.

This implies that:
- spare with null domain will match first array assembled.
- if array has null domain then no spare will match

If we allow spares to set st they may block assembly of subarrays.
This is because in autossembly tmpdev->used=0 for a spare not matching
any array. If we find such spare before container and set st, the content
will not get assembled.

We allow uuid_zero match any uuid in assembly as unsuitable spares will
be rejected on domain check.

Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
---
 Assemble.c |   44 +++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 41 insertions(+), 3 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index ac489e8..4b8ab5c 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -78,7 +78,8 @@ static int ident_matches(struct mddev_ident *ident,
 {
 
 	if (ident->uuid_set && (!update || strcmp(update, "uuid")!= 0) &&
-	    same_uuid(content->uuid, ident->uuid, tst->ss->swapuuid)==0) {
+	    same_uuid(content->uuid, ident->uuid, tst->ss->swapuuid)==0 &&
+	    memcmp(content->uuid, uuid_zero, sizeof(int[4]))) {
 		if (devname)
 			fprintf(stderr, Name ": %s has wrong uuid.\n",
 				devname);
@@ -231,7 +232,8 @@ int Assemble(struct supertype *st, char *mddev,
 	char *name = NULL;
 	int trustworthy;
 	char chosen_name[1024];
-
+	struct domainlist *domains = NULL;
+	
 	if (get_linux_version() < 2004000)
 		old_linux = 1;
 
@@ -350,6 +352,7 @@ int Assemble(struct supertype *st, char *mddev,
 			} else
 				found_container = 1;
 		} else {
+			pol = devnum_policy(stb.st_rdev);
 			if (!tst && (tst = guess_super(dfd)) == NULL) {
 				if (report_missmatch)
 					fprintf(stderr, Name ": no recogniseable superblock on %s\n",
@@ -366,7 +369,7 @@ int Assemble(struct supertype *st, char *mddev,
 						tst->ss->name, devname);
 				tmpdev->used = 2;
 			} else if (auto_assem && st == NULL &&
-				   !conf_test_metadata(tst->ss->name, (pol = devnum_policy(stb.st_rdev)),
+				   !conf_test_metadata(tst->ss->name, pol,
 						       tst->ss->match_home(tst, homehost) == 1)) {
 				if (report_missmatch)
 					fprintf(stderr, Name ": %s has metadata type %s for which "
@@ -392,6 +395,7 @@ int Assemble(struct supertype *st, char *mddev,
 			if (st)
 				st->ss->free_super(st);
 			dev_policy_free(pol);
+			domain_free(domains);
 			return 1;
 		}
 
@@ -459,6 +463,7 @@ int Assemble(struct supertype *st, char *mddev,
 					devname);
 				st->ss->free_super(st);
 				dev_policy_free(pol);
+				domain_free(domains);
 				return 1;
 			}
 			if (verbose > 0)
@@ -479,6 +484,12 @@ int Assemble(struct supertype *st, char *mddev,
 					   report_missmatch ? devname : NULL))
 				goto loop;
 
+			if (!memcmp(content->uuid, uuid_zero, sizeof(int[4]))) {
+				/* this is imsm_spare - do not set st */
+				tmpdev->used = 3;
+				goto loop;
+			}
+				
 			if (st == NULL)
 				st = dup_super(tst);
 			if (st->minor_version == -1)
@@ -522,17 +533,44 @@ int Assemble(struct supertype *st, char *mddev,
 				tst->ss->free_super(tst);
 				st->ss->free_super(st);
 				dev_policy_free(pol);
+				domain_free(domains);
 				return 1;
 			}
 			tmpdev->used = 1;
 		}
 	loop:
+		/* Collect domain information from members only */
+		if (tmpdev && tmpdev->used == 1)
+			domain_merge(&domains, pol, tst?tst->ss->name:NULL);
 		dev_policy_free(pol);
 		pol = NULL;
 		if (tst)
 			tst->ss->free_super(tst);
 	}
 
+	/* Now reject spares that don't match domains of identified members */
+	for (tmpdev = devlist; tmpdev; tmpdev = tmpdev->next) {
+		struct stat stb;
+		if (tmpdev->used != 3)
+			continue;
+		if (stat(tmpdev->devname, &stb)< 0) {
+			fprintf(stderr, Name ": fstat failed for %s: %s\n",
+				tmpdev->devname, strerror(errno));
+			tmpdev->used = 2;
+		} else {
+			struct dev_policy *pol = NULL;
+			pol = devnum_policy(stb.st_rdev);
+			if (domain_test(domains, pol, NULL))
+				/* take this spare if domains match */
+				tmpdev->used = 1;
+			else
+				/* if domains don't match mark as unused */
+				tmpdev->used = 0;
+			dev_policy_free(pol);
+		}
+	}
+	domain_free(domains);
+	
 	if (!st || !st->sb || !content)
 		return 2;
 
-- 
1.7.1

