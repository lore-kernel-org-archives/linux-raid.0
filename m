From: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
Subject: [PATCH 1/2] md: Inform udev about device removal when stopping
Date: Tue, 16 Feb 2016 15:44:36 +0100
Message-ID: <1455633877-4813-2-git-send-email-sebastian.riemer@profitbricks.com>
References: <1455633877-4813-1-git-send-email-sebastian.riemer@profitbricks.com>
Reply-To: linux-raid <linux-raid@vger.kernel.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1455633877-4813-1-git-send-email-sebastian.riemer@profitbricks.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
Cc: Sebastian Parschauer <sebastian.riemer@profitbricks.com>, Shaohua Li <shli@kernel.org>, Jes Sorensen <Jes.Sorensen@redhat.com>, Brassow Jonathan <jbrassow@redhat.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, NeilBrown <neilb@suse.com>, systemd-devel@freedesktop.org
List-Id: linux-raid.ids

When stopping an MD device, then its device node /dev/mdX may still
exist afterwards or it is recreated by udev. The next open() call
can lead to creation of an inoperable MD device. The reason for
this is that a change event (KOBJ_CHANGE) is announced to udev.
So announce a removal event (KOBJ_REMOVE) to udev instead.

A change is likely also required in mdadm because of the support
for kernels prior to 2.6.28.

Signed-off-by: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
---
 drivers/md/md.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index e55e6cf..ccae070 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5671,7 +5671,7 @@ static int do_md_stop(struct mddev *mddev, int mode,
 		export_array(mddev);
 
 		md_clean(mddev);
-		kobject_uevent(&disk_to_dev(mddev->gendisk)->kobj, KOBJ_CHANGE);
+		kobject_uevent(&disk_to_dev(mddev->gendisk)->kobj, KOBJ_REMOVE);
 		if (mddev->hold_active == UNTIL_STOP)
 			mddev->hold_active = 0;
 	}
-- 
1.7.9.5

