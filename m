From: Doug Ledford <dledford@redhat.com>
Subject: [Patch mdadm-3.2.2] Fix the fix for the readd bug
Date: Wed, 27 Jul 2011 14:30:35 -0400
Message-ID: <4E30594B.9030306@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060603020900020401090907"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------060603020900020401090907
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

The readd bug fix didn't work due to a faulty test.  We need to check 
raid_disks to get an upper bound of the found slots to check since 
nr_disks only counts good disks and we could have faulty or spares that 
aren't counted but amount to an occupied slot.

Signed-off-by: Doug Ledford <dledford@redhat.com>

--------------060603020900020401090907
Content-Type: text/plain;
 name="mdadm-3.2.2-readd.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="mdadm-3.2.2-readd.patch"

--- mdadm-3.2.2/util.c.readd	2011-06-17 01:15:50.000000000 -0400
+++ mdadm-3.2.2/util.c	2011-07-18 14:43:40.776150946 -0400
@@ -364,19 +364,21 @@ int enough_fd(int fd)
 	struct mdu_disk_info_s disk;
 	int avail_disks = 0;
 	int i;
+	int raid_disks;
 	char *avail;
 
 	if (ioctl(fd, GET_ARRAY_INFO, &array) != 0 ||
 	    array.raid_disks <= 0)
 		return 0;
 	avail = calloc(array.raid_disks, 1);
-	for (i=0; i < 1024 && array.nr_disks > 0; i++) {
+	raid_disks = array.raid_disks;
+	for (i=0; i < 1024 && raid_disks > 0; i++) {
 		disk.number = i;
 		if (ioctl(fd, GET_DISK_INFO, &disk) != 0)
 			continue;
 		if (disk.major == 0 && disk.minor == 0)
 			continue;
-		array.nr_disks--;
+		raid_disks--;
 
 		if (! (disk.state & (1<<MD_DISK_SYNC)))
 			continue;

--------------060603020900020401090907--
