From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: enhancements to the raid1 driver
Date: Fri, 14 Feb 2003 20:24:43 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E4D96DB.7AC5954B@SteelEye.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------D4B977DB66104A5A1B8AB22F"
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
Cc: jejb@SteelEye.com, neilb@cse.unsw.edu.au
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------D4B977DB66104A5A1B8AB22F
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hi,

I'm just beginning a project to add some new features to the raid1
driver. The planned features include:

intent log - a disk-backed bitmap to allow for quick resyncs (Peter T.
Breuer's fr1 code looks very promising)

asynchronous replication - to get acceptable performance when the backup
leg of the raid1 mirror is slow (e.g., nbd over a LAN or WAN)


I'm pretty familiar with the md and raid1 code and I've gotten far
enough along in planning to realize that I think the right approach for
making these additions to raid1 is to try, at least, not to be invasive
to the md driver itself. The existing framework of these drivers mostly
allows for that, but the one thing that would be very helpful is an
md_ioctl passthrough. By this I mean that an additional ioctl method
could be defined in the lower level raid drivers. This ioctl would be
called whenever an unrecognizable ioctl command is sent to the md
driver. It's a very simple addition (only a handful of lines). In fact,
I have already tested a patch (against 2.4.20) to do this (attached).

So, I'm wondering if the various kernel and driver maintainers would be
willing to integrate such a patch, in order to allow for work to
continue in the raid1 driver without impacting the md code, with the
ultimate goal of getting all of the raid1 changes (if the maintainers
are willing) into the mainline kernel? 

And, of course, if you have any other ideas or feedback, I'd like to
hear those, too.

Thanks,
Paul
--------------D4B977DB66104A5A1B8AB22F
Content-Type: text/plain; charset=us-ascii;
 name="md_ioctl_passthrough_2_4_20.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="md_ioctl_passthrough_2_4_20.diff"

--- include/linux/raid/md_k.h.ORIG	2003-01-10 13:14:35.000000000 -0500
+++ include/linux/raid/md_k.h	2003-01-10 13:17:26.000000000 -0500
@@ -241,6 +241,8 @@
 	int (*stop_resync)(mddev_t *mddev);
 	int (*restart_resync)(mddev_t *mddev);
 	int (*sync_request)(mddev_t *mddev, unsigned long block_nr);
+	int (*ioctl)(struct inode *inode, struct file *file, unsigned int cmd, 
+			unsigned long arg);
 };
 
 
--- drivers/md/md.c.ORIG	2003-01-10 13:05:06.000000000 -0500
+++ drivers/md/md.c	2003-01-10 13:10:01.000000000 -0500
@@ -2860,6 +2860,12 @@
 		}
 
 		default:
+			/* callout to lower level raid driver ioctl method */
+			if (mddev->pers->ioctl) {
+				err = mddev->pers->ioctl(inode, file, cmd, arg);
+				goto done_unlock;
+			}
+
 			printk(KERN_WARNING "md: %s(pid %d) used obsolete MD ioctl, "
 			       "upgrade your software to use new ictls.\n",
 			       current->comm, current->pid);

--------------D4B977DB66104A5A1B8AB22F--

