From: Xiao Ni <xni@redhat.com>
Subject: [PATCH 1/1] MDADM:Check mdinfo->reshape_active more times before calling Grow_continue
Date: Thu, 16 Jun 2016 09:41:02 +0800
Message-ID: <1466041262-12785-1-git-send-email-xni@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When reshaping a 3 drives raid5 to 4 drives raid5, there is a chance that
it can't start the reshape. If the disks are not enough to have spaces for
relocating the data_offset, it needs to call start_reshape and then run 
mdadm --grow --continue by systemd. But mdadm --grow --continue fails 
because it checkes that info->reshape_active is 0. 

The info->reshape_active is got from the superblock of underlying devices.
Function start_reshape write reshape to /sys/../sync_action. Before writing
latest superblock to underlying devices, mdadm --grow --continue is called.
There is a chance info->reshape_active is 0. We should wait for superblock
updating more time before calling Grow_continue.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 Grow.c | 67 ++++++++++++++++++++++++++++++++++++------------------------------
 1 file changed, 37 insertions(+), 30 deletions(-)

diff --git a/Grow.c b/Grow.c
index f184d9c..628f0e7 100755
--- a/Grow.c
+++ b/Grow.c
@@ -4788,6 +4788,7 @@ int Grow_continue_command(char *devname, int fd,
 	dprintf("Grow continue is run for ");
 	if (st->ss->external == 0) {
 		int d;
+		int cnt = 5;
 		dprintf_cont("native array (%s)\n", devname);
 		if (ioctl(fd, GET_ARRAY_INFO, &array.array) < 0) {
 			pr_err("%s is not an active md array - aborting\n", devname);
@@ -4799,36 +4800,42 @@ int Grow_continue_command(char *devname, int fd,
 		 * FIXME we should really get what we need from
 		 * sysfs
 		 */
-		for (d = 0; d < MAX_DISKS; d++) {
-			mdu_disk_info_t disk;
-			char *dv;
-			int err;
-			disk.number = d;
-			if (ioctl(fd, GET_DISK_INFO, &disk) < 0)
-				continue;
-			if (disk.major == 0 && disk.minor == 0)
-				continue;
-			if ((disk.state & (1 << MD_DISK_ACTIVE)) == 0)
-				continue;
-			dv = map_dev(disk.major, disk.minor, 1);
-			if (!dv)
-				continue;
-			fd2 = dev_open(dv, O_RDONLY);
-			if (fd2 < 0)
-				continue;
-			err = st->ss->load_super(st, fd2, NULL);
-			close(fd2);
-			if (err)
-				continue;
-			break;
-		}
-		if (d == MAX_DISKS) {
-			pr_err("Unable to load metadata for %s\n",
-			       devname);
-			ret_val = 1;
-			goto Grow_continue_command_exit;
-		}
-		st->ss->getinfo_super(st, content, NULL);
+		do {
+			for (d = 0; d < MAX_DISKS; d++) {
+				mdu_disk_info_t disk;
+				char *dv;
+				int err;
+				disk.number = d;
+				if (ioctl(fd, GET_DISK_INFO, &disk) < 0)
+					continue;
+				if (disk.major == 0 && disk.minor == 0)
+					continue;
+				if ((disk.state & (1 << MD_DISK_ACTIVE)) == 0)
+					continue;
+				dv = map_dev(disk.major, disk.minor, 1);
+				if (!dv)
+					continue;
+				fd2 = dev_open(dv, O_RDONLY);
+				if (fd2 < 0)
+					continue;
+				err = st->ss->load_super(st, fd2, NULL);
+				close(fd2);
+				if (err)
+					continue;
+				break;
+			}
+			if (d == MAX_DISKS) {
+				pr_err("Unable to load metadata for %s\n",
+				       devname);
+				ret_val = 1;
+				goto Grow_continue_command_exit;
+			}
+			st->ss->getinfo_super(st, content, NULL);
+			if (!content->reshape_active)
+				sleep(3);
+			else
+				break;
+		} while (cnt-- > 0);
 	} else {
 		char *container;
 
-- 
2.4.3

