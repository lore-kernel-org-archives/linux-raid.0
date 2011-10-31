From: Jes.Sorensen@redhat.com
Subject: [PATCH 3/3] Kill(): Remove redundant check and dead code
Date: Mon, 31 Oct 2011 14:53:54 +0100
Message-ID: <1320069234-13112-4-git-send-email-Jes.Sorensen@redhat.com>
References: <1320069234-13112-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1320069234-13112-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dledford@redhat.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

No need to check for (force && rv >=2) since we just set rv = 0 in
that case.

In addition remove dead code path that checks rv != 0 inside code that
is only run for rv == 0.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 Kill.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/Kill.c b/Kill.c
index b841a5b..01d884f 100644
--- a/Kill.c
+++ b/Kill.c
@@ -63,7 +63,7 @@ int Kill(char *dev, struct supertype *st, int force, int quiet, int noexcl)
 	rv = st->ss->load_super(st, fd, dev);
 	if (force && rv >= 2)
 		rv = 0; /* ignore bad data in superblock */
-	if (rv== 0 || (force && rv >= 2)) {
+	if (rv == 0) {
 		st->ss->free_super(st);
 		st->ss->init_super(st, NULL, 0, "", NULL, NULL);
 		if (st->ss->store_super(st, fd)) {
@@ -71,10 +71,6 @@ int Kill(char *dev, struct supertype *st, int force, int quiet, int noexcl)
 				fprintf(stderr, Name ": Could not zero superblock on %s\n",
 					dev);
 			rv = 1;
-		} else if (rv) {
-			if (!quiet)
-				fprintf(stderr, Name ": superblock zeroed anyway\n");
-			rv = 0;
 		}
 	}
 	close(fd);
-- 
1.7.6.4

