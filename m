From: NeilBrown <neilb@suse.de>
Subject: [PATCH md] Restore force switch of md array to readonly at reboot time.
Date: Tue,  5 Aug 2008 16:17:30 +1000
Message-ID: <1217917054-1725-3-git-send-email-neilb@suse.de>
References: <1217917054-1725-1-git-send-email-neilb@suse.de>
 <1217917054-1725-2-git-send-email-neilb@suse.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1217917054-1725-2-git-send-email-neilb@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

A recent patch allowed do_md_stop to know whether it was being called
via an ioctl or not, and thus where to allow for an extra open file
descriptor when checking if it is in use.
This broke then switch to readonly performed by the shutdown notifier,
which needs to work even when the array is still (apparently) active
(as md doesn't get told when the filesystem becomes readonly).

So restore this feature by pretending that there can be lots of
file descriptors open, but we still want do_md_stop to switch to
readonly.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/md.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 48afe4f..8d11cd1 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6237,7 +6237,11 @@ static int md_notify_reboot(struct notifier_block *this,
 
 		for_each_mddev(mddev, tmp)
 			if (mddev_trylock(mddev)) {
-				do_md_stop (mddev, 1, 0);
+				/* Force a switch to readonly even array
+				 * appears to still be in use.  Hence
+				 * the '100'.
+				 */
+				do_md_stop (mddev, 1, 100);
 				mddev_unlock(mddev);
 			}
 		/*
-- 
1.5.6.3

