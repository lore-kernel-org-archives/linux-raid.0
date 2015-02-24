From: Jes.Sorensen@redhat.com
Subject: [PATCH 4/5] IncrementalScan(): Make sure 'st' is valid before dereferencing it
Date: Tue, 24 Feb 2015 16:00:39 -0500
Message-ID: <1424811640-26569-5-git-send-email-Jes.Sorensen@redhat.com>
References: <1424811640-26569-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1424811640-26569-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: artur.paszkiewicz@intel.com, linux-raid@vger.kernel.org, Jes Sorensen <Jes.Sorensen@redhat.com>
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 Incremental.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Incremental.c b/Incremental.c
index 87d9114..33c0d7f 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -1354,7 +1354,7 @@ restart:
 			if (st && st->ss->load_container)
 				ret = st->ss->load_container(st, mdfd, NULL);
 			close(mdfd);
-			if (!ret && st->ss->container_content) {
+			if (!ret && st && st->ss->container_content) {
 				if (map_lock(&map))
 					pr_err("failed to get exclusive lock on mapfile\n");
 				ret = Incremental_container(st, me->path, c, only);
-- 
2.1.0

