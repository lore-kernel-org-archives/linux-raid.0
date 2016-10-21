From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: [PATCH 2/2 v3] md: don't fail an array if there are unacknowledged bad blocks
Date: Fri, 21 Oct 2016 16:27:08 +0200
Message-ID: <1477060028-8268-1-git-send-email-tomasz.majchrzak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@kernel.org, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
List-Id: linux-raid.ids

If external metadata handler supports bad blocks and unacknowledged bad
blocks are present, don't report disk via sysfs as faulty. Such
situation can be still handled so disk just has to be blocked for a
moment. It makes it consistent with kernel state as corresponding rdev
flag is also not set.

When the disk in being unblocked there are few cases:
1. Disk has been in blocked and faulty state, it is being unblocked but
it still remains in faulty state. Metadata handler will remove it from
array in the next call.
2. There is no bad block support in external metadata handler and bad
blocks are present - put the disk in blocked and faulty state (see
case 1).
3. There is bad block support in external metadata handler and all bad
blocks are acknowledged - clear all flags, continue.
4. There is bad block support in external metadata handler but there are
still unacknowledged bad blocks - clear all flags, continue. It is fine
to clear Blocked flag because it was probably not set anyway (if it was
it is case 1). BlockedBadBlocks flag can also be cleared because the
request waiting for it will set it again when it finds out that some bad
block is still not acknowledged. Recovery is not necessary but there are
no problems if the flag is set. Sysfs rdev state is still reported as
blocked (due to unacknowledged bad blocks) so metadata handler will
process remaining bad blocks and unblock disk again.

Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
---
 drivers/md/md.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index b661a45..734edb2 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2528,7 +2528,8 @@ state_show(struct md_rdev *rdev, char *page)
 	unsigned long flags = ACCESS_ONCE(rdev->flags);
 
 	if (test_bit(Faulty, &flags) ||
-	    rdev->badblocks.unacked_exist)
+	    (!test_bit(ExternalBbl, &flags) &&
+	    rdev->badblocks.unacked_exist))
 		len += sprintf(page+len, "faulty%s", sep);
 	if (test_bit(In_sync, &flags))
 		len += sprintf(page+len, "in_sync%s", sep);
@@ -2613,6 +2614,7 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
 		err = 0;
 	} else if (cmd_match(buf, "-blocked")) {
 		if (!test_bit(Faulty, &rdev->flags) &&
+		    !test_bit(ExternalBbl, &rdev->flags) &&
 		    rdev->badblocks.unacked_exist) {
 			/* metadata handler doesn't understand badblocks,
 			 * so we need to fail the device
-- 
1.8.3.1

