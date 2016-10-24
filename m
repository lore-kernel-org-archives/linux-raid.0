From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: [PATCH] md: report 'write_pending' state when array in sync
Date: Mon, 24 Oct 2016 12:47:28 +0200
Message-ID: <1477306048-26097-1-git-send-email-tomasz.majchrzak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@kernel.org, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
List-Id: linux-raid.ids

If there is a bad block on a disk and there is a recovery performed from
this disk, the same bad block is reported for a new disk. It involves
setting MD_CHANGE_PENDING flag in rdev_set_badblocks. For external
metadata this flag is not being cleared as array state is reported as
'clean'. The read request to bad block in RAID5 array gets stuck as it
is waiting for a flag to be cleared - as per commit c3cce6cda162
("md/raid5: ensure device failure recorded before write request
returns.").

The meaning of MD_CHANGE_PENDING and MD_CHANGE_CLEAN flags has been
clarified in commit 070dc6dd7103 ("md: resolve confusion of
MD_CHANGE_CLEAN"), however MD_CHANGE_PENDING flag has been used in
personality error handlers since and it doesn't fully comply with
initial purpose. It was supposed to notify that write request is about
to start, however now it is also used to request metadata update.
Initially (in md_allow_write, md_write_start) MD_CHANGE_PENDING flag has
been set and in_sync has been set to 0 at the same time. Error handlers
just set the flag without modifying in_sync value. Sysfs array state is
a single value so now it reports 'clean' when MD_CHANGE_PENDING flag is
set and in_sync is set to 1. Userspace has no idea it is expected to
take some action.

Swap the order that array state is checked so 'write_pending' is
reported ahead of 'clean' ('write_pending' is a misleading name but it
is too late to rename it now).

Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
---
 drivers/md/md.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 457b538..48f25d8 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3887,10 +3887,10 @@ array_state_show(struct mddev *mddev, char *page)
 			st = read_auto;
 			break;
 		case 0:
-			if (mddev->in_sync)
-				st = clean;
-			else if (test_bit(MD_CHANGE_PENDING, &mddev->flags))
+			if (test_bit(MD_CHANGE_PENDING, &mddev->flags))
 				st = write_pending;
+			else if (mddev->in_sync)
+				st = clean;
 			else if (mddev->safemode)
 				st = active_idle;
 			else
-- 
1.8.3.1

