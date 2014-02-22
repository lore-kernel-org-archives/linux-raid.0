From: Eivind Sarto <eivindsarto@gmail.com>
Subject: mdadm may fail to assemble clean raid5 array with failed drive
Date: Fri, 21 Feb 2014 16:37:44 -0800
Message-ID: <3DBAA975-51CC-45A4-B39A-DAB8CE1A5B9D@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Content-Type: multipart/mixed; boundary="Apple-Mail=_4014BFF1-3BBE-42B5-8CF3-91098C2BFBCB"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids


--Apple-Mail=_4014BFF1-3BBE-42B5-8CF3-91098C2BFBCB
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

Mdadm may incorrecty fail to assemble a clean raid5 array if the array
had a failed drive with a dirty superblock at the time the array was
last stopped.
While assembling, mdadm will use the superblock of the failed drive
during assembly, if the failed drive is probed first.  If the failed =
drive's superblock
is active/dirty, mdadm may think that the entire array is dirty-degraded
instead of clean-degraded.  Mdadm will then not try and run the array =
unless=20
a --force is specified.

This patch ensures that mdadm will always use the most recent superblock
before making desicions about running the array.

This bug appears in all recent version of mdadm.

-eivind=

--Apple-Mail=_4014BFF1-3BBE-42B5-8CF3-91098C2BFBCB
Content-Disposition: attachment;
	filename=mdadm.patch
Content-Type: application/octet-stream;
	x-unix-mode=0644;
	name="mdadm.patch"
Content-Transfer-Encoding: 7bit

From: Eivind Sarto <eivindsarto@gmail.com>
Date: Fri Feb 21 16:22:16 PST 2014
Subject: mdadm may fail to assemble clean raid5 array with failed drive

Mdadm may incorrecty fail to assemble a clean raid5 array if the array
had a failed drive with a dirty superblock at the time the array was
last stopped.
While assembling, mdadm will use the superblock of the failed drive
during assembly if the failed drive is probed first.  If that superblock
is active/dirty, mdadm may think that the entire array is dirty-degraded
instead of clean-degraded.  Mdadm will not try and run the array unless
a --force is specified. 
This patch ensures that mdadm will always use the most recent superblock
before making desicions about running the array.


--- mdadm-3.2.6.orig/Assemble.c	2014-02-18 13:28:01.375896429 -0800
+++ mdadm-3.2.6.new/Assemble.c	2014-02-21 13:16:12.934499736 -0800
@@ -849,8 +849,23 @@ int Assemble(struct supertype *st, char
 		devices[devcnt].i.disk.minor = minor(stb.st_rdev);
 		if (most_recent < devcnt) {
 			if (devices[devcnt].i.events
-			    > devices[most_recent].i.events)
+			    > devices[most_recent].i.events) {
+				/* load the most recent superblock */
+				int dfd;
+				dfd = dev_open(devname, O_RDWR|O_EXCL);
+
+				if (dfd < 0 || st->ss->load_super(st, dfd, NULL) != 0) {
+					fprintf(stderr, Name ": cannot re-read metadata from %s - aborting\n", devname);
+					if (dfd >= 0)
+						close(dfd);
+					close(mdfd);
+					free(devices);
+					free(devmap);
+					return 1;
+				}
+				close(dfd);
 				most_recent = devcnt;
+			}
 		}
 		if (content->array.level == LEVEL_MULTIPATH)
 			/* with multipath, the raid_disk from the superblock is meaningless */

--Apple-Mail=_4014BFF1-3BBE-42B5-8CF3-91098C2BFBCB--
