From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH] badblocks: fix wrong return value when badblocks are disabled
Date: Tue,  5 Apr 2016 14:59:34 +0200
Message-ID: <1459861174-9238-1-git-send-email-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org, vishal.l.verma@intel.com, linux-raid@vger.kernel.org, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

The return value of md_set_badblocks() was inverted when the code was
taken out of md, but the case when badblocks are disabled was left
unchanged. This causes silent ignoring of I/O errors and other
unpredictable behavior on md arrays that do not support badblocks (any
array not using v1.x metadata).

Fixes: 9e0e252a048b ("badblocks: Add core badblock management code")
Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 block/badblocks.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/block/badblocks.c b/block/badblocks.c
index 7be53cb..252f24e 100644
--- a/block/badblocks.c
+++ b/block/badblocks.c
@@ -147,6 +147,7 @@ EXPORT_SYMBOL_GPL(badblocks_check);
  * Return:
  *  0: success
  *  1: failed to set badblocks (out of space)
+ *  -1: failed to set badblocks (badblocks are disabled)
  */
 int badblocks_set(struct badblocks *bb, sector_t s, int sectors,
 			int acknowledged)
@@ -158,7 +159,7 @@ int badblocks_set(struct badblocks *bb, sector_t s, int sectors,
 
 	if (bb->shift < 0)
 		/* badblocks are disabled */
-		return 0;
+		return -1;
 
 	if (bb->shift) {
 		/* round the start down, and the end up */
-- 
2.6.2

