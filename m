From: NeilBrown <neilb@suse.de>
Subject: [PATCH 009 of 12] md: Require CAP_SYS_ADMIN for (re-)configuring md devices via sysfs.
Date: Tue, 27 Jun 2006 17:05:54 +1000
Message-ID: <1060627070554.26058@suse.de>
References: <20060627170010.25835.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Chris Wright <chrisw@sous-sol.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids



The ioctl requires CAP_SYS_ADMIN, so sysfs should too.
Note that we don't require CAP_SYS_ADMIN for reading
attributes even though the ioctl does.  There is no reason
to limit the read access, and much of the information is
already available via /proc/mdstat

cc: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    4 ++++
 1 file changed, 4 insertions(+)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2006-06-27 12:17:33.000000000 +1000
+++ ./drivers/md/md.c	2006-06-27 12:17:33.000000000 +1000
@@ -1928,6 +1928,8 @@ rdev_attr_store(struct kobject *kobj, st
 
 	if (!entry->store)
 		return -EIO;
+	if (!capable(CAP_SYS_ADMIN))
+		return -EACCES;
 	return entry->store(rdev, page, length);
 }
 
@@ -2861,6 +2863,8 @@ md_attr_store(struct kobject *kobj, stru
 
 	if (!entry->store)
 		return -EIO;
+	if (!capable(CAP_SYS_ADMIN))
+		return -EACCES;
 	rv = mddev_lock(mddev);
 	if (!rv) {
 		rv = entry->store(mddev, page, length);
