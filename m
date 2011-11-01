From: Jes.Sorensen@redhat.com
Subject: [PATCH 07/19] Grow_restart(): free() offsets after use
Date: Tue,  1 Nov 2011 16:09:23 +0100
Message-ID: <1320160175-18976-8-git-send-email-Jes.Sorensen@redhat.com>
References: <1320160175-18976-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1320160175-18976-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dledford@redhat.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 Grow.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/Grow.c b/Grow.c
index 93a1fba..af61fc3 100644
--- a/Grow.c
+++ b/Grow.c
@@ -3578,6 +3578,7 @@ int Grow_restart(struct supertype *st, struct mdinfo *info, int *fdlist, int cnt
 			if (verbose)
 				fprintf(stderr, Name ": Error restoring backup from %s\n",
 					devname);
+			free(offsets);
 			return 1;
 		}
 		
@@ -3595,9 +3596,11 @@ int Grow_restart(struct supertype *st, struct mdinfo *info, int *fdlist, int cnt
 			if (verbose)
 				fprintf(stderr, Name ": Error restoring second backup from %s\n",
 					devname);
+			free(offsets);
 			return 1;
 		}
 
+		free(offsets);
 
 		/* Ok, so the data is restored. Let's update those superblocks. */
 
-- 
1.7.6.4

