From: Paul Clements <paul.clements@steeleye.com>
Subject: [PATCH] mdadm 2.4: fix write mostly for add and re-add
Date: Fri, 31 Mar 2006 22:02:15 -0500
Message-ID: <442DED37.9030504@steeleye.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020105040307030804020306"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------020105040307030804020306
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

The following patch makes it possible to tag a device as write-mostly on 
--add and --re-add with a non-persistent superblock array. Previously, 
this was not working.

Thanks,
Paul

--------------020105040307030804020306
Content-Type: text/plain;
 name="mdadm-2.4-fix-write-mostly.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mdadm-2.4-fix-write-mostly.diff"


Signed-Off-By: Paul Clements <paul.clements@steeleye.com>

 Manage.c |    2 ++
 1 files changed, 2 insertions(+)
--- mdadm-2.4/Manage.c	2006-03-28 01:11:11.000000000 -0500
+++ mdadm-2.4-fix-write-mostly/Manage.c	2006-03-31 21:56:37.000000000 -0500
@@ -341,6 +341,8 @@ int Manage_subdevs(char *devname, int fd
 						break;
 					}
 			}
+			if (dv->writemostly)
+				disc.state |= (1 << MD_DISK_WRITEMOSTLY);
 			if (ioctl(fd,ADD_NEW_DISK, &disc)) {
 				fprintf(stderr, Name ": add new device failed for %s as %d: %s\n",
 					dv->devname, j, strerror(errno));

--------------020105040307030804020306--
