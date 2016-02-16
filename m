From: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
Subject: [PATCH 2/2] Manage: Inform udev about device removal when stopping
Date: Tue, 16 Feb 2016 15:44:37 +0100
Message-ID: <1455633877-4813-3-git-send-email-sebastian.riemer@profitbricks.com>
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

This also overrides the change event sent by the kernel.

Signed-off-by: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
---
 Manage.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Manage.c b/Manage.c
index 7e1b94b..bc89764 100644
--- a/Manage.c
+++ b/Manage.c
@@ -494,13 +494,13 @@ done:
 		goto out;
 	}
 	/* prior to 2.6.28, KOBJ_CHANGE was not sent when an md array
-	 * was stopped, so We'll do it here just to be sure.  Drop any
-	 * partitions as well...
+	 * was stopped, it should be KOBJ_REMOVE instead, so we set the
+	 * remove event here just to be sure. Drop any partitions as well...
 	 */
 	if (fd >= 0)
 		ioctl(fd, BLKRRPART, 0);
 	if (mdi)
-		sysfs_uevent(mdi, "change");
+		sysfs_uevent(mdi, "remove");
 
 	if (devnm[0] && use_udev()) {
 		struct map_ent *mp = map_by_devnm(&map, devnm);
-- 
1.7.9.5

