From: Jes.Sorensen@redhat.com
Subject: [PATCH] GCC compile fix: remove calculation of unused variable 'reservation'
Date: Thu,  6 Oct 2011 16:43:51 +0200
Message-ID: <1317912231-26625-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

gcc 4.6.1 doesn't like calculating a variable that then isn't
used. Remove it.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 super-intel.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index ce067a2..33f23c9 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -989,7 +989,6 @@ static unsigned long long min_acceptable_spare_size_imsm(struct supertype *st)
 	struct extent *e;
 	int i;
 	unsigned long long rv = 0;
-	__u32 reservation;
 
 	if (!super)
 		return rv;
@@ -1007,7 +1006,6 @@ static unsigned long long min_acceptable_spare_size_imsm(struct supertype *st)
 		continue;
 	if (i > 0)
 		rv = e[i-1].start + e[i-1].size;
-	reservation = __le32_to_cpu(dl->disk.total_blocks) - e[i].start;
 	free(e);
 
 	/* add the amount of space needed for metadata */
-- 
1.7.6.4

