From: Jes.Sorensen@redhat.com
Subject: [PATCH 05/12] array_try_spare(): open_dev() returns -1 on error, not zero
Date: Wed,  2 Nov 2011 15:42:10 +0100
Message-ID: <1320244937-9739-6-git-send-email-Jes.Sorensen@redhat.com>
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
 Incremental.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Incremental.c b/Incremental.c
index c2c9051..d3724a4 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -884,7 +884,7 @@ static int array_try_spare(char *devname, int *dfdp, struct dev_policy *pol,
 			 * to obtain minimum spare size */
 			struct supertype *st3 = dup_super(st2);
 			int mdfd = open_dev(mp->devnum);
-			if (!mdfd) {
+			if (mdfd < 0) {
 				free(st3);
 				goto next;
 			}
-- 
1.7.6.4

