From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH] md:MD_CLOSING needs to be cleared after called md_set_readonly or do_md_stop
Date: Thu,  6 Apr 2017 11:16:33 +0800
Message-ID: <1491448593-12938-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: shli@fb.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>, NeilBrown <neilb@suse.com>
List-Id: linux-raid.ids

From: NeilBrown <neilb@suse.com>

if called md_set_readonly and set MD_CLOSING bit, the mddev cannot
be opened any more due to the MD_CLOING bit wasn't cleared. Thus it
needs to be cleared in md_ioctl after any call to md_set_readonly()
or do_md_stop().
Fixes: af8d8e6f0315 ("md: changes for MD_STILL_CLOSED flag")

Signed-off-by: NeilBrown <neilb@suse.com>
Signed-off-by: Zhilong Liu <zlliu@suse.com>
---

 drivers/md/md.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index f6ae1d6..906a4bf 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6776,6 +6776,7 @@ static int md_ioctl(struct block_device *bdev, fmode_t mode,
 	void __user *argp = (void __user *)arg;
 	struct mddev *mddev = NULL;
 	int ro;
+	bool did_set_md_closing = false;
 
 	if (!md_ioctl_valid(cmd))
 		return -ENOTTY;
@@ -6865,7 +6866,9 @@ static int md_ioctl(struct block_device *bdev, fmode_t mode,
 			err = -EBUSY;
 			goto out;
 		}
+		WARN_ON_ONCE(test_bit(MD_CLOSING, &mddev->flags));
 		set_bit(MD_CLOSING, &mddev->flags);
+		did_set_md_closing = true;
 		mutex_unlock(&mddev->open_mutex);
 		sync_blockdev(bdev);
 	}
@@ -7058,6 +7061,8 @@ static int md_ioctl(struct block_device *bdev, fmode_t mode,
 		mddev->hold_active = 0;
 	mddev_unlock(mddev);
 out:
+	if(did_set_md_closing)
+		clear_bit(MD_CLOSING, &mddev->flags);
 	return err;
 }
 #ifdef CONFIG_COMPAT
-- 
2.6.6

