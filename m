From: NeilBrown <neilb@suse.de>
Subject: [PATCH 007 of 10] md: Allow rdev state to be set via sysfs.
Date: Thu, 1 Jun 2006 15:14:03 +1000
Message-ID: <1060601051403.27625@suse.de>
References: <20060601150955.27444.patches@notabene>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S964911AbWFAFOu@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


The md/dev-XXX/state file can now be written:

 "faulty" simulates an error on the device
 "remove" removes the device from the array (if it is not busy)

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./Documentation/md.txt |    3 +++
 ./drivers/md/md.c      |   26 +++++++++++++++++++++++++-
 2 files changed, 28 insertions(+), 1 deletion(-)

diff ./Documentation/md.txt~current~ ./Documentation/md.txt
--- ./Documentation/md.txt~current~	2006-06-01 15:05:29.000000000 +1000
+++ ./Documentation/md.txt	2006-06-01 15:05:29.000000000 +1000
@@ -302,6 +302,9 @@ Each directory contains:
 			 This includes spares that are in the process
 			 of being recoverred to
 	This list make grow in future.
+	This can be written to.
+	Writing "faulty"  simulates a failure on the device.
+	Writing "remove" removes the device from the array.
 
       errors
 	An approximate count of read errors that have been detected on

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2006-06-01 15:05:29.000000000 +1000
+++ ./drivers/md/md.c	2006-06-01 15:05:30.000000000 +1000
@@ -1745,8 +1745,32 @@ state_show(mdk_rdev_t *rdev, char *page)
 	return len+sprintf(page+len, "\n");
 }
 
+static ssize_t
+state_store(mdk_rdev_t *rdev, const char *buf, size_t len)
+{
+	/* can write
+	 *  faulty  - simulates and error
+	 *  remove  - disconnects the device
+	 */
+	int err = -EINVAL;
+	if (cmd_match(buf, "faulty") && rdev->mddev->pers) {
+		md_error(rdev->mddev, rdev);
+		err = 0;
+	} else if (cmd_match(buf, "remove")) {
+		if (rdev->raid_disk >= 0)
+			err = -EBUSY;
+		else {
+			mddev_t *mddev = rdev->mddev;
+			kick_rdev_from_array(rdev);
+			md_update_sb(mddev);
+			md_new_event(mddev);
+			err = 0;
+		}
+	}
+	return err ? err : len;
+}
 static struct rdev_sysfs_entry
-rdev_state = __ATTR_RO(state);
+rdev_state = __ATTR(state, 0644, state_show, state_store);
 
 static ssize_t
 super_show(mdk_rdev_t *rdev, char *page)
