From: Andreas Haumer <andreas@xss.co.at>
Subject: Newer mdadm breaks our initial ramdisk init scripts
Date: Thu, 07 Dec 2006 22:13:53 +0100
Message-ID: <45788411.7030802@xss.co.at>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060600060506070701050809"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------060600060506070701050809
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi Neil!

I know you're going to hate me on this (please don't! ;-)...

We are using mdadm in our initial ramdisk on a lot of machines.
These systems all run LVM on top of Software RAID, which all
get's assembled together in an initial ramdisk init script.

These systems also still use linux-2.4 and all use devfs.

As many of these systems have several RAID arrays we put a
special mdadm config file into the initial ramdisk to give
mdadm a hint which devices to assemble when booting.
This configfile is usually created with the command
"mdadm -Ebsc partitions" and then put into the initrd image
by a special "mkinitrd" command I wrote.

Now, with an older mdadm (at least up to 2.3.1) this config
file usually looked like this (example):

DEVICE partitions
ARRAY /dev/md/1 level=raid1 num-devices=4 UUID=cb4f2758:b254eab8:0bea3939:892d1cb6
ARRAY /dev/md/0 level=raid5 num-devices=4 UUID=37803f71:ed6fb87d:77ec22d5:0f28e873


With a newer mdadm (tested with 2.5.6) it looks like this:

DEVICE partitions
ARRAY /dev/md1 level=raid1 num-devices=4 UUID=cb4f2758:b254eab8:0bea3939:892d1cb6
ARRAY /dev/md0 level=raid5 num-devices=4 UUID=37803f71:ed6fb87d:77ec22d5:0f28e873

Note that the md device files look different: the newer mdadm
does not follow the devfs syntax anymore.

When I use the config file created by the newer mdadm in an
initial ramdisk, the boot process fails as now mdadm does
not find the md device files as listed in the config file
(the real device files are created by devfs and so still are
called "/dev/md/0", "/dev/md/1", etc.)

We could hand-edit the mdadm config file after it was created
by the new mdadm to fix the device file name (before it is put
into the initrd image), but I *know* some of us will forget this
in at least 50% of all installations and then we'd have systems
not able to boot anymore - not nice if the machine is several
hundred kilometers away...

So I decided to revert the change in super0.c which is responsible
for the different device file format (in brief_examine_super0(),
see attached simple patch)
I really can understand why you do not want to use the get_md_name()
function here (it does way too much just for creating a device file
name string), but for us it's going to save lots of hours, I'm sure.

I also know that there are very few users of linux-2.4 and devfs
left, so this problem might be of minor importance for most people.
But if there is a little chance you can think of a better solution
for us old-fashioned devfs-users in the next mdadm release I'd be
thankfully happy!

Regards,

- - andreas

- --
Andreas Haumer                     | mailto:andreas@xss.co.at
*x Software + Systeme              | http://www.xss.co.at/
Karmarschgasse 51/2/20             | Tel: +43-1-6060114-0
A-1100 Vienna, Austria             | Fax: +43-1-6060114-71
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFFeIQQxJmyeGcXPhERAvY/AJ9atEAQqQy/T5KcREZ2OZ3C8zvtaQCfSvbD
8Awyz0Wm6tpnzF3pLkXWnPI=
=kxrZ
-----END PGP SIGNATURE-----

--------------060600060506070701050809
Content-Type: text/x-patch;
 name="devfs_devname.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="devfs_devname.patch"

Index: mdadm/super0.c
===================================================================
RCS file: /home/cvs/repository/distribution/Utilities/mdadm/super0.c,v
retrieving revision 1.1.1.5
diff -u -r1.1.1.5 super0.c
--- mdadm/super0.c	9 Oct 2006 01:16:44 -0000	1.1.1.5
+++ mdadm/super0.c	7 Dec 2006 20:14:03 -0000
@@ -236,7 +236,7 @@
 	sprintf(devname, "/dev/md%d", sb->md_minor);
 
 	printf("ARRAY %s level=%s num-devices=%d UUID=",
-	       devname,
+	       get_md_name(sb->md_minor),
 	       c?c:"-unknown-", sb->raid_disks);
 	if (sb->minor_version >= 90)
 		printf("%08x:%08x:%08x:%08x", sb->set_uuid0, sb->set_uuid1,

--------------060600060506070701050809--
