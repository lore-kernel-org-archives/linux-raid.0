From: Jes.Sorensen@redhat.com
Subject: [PATCH 1/3] conf_match(): Remove dead code
Date: Mon, 31 Oct 2011 14:53:52 +0100
Message-ID: <1320069234-13112-2-git-send-email-Jes.Sorensen@redhat.com>
References: <1320069234-13112-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1320069234-13112-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dledford@redhat.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

devname is always NULL, hence if () statement will always fail.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 config.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/config.c b/config.c
index c0a6baa..b57ba50 100644
--- a/config.c
+++ b/config.c
@@ -1023,7 +1023,6 @@ struct mddev_ident *conf_match(struct mdinfo *info, struct supertype *st)
 {
 	struct mddev_ident *array_list, *match;
 	int verbose = 0;
-	char *devname = NULL;
 	array_list = conf_get_ident(NULL);
 	match = NULL;
 	for (; array_list; array_list = array_list->next) {
@@ -1044,14 +1043,6 @@ struct mddev_ident *conf_match(struct mdinfo *info, struct supertype *st)
 					array_list->devname);
 			continue;
 		}
-		if (array_list->devices && devname &&
-		    !match_oneof(array_list->devices, devname)) {
-			if (verbose >= 2 && array_list->devname)
-				fprintf(stderr, Name
-					": Not a listed device for %s.\n",
-					array_list->devname);
-			continue;
-		}
 		if (array_list->super_minor != UnSet &&
 		    array_list->super_minor != info->array.md_minor) {
 			if (verbose >= 2 && array_list->devname)
-- 
1.7.6.4

