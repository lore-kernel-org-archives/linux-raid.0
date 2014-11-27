From: Pawel Baldysiak <pawel.baldysiak@intel.com>
Subject: [PATCH] Grow: Fix wrong 'goto' in set_new_data_offset
Date: Thu, 27 Nov 2014 12:35:24 +0100
Message-ID: <20141127113524.8874.37994.stgit@gklab-154-222.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, pawel.baldysiak@intel.com, artur.paszkiewicz@intel.com
List-Id: linux-raid.ids

Commit a821c95f114724b38df1ea99b2858178e0ed28ce
besides introducing additional message, also changed
direct return to "goto" instruction.
'goto release' will cause routine to return with '-1',
when previously '1' was returned.
Described behaviour breaks e.g. IMSM reshape process.
This patch fixes this issue by changing 'goto' to proper one -
the one that returns '1'.

Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
---
 Grow.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Grow.c b/Grow.c
index a0f7526..6ff225a 100644
--- a/Grow.c
+++ b/Grow.c
@@ -2257,7 +2257,7 @@ static int set_new_data_offset(struct mdinfo *sra, struct supertype *st,
 			/* Metadata doesn't support data_offset changes */
 			pr_err("%s: Metadata version doesn't support"
 			       " data_offset changes\n", devname);
-			goto release;
+			goto fallback;
 		}
 		if (before > info2.space_before)
 			before = info2.space_before;

