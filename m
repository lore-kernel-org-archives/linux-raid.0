From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: [PATCH] md: wake up personality thread after array state update
Date: Tue, 25 Oct 2016 17:07:08 +0200
Message-ID: <1477408028-3694-1-git-send-email-tomasz.majchrzak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@kernel.org, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
List-Id: linux-raid.ids

When raid1/raid10 array fails to write to one of the drives, the request
is added to bio_end_io_list and finished by personality thread. The
thread doesn't handle it as long as MD_CHANGE_PENDING flag is set. In
case of external metadata this flag is cleared, however the thread is
not woken up. It causes request to be blocked for few seconds (until
another action on the array wakes up the thread) or to get stuck
indefinitely.

Wake up personality thread once MD_CHANGE_PENDING has been cleared.
Moving 'restart_array' call after the flag is cleared it not a solution
because in read-write mode the call doesn't wake up the thread.

Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
---
 drivers/md/md.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 5655f83..c17efaf 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3930,6 +3930,7 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
 		if (st == active) {
 			restart_array(mddev);
 			clear_bit(MD_CHANGE_PENDING, &mddev->flags);
+			md_wakeup_thread(mddev->thread);
 			wake_up(&mddev->sb_wait);
 			err = 0;
 		} else /* st == clean */ {
-- 
1.8.3.1

