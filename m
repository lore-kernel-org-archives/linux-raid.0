From: Carl-Daniel Hailfinger <c-d.hailfinger.kernel.2004@gmx.net>
Subject: Re: mdadm problems with partitioned md devices
Date: Wed, 24 Nov 2004 03:32:54 +0100
Message-ID: <41A3F2D6.20503@gmx.net>
References: <41A39846.9070002@gmx.net> <16803.50469.836305.127571@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060805090608050806000208"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16803.50469.836305.127571@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------060805090608050806000208
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Neil Brown wrote:
> On Tuesday November 23, Carl-Daniel Hailfinger wrote:
> 
>>Hi,
>>
>>[please CC: me]
>>while trying to use md to overcome limitations of dm, I
>>stumbled upon the following problem: It is impossible to
>>have more than 4 partitioned md devices since mdadm will
>>create the 5th device with major:minor 255:0, which is
>>bogus.
> 
> 
> You need user-space (libc in particular) that supports the new 32bit
> device numbers in 2.6.  I don't know which version of glibc that would
> be, or which distributions support it.  debian/unstable (which I use)
> doesn't support it yet :-(

Use SUSE. They support it even in older distributions like 9.1 which
is freely downloadable by now. At least the glibc-2.3.3 shipped with
SUSE 9.1 already supports a large dev_t.


> You could test your distribution with
>    mknod /tmp/test b 253 1024
>    ls -l /tmp/test
>    rm /tmp/test
> 
> and see if the major/minor is reported as "253, 1024" or "253, 0".
> If the later, you need new glibc.
> If the former, your userspace is up-to-date but there must be a bug in
> mdadm.
> If this is the case, let me know and I will look into it.

I fear there is a bug in mdadm or in the headers it includes:

linux:~ # mknod /tmp/test b 253 1024
linux:~ # ls -l /tmp/test
brw-r--r--  1 root root 253, 1024 Nov 24 00:59 /tmp/test
linux:~ # rm /tmp/test
linux:~ # strace mknod /tmp/test b 253 1024 2>&1|grep ^mknod
mknod("/tmp/test", S_IFBLK|0666, makedev(253, 1024)) = 0
linux:~ # rm /dev/md_d*
linux:~ # strace -o out.md0 mdadm -B /dev/md_d0 -f -l linear -n 1 -ap63 /dev/hdb5
mdadm: array /dev/md_d0 built and started.
linux:~ # strace -o out.md1 mdadm -B /dev/md_d1 -f -l linear -n 1 -ap63 /dev/hdb6
mdadm: array /dev/md_d1 built and started.
linux:~ # strace -o out.md2 mdadm -B /dev/md_d2 -f -l linear -n 1 -ap63 /dev/hdb7
mdadm: array /dev/md_d2 built and started.
linux:~ # strace -o out.md3 mdadm -B /dev/md_d3 -f -l linear -n 1 -ap63 /dev/hdb8
mdadm: array /dev/md_d3 built and started.
linux:~ # strace -o out.md4 mdadm -B /dev/md_d4 -f -l linear -n 1 -ap63 /dev/hdb9
mdadm: error opening /dev/md_d4: No such device or address
linux:~ # grep mknod out.md*|grep -v _p
out.md0:mknod("/dev/md_d0", S_IFBLK|0600, makedev(254, 0)) = 0
out.md1:mknod("/dev/md_d1", S_IFBLK|0600, makedev(254, 64)) = 0
out.md2:mknod("/dev/md_d2", S_IFBLK|0600, makedev(254, 128)) = 0
out.md3:mknod("/dev/md_d3", S_IFBLK|0600, makedev(254, 192)) = 0
out.md4:mknod("/dev/md_d4", S_IFBLK|0600, makedev(255, 0)) = 0
linux:~ #

Doing a more thorough analysis, it seems the MAJOR and MINOR macros
used by mdadm via includes can only handle the small dev_t.

Oh well... I just fixed it. Basically you have to replace all
occurences of MKDEV(X) with makedev(x), MAJOR(x) with major(x) and
MINOR(x) with minor(x) and it will work just fine. I have attached
a patch but I don't want to just mindlessly do a search/replace
operation without checking for issues with tools I didn't test,
so please test if it works for you.

Proof that it works for me:
linux:~ # strace -o out.md4 mdadm -B /dev/md_d4 -f -l linear -n 1 -ap63 /dev/hdb9
mdadm: array /dev/md_d4 built and started.
linux:~ # grep ^mknod out.md*|grep -v _p
out.md0:mknod("/dev/md_d0", S_IFBLK|0600, makedev(254, 0)) = 0
out.md1:mknod("/dev/md_d1", S_IFBLK|0600, makedev(254, 64)) = 0
out.md2:mknod("/dev/md_d2", S_IFBLK|0600, makedev(254, 128)) = 0
out.md3:mknod("/dev/md_d3", S_IFBLK|0600, makedev(254, 192)) = 0
out.md4:mknod("/dev/md_d4", S_IFBLK|0600, makedev(254, 256)) = 0
linux:~ #
[after some more experimenting]
linux:~ # ls -l /dev/md_d255
brw-rw----  1 root disk 254, 16320 Nov 24 03:03 /dev/md_d255
linux:~ #

However, it seems I have run into the 256 md devices limit ;-)

But I stumbled on another bug: It is possible to specify numbers >63
for the -ap parameter. Since the kernel always assumes 64 minors
per partitioned md device, this will cause mdadm to create devices
which overlap in minor ranges. Please introduce a limit for that
parameter to avoid nasty surprises.

And a feature request: Would it be possible to allow naming like
/dev/d0
/dev/d0p1
/dev/d0p2
etc. ? Right now, an unserscore character is enforced after a digit
and this prevents me from emulating some traditional device names.

Expert question: Since the only thing I do with md is abuse it
for supporting 63 partitions on generic block devices, is there
a tool instead of mdadm which fits my purposes better?

And another bug, this time in the kernel: Partitions for md devices
don't disappear from sysfs after deletion of the underlying md
device until the deleted device is opened again. Please fix that
(if it seems to difficult, my "partitioned loop device" patch
could serve as a starting point).

Thanks for reading this far.

Regards,
Carl-Daniel
-- 
http://www.hailfinger.org/

--------------060805090608050806000208
Content-Type: text/plain;
 name="mdadm_large_dev_t.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mdadm_large_dev_t.diff"

diff -urN mdadm-1.8.1-clean/Assemble.c mdadm-1.8.1/Assemble.c
--- mdadm-1.8.1-clean/Assemble.c	2004-11-02 06:11:06.000000000 +0100
+++ mdadm-1.8.1/Assemble.c	2004-11-24 02:59:50.386487368 +0100
@@ -272,7 +272,7 @@
 			/* prepare useful information in info structures */
 			struct stat stb2;
 			fstat(mdfd, &stb2);
-			info.array.md_minor = MINOR(stb2.st_rdev);
+			info.array.md_minor = minor(stb2.st_rdev);
 			
 			st->ss->update_super(&info, super, update, devname, verbose);
 			
@@ -291,8 +291,8 @@
 			fprintf(stderr, Name ": %s is identified as a member of %s, slot %d.\n",
 				devname, mddev, info.disk.raid_disk);
 		devices[devcnt].devname = devname;
-		devices[devcnt].major = MAJOR(stb.st_rdev);
-		devices[devcnt].minor = MINOR(stb.st_rdev);
+		devices[devcnt].major = major(stb.st_rdev);
+		devices[devcnt].minor = minor(stb.st_rdev);
 		devices[devcnt].oldmajor = info.disk.major;
 		devices[devcnt].oldminor = info.disk.minor;
 		devices[devcnt].events = info.events;
@@ -606,7 +606,7 @@
 		 * so we can just start the array
 		 */
 		unsigned long dev;
-		dev = MKDEV(devices[chosen_drive].major,
+		dev = makedev(devices[chosen_drive].major,
 			    devices[chosen_drive].minor);
 		if (ioctl(mdfd, START_ARRAY, dev)) {
 		    fprintf(stderr, Name ": Cannot start array: %s\n",
diff -urN mdadm-1.8.1-clean/Build.c mdadm-1.8.1/Build.c
--- mdadm-1.8.1-clean/Build.c	2004-11-01 03:36:30.000000000 +0100
+++ mdadm-1.8.1/Build.c	2004-11-24 02:59:50.397485696 +0100
@@ -117,7 +117,7 @@
 		array.raid_disks = raiddisks;
 		array.md_minor = 0;
 		if (fstat(mdfd, &stb)==0)
-			array.md_minor = MINOR(stb.st_rdev);
+			array.md_minor = minor(stb.st_rdev);
 		array.not_persistent = 1;
 		array.state = 0; /* not clean, but no errors */
 		if (assume_clean)
@@ -153,8 +153,8 @@
 			disk.number = i;
 			disk.raid_disk = i;
 			disk.state = 6;
-			disk.major = MAJOR(stb.st_rdev);
-			disk.minor = MINOR(stb.st_rdev);
+			disk.major = major(stb.st_rdev);
+			disk.minor = minor(stb.st_rdev);
 			if (ioctl(mdfd, ADD_NEW_DISK, &disk)) {
 				fprintf(stderr, Name ": ADD_NEW_DISK failed for %s: %s\n",
 					dv->devname, strerror(errno));
diff -urN mdadm-1.8.1-clean/Create.c mdadm-1.8.1/Create.c
--- mdadm-1.8.1-clean/Create.c	2004-11-02 06:25:10.000000000 +0100
+++ mdadm-1.8.1/Create.c	2004-11-24 02:59:50.434480072 +0100
@@ -303,7 +303,7 @@
 	 */
 	array.md_minor = 0;
 	if (fstat(mdfd, &stb)==0)
-		array.md_minor = MINOR(stb.st_rdev);
+		array.md_minor = minor(stb.st_rdev);
 	array.not_persistent = 0;
 	/*** FIX: Need to do something about RAID-6 here ***/
 	if ( ( (level == 5) &&
@@ -391,8 +391,8 @@
 					return 1;
 				}
 				fstat(fd, &stb);
-				disk.major = MAJOR(stb.st_rdev);
-				disk.minor = MINOR(stb.st_rdev);
+				disk.major = major(stb.st_rdev);
+				disk.minor = minor(stb.st_rdev);
 				close(fd);
 			}
 			if (disk.state != 1)
diff -urN mdadm-1.8.1-clean/Detail.c mdadm-1.8.1/Detail.c
--- mdadm-1.8.1-clean/Detail.c	2004-11-02 06:11:06.000000000 +0100
+++ mdadm-1.8.1/Detail.c	2004-11-24 02:59:50.448477944 +0100
@@ -131,7 +131,7 @@
 		struct mdstat_ent *ms = mdstat_read(0);
 		struct mdstat_ent *e;
 		int devnum = array.md_minor;
-		if (MAJOR(stb.st_rdev) != MD_MAJOR)
+		if (major(stb.st_rdev) != MD_MAJOR)
 			devnum = -1 - devnum;
 
 		for (e=ms; e; e=e->next)
@@ -251,8 +251,8 @@
 					 * device from the array, and then put it back.
 					 * If this fails, we are rebuilding
 					 */
-					int err = ioctl(fd, HOT_REMOVE_DISK, MKDEV(disk.major, disk.minor));
-					if (err == 0) ioctl(fd, HOT_ADD_DISK, MKDEV(disk.major, disk.minor));
+					int err = ioctl(fd, HOT_REMOVE_DISK, makedev(disk.major, disk.minor));
+					if (err == 0) ioctl(fd, HOT_ADD_DISK, makedev(disk.major, disk.minor));
 					if (err && errno ==  EBUSY)
 						printf(" rebuilding");
 				}
diff -urN mdadm-1.8.1-clean/Grow.c mdadm-1.8.1/Grow.c
--- mdadm-1.8.1-clean/Grow.c	2004-11-02 06:11:06.000000000 +0100
+++ mdadm-1.8.1/Grow.c	2004-11-24 02:59:50.474473992 +0100
@@ -117,8 +117,8 @@
 	 */
 	
 	info.disk.number = d;
-	info.disk.major = MAJOR(stb.st_rdev);
-	info.disk.minor = MINOR(stb.st_rdev);
+	info.disk.major = major(stb.st_rdev);
+	info.disk.minor = minor(stb.st_rdev);
 	info.disk.raid_disk = d;
 	info.disk.state = (1 << MD_DISK_SYNC) | (1 << MD_DISK_ACTIVE);
 	st->ss->update_super(&info, super, "grow", newdev, 0);
@@ -175,8 +175,8 @@
 		info.array.active_disks = nd+1;
 		info.array.working_disks = nd+1;
 		info.disk.number = nd;
-		info.disk.major = MAJOR(stb.st_rdev);
-		info.disk.minor = MINOR(stb.st_rdev);
+		info.disk.major = major(stb.st_rdev);
+		info.disk.minor = minor(stb.st_rdev);
 		info.disk.raid_disk = nd;
 		info.disk.state = (1 << MD_DISK_SYNC) | (1 << MD_DISK_ACTIVE);
 		st->ss->update_super(&info, super, "grow", dv, 0);
diff -urN mdadm-1.8.1-clean/Manage.c mdadm-1.8.1/Manage.c
--- mdadm-1.8.1-clean/Manage.c	2004-11-01 03:36:30.000000000 +0100
+++ mdadm-1.8.1/Manage.c	2004-11-24 02:59:50.494470952 +0100
@@ -226,8 +226,8 @@
 			disc.number =j;
 			disc.raid_disk = j;
 			disc.state = 0;
-			disc.major = MAJOR(stb.st_rdev);
-			disc.minor = MINOR(stb.st_rdev);
+			disc.major = major(stb.st_rdev);
+			disc.minor = minor(stb.st_rdev);
 			if (ioctl(fd,ADD_NEW_DISK, &disc)) {
 				fprintf(stderr, Name ": add new device failed for %s: %s\n",
 					dv->devname, strerror(errno));
diff -urN mdadm-1.8.1-clean/mdadm.c mdadm-1.8.1/mdadm.c
--- mdadm-1.8.1-clean/mdadm.c	2004-11-02 06:11:06.000000000 +0100
+++ mdadm-1.8.1/mdadm.c	2004-11-24 02:59:50.525466240 +0100
@@ -681,7 +681,7 @@
 		if ((int)ident.super_minor == -2) {
 			struct stat stb;
 			fstat(mdfd, &stb);
-			ident.super_minor = MINOR(stb.st_rdev);
+			ident.super_minor = minor(stb.st_rdev);
 		}
 	}
 
diff -urN mdadm-1.8.1-clean/mdopen.c mdadm-1.8.1/mdopen.c
--- mdadm-1.8.1-clean/mdopen.c	2004-11-01 03:36:30.000000000 +0100
+++ mdadm-1.8.1/mdopen.c	2004-11-24 02:59:50.542463656 +0100
@@ -49,21 +49,21 @@
 		return;
 	if (!S_ISBLK(stb.st_mode))
 		return;
-	major = MAJOR(stb.st_rdev);
-	minor = MINOR(stb.st_rdev);
+	major = major(stb.st_rdev);
+	minor = minor(stb.st_rdev);
 	for (i=1; i <= cnt ; i++) {
 		struct stat stb2;
 		sprintf(name, "%s%s%d", dev, dig?"_p":"", i);
 		if (stat(name, &stb2)==0) {
 			if (!S_ISBLK(stb2.st_mode))
 				continue;
-			if (stb2.st_rdev == MKDEV(major, minor+i))
+			if (stb2.st_rdev == makedev(major, minor+i))
 				continue;
 			unlink(name);
 		} else {
 			stb2 = stb;
 		}
-		mknod(name, S_IFBLK | 0600, MKDEV(major, minor+i));
+		mknod(name, S_IFBLK | 0600, makedev(major, minor+i));
 		chown(name, stb2.st_uid, stb2.st_gid);
 		chmod(name, stb2.st_mode & 07777);
 	}
@@ -101,7 +101,7 @@
 		/* check major number is correct */
 		if (autof>0)
 			major = get_mdp_major();
-		if (stb.st_mode && MAJOR(stb.st_rdev) != major)
+		if (stb.st_mode && major(stb.st_rdev) != major)
 			must_remove = 1;
 		if (stb.st_mode && !must_remove) {
 			mdu_array_info_t array;
@@ -168,7 +168,7 @@
 			unlink(dev);
 		}
 
-		if (mknod(dev, S_IFBLK|0600, MKDEV(major, minor))!= 0) {
+		if (mknod(dev, S_IFBLK|0600, makedev(major, minor))!= 0) {
 			fprintf(stderr, Name ": failed to create %s\n", dev);
 			return -1;
 		}
diff -urN mdadm-1.8.1-clean/Monitor.c mdadm-1.8.1/Monitor.c
--- mdadm-1.8.1-clean/Monitor.c	2004-11-01 03:36:30.000000000 +0100
+++ mdadm-1.8.1/Monitor.c	2004-11-24 02:59:50.573458944 +0100
@@ -246,10 +246,10 @@
 				struct stat stb;
 				if (fstat(fd, &stb) == 0 &&
 				    (S_IFMT&stb.st_mode)==S_IFBLK) {
-					if (MAJOR(stb.st_rdev) == MD_MAJOR)
-						st->devnum = MINOR(stb.st_rdev);
+					if (major(stb.st_rdev) == MD_MAJOR)
+						st->devnum = minor(stb.st_rdev);
 					else
-						st->devnum = -1- (MINOR(stb.st_rdev)>>6);
+						st->devnum = -1- (minor(stb.st_rdev)>>6);
 				}
 			}
 
@@ -323,7 +323,7 @@
 						alert("Fail", dev, dv, mailaddr, alert_cmd);
 					else if (i >= (unsigned)array.raid_disks &&
 						 (disc.major || disc.minor) &&
-						 st->devid[i] == MKDEV(disc.major, disc.minor) &&
+						 st->devid[i] == makedev(disc.major, disc.minor) &&
 						 ((newstate&change)&(1<<MD_DISK_FAULTY))
 						)
 						alert("FailSpare", dev, dv, mailaddr, alert_cmd);
@@ -335,7 +335,7 @@
 						alert("SpareActive", dev, dv, mailaddr, alert_cmd);
 				}
 				st->devstate[i] = disc.state;
-				st->devid[i] = MKDEV(disc.major, disc.minor);
+				st->devid[i] = makedev(disc.major, disc.minor);
 			}
 			close(fd);
 			st->active = array.active_disks;
diff -urN mdadm-1.8.1-clean/Query.c mdadm-1.8.1/Query.c
--- mdadm-1.8.1-clean/Query.c	2004-11-02 06:11:06.000000000 +0100
+++ mdadm-1.8.1/Query.c	2004-11-24 02:59:50.581457728 +0100
@@ -112,7 +112,7 @@
 			if (md_get_version(fd) >= 9000 &&	
 			    ioctl(fd, GET_ARRAY_INFO, &array)>= 0) {
 				if (ioctl(fd, GET_DISK_INFO, &disc) >= 0 &&
-				    MKDEV((unsigned)disc.major,(unsigned)disc.minor) == stb.st_rdev)
+				    makedev((unsigned)disc.major,(unsigned)disc.minor) == stb.st_rdev)
 					activity = "active";
 				else
 					activity = "mismatch";
diff -urN mdadm-1.8.1-clean/util.c mdadm-1.8.1/util.c
--- mdadm-1.8.1-clean/util.c	2004-11-05 04:07:11.000000000 +0100
+++ mdadm-1.8.1/util.c	2004-11-24 02:59:50.681442528 +0100
@@ -94,7 +94,7 @@
 	return  (vers.major*10000) + (vers.minor*100) + vers.patchlevel;
     if (errno == EACCES)
 	    return -1;
-    if (MAJOR(stb.st_rdev) == MD_MAJOR)
+    if (major(stb.st_rdev) == MD_MAJOR)
 	return (3600);
     return -1;
 }
@@ -328,8 +328,8 @@
 	char *n = strdup(name);
 	struct devmap *dm = malloc(sizeof(*dm));
 	if (dm) {
-	    dm->major = MAJOR(stb->st_rdev);
-	    dm->minor = MINOR(stb->st_rdev);
+	    dm->major = major(stb->st_rdev);
+	    dm->minor = minor(stb->st_rdev);
 	    dm->name = n;
 	    dm->next = devlist;
 	    devlist = dm;
@@ -478,14 +478,14 @@
 	if (dev < 0) {
 		int mdp =  get_mdp_major();
 		if (mdp < 0) return NULL;
-		rdev = MKDEV(mdp, (-1-dev)<<6);
+		rdev = makedev(mdp, (-1-dev)<<6);
 		sprintf(devname, "/dev/md/d%d", -1-dev);
 		if (stat(devname, &stb) == 0
 		    && (S_IFMT&stb.st_mode) == S_IFBLK
 		    && (stb.st_rdev == rdev))
 			return devname;
 	} else {
-		rdev = MKDEV(MD_MAJOR, dev);
+		rdev = makedev(MD_MAJOR, dev);
 		sprintf(devname, "/dev/md%d", dev);
 		if (stat(devname, &stb) == 0
 		    && (S_IFMT&stb.st_mode) == S_IFBLK
@@ -498,7 +498,7 @@
 		    && (stb.st_rdev == rdev))
 			return devname;
 	}
-	dn = map_dev(MAJOR(rdev), MINOR(rdev));
+	dn = map_dev(major(rdev), minor(rdev));
 	if (dn)
 		return dn;
 	sprintf(devname, "/dev/.tmp.md%d", dev);

--------------060805090608050806000208--
