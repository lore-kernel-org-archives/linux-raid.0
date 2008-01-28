From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH] Use new sb type
Date: Mon, 28 Jan 2008 18:22:59 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801281818430.1185@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


This makes 1.0 the default sb type for new arrays.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 Create.c |    6 ------
 super0.c |    4 +---
 super1.c |    2 +-
 3 files changed, 2 insertions(+), 10 deletions(-)

Index: mdadm-2.6.4/Create.c
===================================================================
--- mdadm-2.6.4.orig/Create.c
+++ mdadm-2.6.4/Create.c
@@ -241,12 +241,6 @@ int Create(struct supertype *st, char *m
 				fprintf(stderr, Name ": internal error - no default metadata style\n");
 				exit(2);
 			}
-			if (st->ss->major != 0 ||
-			    st->minor_version != 90)
-				fprintf(stderr, Name ": Defaulting to version"
-					" %d.%d metadata\n",
-					st->ss->major,
-					st->minor_version);
 		}
 		freesize = st->ss->avail_size(st, ldsize >> 9);
 		if (freesize == 0) {
Index: mdadm-2.6.4/super0.c
===================================================================
--- mdadm-2.6.4.orig/super0.c
+++ mdadm-2.6.4/super0.c
@@ -820,9 +820,7 @@ static struct supertype *match_metadata_
 	st->minor_version = 90;
 	st->max_devs = MD_SB_DISKS;
 	if (strcmp(arg, "0") == 0 ||
-	    strcmp(arg, "0.90") == 0 ||
-	    strcmp(arg, "default") == 0
-		)
+	    strcmp(arg, "0.90") == 0)
 		return st;
 
 	st->minor_version = 9; /* flag for 'byte-swapped' */
Index: mdadm-2.6.4/super1.c
===================================================================
--- mdadm-2.6.4.orig/super1.c
+++ mdadm-2.6.4/super1.c
@@ -1143,7 +1143,7 @@ static struct supertype *match_metadata_
 
 	st->ss = &super1;
 	st->max_devs = 384;
-	if (strcmp(arg, "1.0") == 0) {
+	if (strcmp(arg, "1.0") == 0 || strcmp(arg, "default") == 0) {
 		st->minor_version = 0;
 		return st;
 	}

