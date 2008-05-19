From: NeilBrown <neilb@suse.de>
Subject: [PATCH 007 of 10] md: notify userspace on 'stop' events
Date: Mon, 19 May 2008 11:10:50 +1000
Message-ID: <1080519011050.7741@suse.de>
References: <20080519110910.7473.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids


From: Dan Williams <dan.j.williams@intel.com>

This additional notification to 'array_state' is needed to allow the monitor
application to learn about stop events via sysfs.  The
sysfs_notify("sync_action") call that comes at the end of do_md_stop() (via
md_new_event) is insufficient since the 'sync_action' attribute has been
removed by this point.

(Seems like a sysfs-notify-on-removal patch is a better fix.  Currently removal
 updates the event count but does not wake up waiters)

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    2 ++
 1 file changed, 2 insertions(+)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2008-05-19 11:03:43.000000000 +1000
+++ ./drivers/md/md.c	2008-05-19 11:03:47.000000000 +1000
@@ -3691,6 +3691,8 @@ static int do_md_stop(mddev_t * mddev, i
 
 			module_put(mddev->pers->owner);
 			mddev->pers = NULL;
+			/* tell userspace to handle 'inactive' */
+			sysfs_notify(&mddev->kobj, NULL, "array_state");
 
 			set_capacity(disk, 0);
 			mddev->changed = 1;
