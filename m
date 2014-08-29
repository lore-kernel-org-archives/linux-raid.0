From: Andy Smith <andy@strugglers.net>
Subject: [PATCH 1/1] Grow: Report when grow needs metadata update
Date: Fri, 29 Aug 2014 20:47:12 +0000
Message-ID: <1409345232-24837-1-git-send-email-andy@strugglers.net>
References: <20140824130939.461501b4@notabene.brown>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140824130939.461501b4@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, Andy Smith <andy@strugglers.net>
List-Id: linux-raid.ids

Report when the array's metadata needs updating instead of just
reporting the generic "kernel too old" message.

Signed-off-by: Andy Smith <andy@strugglers.net>
---
 Grow.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Grow.c b/Grow.c
index a9c8589..76bb35a 100644
--- a/Grow.c
+++ b/Grow.c
@@ -2255,7 +2255,9 @@ static int set_new_data_offset(struct mdinfo *sra, struct supertype *st,
 		if (info2.space_before == 0 &&
 		    info2.space_after == 0) {
 			/* Metadata doesn't support data_offset changes */
-			return 1;
+			pr_err("%s: Metadata version doesn't support"
+			       " data_offset changes\n", devname);
+			goto release;
 		}
 		if (before > info2.space_before)
 			before = info2.space_before;
-- 
1.7.10.4

