From: Jes.Sorensen@redhat.com
Subject: [PATCH 3/5] add_orom(): Compare content of struct imsm_orom rather than pointers to it
Date: Tue, 24 Feb 2015 16:00:38 -0500
Message-ID: <1424811640-26569-4-git-send-email-Jes.Sorensen@redhat.com>
References: <1424811640-26569-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1424811640-26569-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: artur.paszkiewicz@intel.com, linux-raid@vger.kernel.org, Jes Sorensen <Jes.Sorensen@redhat.com>
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This avoids adding the same orom entry to the oroms list multiple
times, as the comparison of pointers is never going to succeed, in
particular when '*orom' points to a local stack variable in the
calling function.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 platform-intel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/platform-intel.c b/platform-intel.c
index 37274da..a4ffa9f 100644
--- a/platform-intel.c
+++ b/platform-intel.c
@@ -255,8 +255,8 @@ static const struct imsm_orom *add_orom(const struct imsm_orom *orom)
 	int i;
 
 	for (i = 0; i < SYS_DEV_MAX; i++) {
-		if (&oroms[i].orom == orom)
-			return orom;
+		if (!memcmp(&oroms[i].orom, orom, sizeof(struct imsm_orom)))
+			return &oroms[i].orom;
 		if (oroms[i].orom.signature[0] == 0) {
 			oroms[i].orom = *orom;
 			return &oroms[i].orom;
-- 
2.1.0

