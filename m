From: Doug Ledford <dledford@redhat.com>
Subject: [Patch mdadm-3.2.2] Fix readding of a readwrite drive into a writemostly
 array
Date: Wed, 27 Jul 2011 14:34:37 -0400
Message-ID: <4E305A3D.9000001@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020000040007040005000708"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------020000040007040005000708
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

If you create a two drive raid1 array with one device writemostly, then 
fail the readwrite drive, when you add a new device, it will get the 
writemostly bit copied out of the remaining device's superblock into 
it's own.  You can then remove the new drive and readd it as readwrite, 
which will work for the readd, but it leaves the stale WriteMostly1 bit 
in devflags resulting in the device going back to writemostly on the 
next assembly.

The fix is to make sure that A) when we readd a device and we might have 
filled the st->sb info from a running device instead of the device being 
readded, then clear/set the WriteMostly1 bit in the super1 struct in 
addition to setting the disk state (ditto for super0, but slightly 
different mechanism) and B) when adding a clean device to an array (when 
we most certainly did copy the superblock info from an existing device), 
then clear any writemostly bits.

Signed-off-by: Doug Ledford <dledford@redhat.com>

--------------020000040007040005000708
Content-Type: text/plain;
 name="mdadm-3.2.2-writemostly.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="mdadm-3.2.2-writemostly.patch"

diff -up mdadm-3.2.2/Manage.c.writemostly mdadm-3.2.2/Manage.c
--- mdadm-3.2.2/Manage.c.writemostly	2011-06-13 22:50:01.000000000 -0400
+++ mdadm-3.2.2/Manage.c	2011-07-27 14:12:18.629889841 -0400
@@ -741,11 +741,24 @@ int Manage_subdevs(char *devname, int fd
 						remove_partitions(tfd);
 						close(tfd);
 						tfd = -1;
-						if (update) {
+						if (update || dv->writemostly > 0) {
 							int rv = -1;
 							tfd = dev_open(dv->devname, O_RDWR);
+							if (tfd < 0) {
+								fprintf(stderr, Name ": failed to open %s for"
+									" superblock update during re-add\n", dv->devname);
+								return 1;
+							}
 
-							if (tfd >= 0)
+							if (dv->writemostly == 1)
+								rv = st->ss->update_super(
+									st, NULL, "writemostly",
+									devname, verbose, 0, NULL);
+							if (dv->writemostly == 2)
+								rv = st->ss->update_super(
+									st, NULL, "readwrite",
+									devname, verbose, 0, NULL);
+							if (update)
 								rv = st->ss->update_super(
 									st, NULL, update,
 									devname, verbose, 0, NULL);
diff -up mdadm-3.2.2/mdadm.h.writemostly mdadm-3.2.2/mdadm.h
--- mdadm-3.2.2/mdadm.h.writemostly	2011-07-27 14:12:28.800779575 -0400
+++ mdadm-3.2.2/mdadm.h	2011-07-27 14:04:34.669932148 -0400
@@ -646,6 +646,8 @@ extern struct superswitch {
 	 *   linear-grow-new - add a new device to a linear array, but don't
 	 *                   change the size: so superblock still matches
 	 *   linear-grow-update - now change the size of the array.
+	 *   writemostly - set the WriteMostly1 bit in the superblock devflags
+	 *   readwrite - clear the WriteMostly1 bit in the superblock devflags
 	 */
 	int (*update_super)(struct supertype *st, struct mdinfo *info,
 			    char *update,
diff -up mdadm-3.2.2/super0.c.writemostly mdadm-3.2.2/super0.c
--- mdadm-3.2.2/super0.c.writemostly	2011-06-17 01:15:50.000000000 -0400
+++ mdadm-3.2.2/super0.c	2011-07-27 14:12:18.655889559 -0400
@@ -570,6 +570,10 @@ static int update_super0(struct supertyp
 		sb->state &= ~(1<<MD_SB_BITMAP_PRESENT);
 	} else if (strcmp(update, "_reshape_progress")==0)
 		sb->reshape_position = info->reshape_progress;
+	else if (strcmp(update, "writemostly")==0)
+		sb->state |= (1<<MD_DISK_WRITEMOSTLY);
+	else if (strcmp(update, "readwrite")==0)
+		sb->state &= ~(1<<MD_DISK_WRITEMOSTLY);
 	else
 		rv = -1;
 
@@ -688,6 +692,8 @@ static int add_to_super0(struct supertyp
 	dk->minor = dinfo->minor;
 	dk->raid_disk = dinfo->raid_disk;
 	dk->state = dinfo->state;
+	/* In case our source disk was writemostly, don't copy that bit */
+	dk->state &= ~(1<<MD_DISK_WRITEMOSTLY);
 
 	sb->this_disk = sb->disks[dinfo->number];
 	sb->sb_csum = calc_sb0_csum(sb);
diff -up mdadm-3.2.2/super1.c.writemostly mdadm-3.2.2/super1.c
--- mdadm-3.2.2/super1.c.writemostly	2011-06-17 01:15:50.000000000 -0400
+++ mdadm-3.2.2/super1.c	2011-07-27 14:12:18.656889548 -0400
@@ -803,6 +803,10 @@ static int update_super1(struct supertyp
 		       __le64_to_cpu(sb->data_size));
 	} else if (strcmp(update, "_reshape_progress")==0)
 		sb->reshape_position = __cpu_to_le64(info->reshape_progress);
+	else if (strcmp(update, "writemostly")==0)
+		sb->devflags |= WriteMostly1;
+	else if (strcmp(update, "readwrite")==0)
+		sb->devflags &= ~WriteMostly1;
 	else
 		rv = -1;
 
@@ -923,6 +927,7 @@ static int add_to_super1(struct supertyp
 		sb->max_dev = __cpu_to_le32(dk->number+1);
 
 	sb->dev_number = __cpu_to_le32(dk->number);
+	sb->devflags = 0; /* don't copy another disks flags */
 	sb->sb_csum = calc_sb_1_csum(sb);
 
 	dip = (struct devinfo **)&st->info;

--------------020000040007040005000708--
