From: Shaohua Li <shli@fb.com>
Subject: [PATCH 9/9] MD: when RAID journal is missing/faulty, block RESTART_ARRAY_RW
Date: Thu, 8 Oct 2015 21:54:13 -0700
Message-ID: <e06dd37994b6294d75a483a4fcc17542342ffc00.1444360850.git.shli@fb.com>
References: <cover.1444360850.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1444360850.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

From: Song Liu <songliubraving@fb.com>

When RAID-4/5/6 array suffers from missing journal device, we put
the array in read only state. We should not allow trasition to
read-write states (clean and active) before replacing journal device.

Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/md.c | 27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 59b38ef..c23d21b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3961,7 +3961,9 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
 		break;
 	case clean:
 		if (mddev->pers) {
-			restart_array(mddev);
+			err = restart_array(mddev);
+			if (err)
+				break;
 			spin_lock(&mddev->lock);
 			if (atomic_read(&mddev->writes_pending) == 0) {
 				if (mddev->in_sync == 0) {
@@ -3979,7 +3981,9 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
 		break;
 	case active:
 		if (mddev->pers) {
-			restart_array(mddev);
+			err = restart_array(mddev);
+			if (err)
+				break;
 			clear_bit(MD_CHANGE_PENDING, &mddev->flags);
 			wake_up(&mddev->sb_wait);
 			err = 0;
@@ -5336,6 +5340,25 @@ static int restart_array(struct mddev *mddev)
 		return -EINVAL;
 	if (!mddev->ro)
 		return -EBUSY;
+	if (test_bit(MD_HAS_JOURNAL, &mddev->flags)) {
+		struct md_rdev *rdev;
+		bool has_journal = false;
+
+		rcu_read_lock();
+		rdev_for_each_rcu(rdev, mddev) {
+			if (test_bit(Journal, &rdev->flags) &&
+			    !test_bit(Faulty, &rdev->flags)) {
+				has_journal = true;
+				break;
+			}
+		}
+		rcu_read_unlock();
+
+		/* Don't restart rw with journal missing/faulty */
+		if (!has_journal)
+			return -EINVAL;
+	}
+
 	mddev->safemode = 0;
 	mddev->ro = 0;
 	set_disk_ro(disk, 0);
-- 
2.4.6

