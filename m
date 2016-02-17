From: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
Subject: [PATCH] md: Drop sending a change uevent when stopping
Date: Wed, 17 Feb 2016 17:25:00 +0100
Message-ID: <1455726300-20340-1-git-send-email-sebastian.riemer@profitbricks.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
Cc: Sebastian Parschauer <sebastian.riemer@profitbricks.com>, Shaohua Li <shli@kernel.org>, Jes Sorensen <Jes.Sorensen@redhat.com>, Brassow Jonathan <jbrassow@redhat.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, NeilBrown <neilb@suse.com>, Hannes Reinecke <hare@suse.de>, systemd-devel@freedesktop.org
List-Id: linux-raid.ids

When stopping an MD device, then its device node /dev/mdX may still
exist afterwards or it is recreated by udev. The next open() call
can lead to creation of an inoperable MD device. The reason for
this is that a change event (KOBJ_CHANGE) is sent to udev which
races against the remove event (KOBJ_REMOVE) from md_free().
So drop sending the change event.

A change is likely also required in mdadm as many versions send the
change event to udev as well.

Signed-off-by: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
---
 drivers/md/md.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index e55e6cf..464627b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5671,7 +5671,6 @@ static int do_md_stop(struct mddev *mddev, int mode,
 		export_array(mddev);
 
 		md_clean(mddev);
-		kobject_uevent(&disk_to_dev(mddev->gendisk)->kobj, KOBJ_CHANGE);
 		if (mddev->hold_active == UNTIL_STOP)
 			mddev->hold_active = 0;
 	}
-- 
1.7.9.5

