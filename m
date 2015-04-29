From: heinzm@redhat.com
Subject: [PATCH v2 4/4] dm-raid: remove bogus parse_raid_params() comment about devices_handle_discards_safely
Date: Wed, 29 Apr 2015 14:03:49 +0200
Message-ID: <1430309029-24851-5-git-send-email-heinzm@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Heinz Mauelshagen <heinzm@redhat.com>
List-Id: linux-raid.ids

From: Heinz Mauelshagen <heinzm@redhat.com>

This patch removes a bogus comment on parse_raid_params() claiming
"devices_handle_discard_safely" being a table line argument when
it actually is a module parameter.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>

---
 drivers/md/dm-raid.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index c541d5a..97e1651 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -479,8 +479,6 @@ too_many:
  *                                      will form the "stripe"
  *    [[no]sync]			Force or prevent recovery of the
  *                                      entire array
- *    [devices_handle_discard_safely]	Allow discards on RAID4/5/6; useful if RAID
- *					member device(s) properly support TRIM/UNMAP
  *    [rebuild <idx>]			Rebuild the drive indicated by the index
  *    [daemon_sleep <ms>]		Time between bitmap daemon work to
  *                                      clear bits
-- 
2.1.0

