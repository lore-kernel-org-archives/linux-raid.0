From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 01/16] md: refine interpretation of "hold_active ==
 UNTIL_IOCTL".
Date: Wed, 26 Oct 2011 12:43:00 +1100
Message-ID: <20111026014300.21110.77494.stgit@notabene.brown>
References: <20111026014240.21110.28487.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111026014240.21110.28487.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

We like md devices to disappear when they really are not needed.
However it is not possible to tell from the current state whether it
is needed or not.  We can only tell from recent history of changes.

In particular immediately after we create an md device it looks very
similar to immediately after we have finished with it.

So we always preserve a newly created md device until something
significant happens.  This state is stored in 'hold_active'.

The normal case is to keep it until an ioctl happens, as that will
normally either activate it, or explicitly de-activate it.  If it
doesn't then it was probably created by mistake and it is now time to
get rid of it.

We can also modify an array via sysfs (instead of via ioctl) and we
currently treat any change via sysfs like an ioctl as a sign that if
it now isn't more active, it should be destroyed.
However this is not appropriate as changes made via sysfs are more
gradual so we should look for a more definitive change.

So this patch only clears 'hold_active' from UNTIL_IOCTL to clear when
the array_state is changed via sysfs.  Other changes via sysfs
are ignored.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/md.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 266e82e..fd68243 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3791,6 +3791,8 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
 	if (err)
 		return err;
 	else {
+		if (mddev->hold_active == UNTIL_IOCTL)
+			mddev->hold_active = 0;
 		sysfs_notify_dirent_safe(mddev->sysfs_state);
 		return len;
 	}
@@ -4511,8 +4513,6 @@ md_attr_store(struct kobject *kobj, struct attribute *attr,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 	rv = mddev_lock(mddev);
-	if (mddev->hold_active == UNTIL_IOCTL)
-		mddev->hold_active = 0;
 	if (!rv) {
 		rv = entry->store(mddev, page, length);
 		mddev_unlock(mddev);


