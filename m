From: Jes.Sorensen@redhat.com
Subject: [PATCH 10/13] Handle malloc() failure in Grow.c
Date: Wed, 26 Oct 2011 17:30:23 +0200
Message-ID: <1319643026-11501-11-git-send-email-Jes.Sorensen@redhat.com>
References: <1319643026-11501-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1319643026-11501-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 Grow.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/Grow.c b/Grow.c
index 0e4dd10..eef95ed 100644
--- a/Grow.c
+++ b/Grow.c
@@ -3111,6 +3111,8 @@ static void validate(int afd, int bfd, unsigned long long offset)
 			abuflen = len;
 			abuf = malloc(abuflen);
 			bbuf = malloc(abuflen);
+			if (!abuf || !bbuf)
+				fail("out of memory");
 		}
 
 		lseek64(bfd, offset+__le64_to_cpu(bsb2.devstart2)*512, 0);
@@ -3501,6 +3503,11 @@ int Grow_restart(struct supertype *st, struct mdinfo *info, int *fdlist, int cnt
 
 		/* Now need the data offsets for all devices. */
 		offsets = malloc(sizeof(*offsets)*info->array.raid_disks);
+		if (!offsets) {
+			fprintf(stderr, Name ": %s unable to allocate memory\n",
+				__func__);
+			return -ENOMEM;
+		}
 		for(j=0; j<info->array.raid_disks; j++) {
 			if (fdlist[j] < 0)
 				continue;
-- 
1.7.6.4

