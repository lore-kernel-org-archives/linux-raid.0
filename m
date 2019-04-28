From: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH] md: properly lock and unlock in rdev_attr_store()
Date: Sun, 28 Apr 2019 12:40:41 +0200
Message-ID: <20190428104041.11262-1-lukas.bulwahn@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Neil Brown <neilb@suse.com>, Arnd Bergmann <arnd@arndb.de>, Himanshu Jha <himanshujha199639@gmail.com>
Cc: clang-built-linux@googlegroups.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Lukas Bulwahn <lukas.bulwahn@gmail.com>
List-Id: linux-raid.ids

rdev_attr_store() should lock and unlock mddev->reconfig_mutex in a
balanced way with mddev_lock() and mddev_unlock().

But when rdev->mddev is NULL, rdev_attr_store() would try to unlock
without locking before. Resolve this locking issue..

This locking issue was detected with Clang Thread Safety Analyser:

drivers/md/md.c:3393:3: warning: releasing mutex 'mddev->reconfig_mutex' that was not held [-Wthread-safety-analysis]
                mddev_unlock(mddev);
                ^

This warning was reported after annotating mutex functions and
mddev_lock() and mddev_unlock().

Fixes: 27c529bb8e90 ("md: lock access to rdev attributes properly")
Link: https://groups.google.com/d/topic/clang-built-linux/CvBiiQLB0H4/discussion
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---
Arnd, Neil, here a proposal to fix lock and unlocking asymmetry.

I quite sure that if mddev is NULL, it should just return.

I am still puzzled if the return value from mddev_lock() should be really
return by rdev_attr_store() when it is not 0. But that was the behaviour
before, so I will keep it that way.

 drivers/md/md.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 05ffffb8b769..a9735d8f1e70 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3384,7 +3384,9 @@ rdev_attr_store(struct kobject *kobj, struct attribute *attr,
 		return -EIO;
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
-	rv = mddev ? mddev_lock(mddev): -EBUSY;
+	if (!mddev)
+		return -EBUSY;
+	rv = mddev_lock(mddev);
 	if (!rv) {
 		if (rdev->mddev == NULL)
 			rv = -EBUSY;
-- 
2.17.1
