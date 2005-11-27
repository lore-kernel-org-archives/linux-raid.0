From: Neil Brown <neilb@suse.de>
Subject: Re: Booting from raid1 -- md: invalid raid superblock magic on sdb1
Date: Mon, 28 Nov 2005 09:00:44 +1100
Message-ID: <17290.11404.619425.81197@cse.unsw.edu.au>
References: <050501c5f2a4$fe72c560$200a11ac@NCNF5131FTH>
	<054001c5f2bc$642a62c0$200a11ac@NCNF5131FTH>
	<055901c5f30c$282ad520$200a11ac@NCNF5131FTH>
	<058201c5f386$bf23d150$200a11ac@NCNF5131FTH>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from David M. Strang on Sunday November 27
Sender: linux-raid-owner@vger.kernel.org
To: "David M. Strang" <dstrang@shellpower.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday November 27, dstrang@shellpower.net wrote:
> 
> Just a quick update; I've been putting forth some due diligence on this --  
> and it appears basically, that do_mounts_md.c is an antique. I've added a 
> small debug line to md.c under md_import_device; and then also traced thru 
> the do_mounts_md.c code; and basically the crux of the situation is 
> do_mounts_md.c doesn't evaluate the superblock of the device and set 
> SET_ARRAY_INFO for persistent superblocks. So, everything defaults to the 
> legacy superblock type. (Superblock v0.90.x)

Yes, do_mounts_md assumes v0.90. 
The following patch will allow you to specify the version in the
kernel parameters, something like
   md=d0,v1.0,/dev/sda,/dev/sdb

(though I haven't tested it).
However I'm not at all convinced that I want to go down this path.

It is not at all hard to create an initramfs which runs mdadm to do
the right thing.  With mdadm-2.2 (to be released soonish), it will be
even easier.
e.g. you just need mdassemble, busybox, and a script called init
similar to:
  #!/bin/sh
  mkdir /proc; mount -t proc proc /proc
  if [ -n "$rootuuid" ]
  then arg=--uuid=$rootuuid
  else arg=--super-minor=0
  fi
  mdassemble -cpartitions $a --auto=part /dev/mda
  mount /dev/mda1 /root
  umount /proc
  cd /root
  rm -rf /bin
  mount --move . /
  chroot . /sbin/init

and with a more-recent busybox, the last few lines become just
"swap_root /root" (or something like that).
As it stands, this will not work with mdadm-2.1 as /dev won't have
names for all the devices in /proc/partitions.  mdadm-2.2 will remove
that necessity, though you can also add
{ read a ; read a;
  while read maj min b name
  do mknod /dev/$name b $maj $min
  done
} < /proc/partitions

if you want to try it now.
(For more complete instructions:
  Create a directory.
  In that directory create a directory 'bin' containing statically
  linked 'busybox' as 'sh' and 'mdassemble' as 'mdassemble'.
  In that directory also put the above script called 'init'.
  Make sure all files and directories are executable.
  run
    cpio -o -H newc . | gzip --best > ../init.cpio.gz
  Tell your boot loader (e.g. lilo or grub) that the init.cpio.gz file
  should be used as an initrd.
  Optionally add (append) a kernel parameter 
    rootuuid=UUID:OFYO:URRO:OOT:ARRA:Y :-)
)

In general I would rather steer away from do_mounts_md.c assembling
root md arrays, and steer towards using mdadm in an initramfs.  That
doesn't mean that I won't submit the following patch into a future
kernel, but it does mean that I might not....

NeilBrown


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./init/do_mounts_md.c |   26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff ./init/do_mounts_md.c~current~ ./init/do_mounts_md.c
--- ./init/do_mounts_md.c~current~	2005-11-28 08:09:13.000000000 +1100
+++ ./init/do_mounts_md.c	2005-11-28 08:40:19.000000000 +1100
@@ -19,6 +19,7 @@ static struct {
 	int partitioned;
 	int pers;
 	int chunk;
+	int vers_major, vers_minor;
 	char *device_names;
 } md_setup_args[MAX_MD_DEVS] __initdata;
 
@@ -78,6 +79,10 @@ static int __init md_setup(char *str)
 	}
 	if (ent >= md_setup_ents)
 		md_setup_ents++;
+
+	md_setup_args[ent].vers_major = 0;
+	md_setup_args[ent].vers_minor = 90;
+
 	switch (get_option(&str, &level)) {	/* RAID Personality */
 	case 2: /* could be 0 or -1.. */
 		if (level == 0 || level == LEVEL_LINEAR) {
@@ -100,7 +105,19 @@ static int __init md_setup(char *str)
 		}
 		/* FALL THROUGH */
 	case 1: /* the first device is numeric */
-		str = str1;
+		if (str[0]=='v' && str[1] == '0')
+			;
+		else if (str[0]=='v' && str[1] == '1') {
+			md_setup_args[ent].vers_major = 1;
+			md_setup_args[ent].vers_minor = 0;
+			if (str[2]=='.' && str[3] == '0')
+				md_setup_args[ent].vers_minor = 0;
+			if (str[2]=='.' && str[3] == '1')
+				md_setup_args[ent].vers_minor = 1;
+			if (str[2]=='.' && str[3] == '2')
+				md_setup_args[ent].vers_minor = 2;
+		} else
+			str = str1;
 		/* FALL THROUGH */
 	case 0:
 		md_setup_args[ent].pers = 0;
@@ -130,6 +147,7 @@ static void __init md_setup_drive(void)
 		char *devname;
 		mdu_disk_info_t dinfo;
 		char name[16], devfs_name[16];
+		mdu_array_info_t ainfo;
 
 		minor = md_setup_args[ent].minor;
 		partitioned = md_setup_args[ent].partitioned;
@@ -182,7 +200,10 @@ static void __init md_setup_drive(void)
 					"array %s\n", name);
 			continue;
 		}
-		if (sys_ioctl(fd, SET_ARRAY_INFO, 0) == -EBUSY) {
+		ainfo.raid_disks = 0; /* flag just setting version */
+		ainfo.major_version = md_setup_args[ent].vers_major;
+		ainfo.minor_version = md_setup_args[ent].vers_minor;
+		if (sys_ioctl(fd, SET_ARRAY_INFO, (long)&ainfo) == -EBUSY) {
 			printk(KERN_WARNING
 			       "md: Ignoring md=%d, already autodetected. (Use raid=noautodetect)\n",
 			       minor);
@@ -192,7 +213,6 @@ static void __init md_setup_drive(void)
 
 		if (md_setup_args[ent].pers) {
 			/* non-persistent */
-			mdu_array_info_t ainfo;
 			ainfo.level = pers_to_level(md_setup_args[ent].pers);
 			ainfo.size = 0;
 			ainfo.nr_disks =0;
