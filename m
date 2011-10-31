From: Jes.Sorensen@redhat.com
Subject: [PATCH 04/11] Fix memory leak of 'st3' in array_try_spare()
Date: Mon, 31 Oct 2011 15:02:32 +0100
Message-ID: <1320069759-13361-5-git-send-email-Jes.Sorensen@redhat.com>
References: <1320069759-13361-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1320069759-13361-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 Incremental.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/Incremental.c b/Incremental.c
index 98a3a74..7e345c5 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -956,8 +956,10 @@ static int array_try_spare(char *devname, int *dfdp, struct dev_policy *pol,
 			 * to obtain minimum spare size */
 			struct supertype *st3 = dup_super(st2);
 			int mdfd = open_dev(mp->devnum);
-			if (!mdfd)
+			if (!mdfd) {
+				free(st3);
 				goto next;
+			}
 			if (st3->ss->load_container &&
 			    !st3->ss->load_container(st3, mdfd, mp->path)) {
 				component_size = st3->ss->min_acceptable_spare_size(st3);
-- 
1.7.6.4

