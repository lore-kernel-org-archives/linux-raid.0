From: Jes.Sorensen@redhat.com
Subject: [PATCH 12/12] match_metadata_desc(): Fix memory leak
Date: Wed,  2 Nov 2011 15:42:17 +0100
Message-ID: <1320244937-9739-13-git-send-email-Jes.Sorensen@redhat.com>
References: <1320244937-9739-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1320244937-9739-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dledford@redhat.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 super-mbr.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/super-mbr.c b/super-mbr.c
index 5eefdf6..6499963 100644
--- a/super-mbr.c
+++ b/super-mbr.c
@@ -169,13 +169,14 @@ static void getinfo_mbr(struct supertype *st, struct mdinfo *info, char *map)
 
 static struct supertype *match_metadata_desc(char *arg)
 {
-	struct supertype *st = malloc(sizeof(*st));
+	struct supertype *st;
 
-	if (!st)
-		return st;
 	if (strcmp(arg, "mbr") != 0)
 		return NULL;
 
+	st = malloc(sizeof(*st));
+	if (!st)
+		return st;
 	st->ss = &mbr;
 	st->info = NULL;
 	st->minor_version = 0;
-- 
1.7.6.4

