From: Jes.Sorensen@redhat.com
Subject: [PATCH 2/3] conf_watch(): More dead code removal
Date: Mon, 31 Oct 2011 14:53:53 +0100
Message-ID: <1320069234-13112-3-git-send-email-Jes.Sorensen@redhat.com>
References: <1320069234-13112-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1320069234-13112-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dledford@redhat.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

verbose is always zero, hence anything checking for verbose > 0 will
always fail.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 config.c |   26 --------------------------
 1 files changed, 0 insertions(+), 26 deletions(-)

diff --git a/config.c b/config.c
index b57ba50..4e6165e 100644
--- a/config.c
+++ b/config.c
@@ -1022,57 +1022,31 @@ int conf_name_is_free(char *name)
 struct mddev_ident *conf_match(struct mdinfo *info, struct supertype *st)
 {
 	struct mddev_ident *array_list, *match;
-	int verbose = 0;
 	array_list = conf_get_ident(NULL);
 	match = NULL;
 	for (; array_list; array_list = array_list->next) {
 		if (array_list->uuid_set &&
 		    same_uuid(array_list->uuid, info->uuid, st->ss->swapuuid)
 		    == 0) {
-			if (verbose >= 2 && array_list->devname)
-				fprintf(stderr, Name
-					": UUID differs from %s.\n",
-					array_list->devname);
 			continue;
 		}
 		if (array_list->name[0] &&
 		    strcasecmp(array_list->name, info->name) != 0) {
-			if (verbose >= 2 && array_list->devname)
-				fprintf(stderr, Name
-					": Name differs from %s.\n",
-					array_list->devname);
 			continue;
 		}
 		if (array_list->super_minor != UnSet &&
 		    array_list->super_minor != info->array.md_minor) {
-			if (verbose >= 2 && array_list->devname)
-				fprintf(stderr, Name
-					": Different super-minor to %s.\n",
-					array_list->devname);
 			continue;
 		}
 		if (!array_list->uuid_set &&
 		    !array_list->name[0] &&
 		    !array_list->devices &&
 		    array_list->super_minor == UnSet) {
-			if (verbose >= 2 && array_list->devname)
-				fprintf(stderr, Name
-			     ": %s doesn't have any identifying information.\n",
-					array_list->devname);
 			continue;
 		}
 		/* FIXME, should I check raid_disks and level too?? */
 
 		if (match) {
-			if (verbose >= 0) {
-				if (match->devname && array_list->devname)
-					fprintf(stderr, Name
-		   ": we match both %s and %s - cannot decide which to use.\n",
-						match->devname, array_list->devname);
-				else
-					fprintf(stderr, Name
-						": multiple lines in mdadm.conf match\n");
-			}
 			return NULL;
 		}
 		match = array_list;
-- 
1.7.6.4

