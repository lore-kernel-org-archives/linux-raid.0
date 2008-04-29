From: NeilBrown <neilb@suse.de>
Subject: [PATCH 001 of 9] md: Fix use after free when removing rdev via sysfs
Date: Tue, 29 Apr 2008 13:34:47 +1000
Message-ID: <1080429033447.20313@suse.de>
References: <20080429133104.20146.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, stable@kernel.org
List-Id: linux-raid.ids


From: Dan Williams <dan.j.williams@intel.com>

rdev->mddev is no longer valid upon return from entry->store() when the
'remove' command is given.

This should go in 2.6.25.stable.

Cc: stable@kernel.org
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2008-04-29 12:27:50.000000000 +1000
+++ ./drivers/md/md.c	2008-04-29 12:27:55.000000000 +1000
@@ -2096,7 +2096,7 @@ rdev_attr_store(struct kobject *kobj, st
 			rv = -EBUSY;
 		else
 			rv = entry->store(rdev, page, length);
-		mddev_unlock(rdev->mddev);
+		mddev_unlock(mddev);
 	}
 	return rv;
 }
