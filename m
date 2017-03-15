From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 13/15] md: close a race with setting mddev->in_sync
Date: Wed, 15 Mar 2017 14:05:14 +1100
Message-ID: <148954711432.18641.11781301568617651177.stgit@noble>
References: <148954692173.18641.1294690639716682540.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <148954692173.18641.1294690639716682540.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, hch@lst.de
List-Id: linux-raid.ids

If ->in_sync is being set just as md_write_start() is being called,
it is possible that set_in_sync() won't see the elevated
->writes_pending, and md_write_start() won't see the set ->in_sync.

To close this race, re-test ->writes_pending after setting ->in_sync,
and add memory barriers to ensure the increment of ->writes_pending
will be seen by the time of this second test, or the new ->in_sync
will be seen by md_write_start().

Add a spinlock to array_state_show() to ensure this temporary
instability is never visible from userspace.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/md.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 2fa8048894e6..c33ec97b23d4 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2258,6 +2258,10 @@ static bool set_in_sync(struct mddev *mddev)
 	if (atomic_read(&mddev->writes_pending) == 0) {
 		if (mddev->in_sync == 0) {
 			mddev->in_sync = 1;
+			smp_mb();
+			if (atomic_read(&mddev->writes_pending))
+				/* lost a race with md_write_start() */
+				mddev->in_sync = 0;
 			set_bit(MD_SB_CHANGE_CLEAN, &mddev->sb_flags);
 			sysfs_notify_dirent_safe(mddev->sysfs_state);
 		}
@@ -4011,6 +4015,7 @@ array_state_show(struct mddev *mddev, char *page)
 			st = read_auto;
 			break;
 		case 0:
+			spin_lock(&mddev->lock);
 			if (test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags))
 				st = write_pending;
 			else if (mddev->in_sync)
@@ -4019,6 +4024,7 @@ array_state_show(struct mddev *mddev, char *page)
 				st = active_idle;
 			else
 				st = active;
+			spin_unlock(&mddev->lock);
 		}
 	else {
 		if (list_empty(&mddev->disks) &&
@@ -7894,6 +7900,7 @@ void md_write_start(struct mddev *mddev, struct bio *bi)
 		did_change = 1;
 	}
 	atomic_inc(&mddev->writes_pending);
+	smp_mb(); /* Match smp_mb in set_in_sync() */
 	if (mddev->safemode == 1)
 		mddev->safemode = 0;
 	if (mddev->in_sync) {


