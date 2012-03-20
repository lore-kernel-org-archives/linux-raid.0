From: Jes.Sorensen@redhat.com
Subject: [PATCH 04/11] match_metadata_desc1(): Use calloc instead of malloc+memset
Date: Tue, 20 Mar 2012 17:54:09 +0100
Message-ID: <1332262456-5109-5-git-send-email-Jes.Sorensen@redhat.com>
References: <1332262456-5109-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1332262456-5109-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 super1.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/super1.c b/super1.c
index 1f0c8bc..ca9e4e4 100644
--- a/super1.c
+++ b/super1.c
@@ -1401,10 +1401,10 @@ static int load_super1(struct supertype *st, int fd, char *devname)
 
 static struct supertype *match_metadata_desc1(char *arg)
 {
-	struct supertype *st = malloc(sizeof(*st));
-	if (!st) return st;
+	struct supertype *st = calloc(1, sizeof(*st));
+	if (!st)
+		return st;
 
-	memset(st, 0, sizeof(*st));
 	st->container_dev = NoMdDev;
 	st->ss = &super1;
 	st->max_devs = 384;
-- 
1.7.7.6

