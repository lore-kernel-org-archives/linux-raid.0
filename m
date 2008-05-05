From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: Software RAID partitions not detected at boot time with linux
	2.6.25.1.
Date: Mon, 05 May 2008 14:29:30 +0200
Message-ID: <1209990570.6975.5.camel@linux.site>
References: <200805032245.57084.assirati@nonada.if.usp.br>
	 <18461.45667.588613.443564@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18461.45667.588613.443564@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Joao Luis Meloni Assirati <assirati@nonada.if.usp.br>, Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 2008-05-04 at 22:56 +1000, Neil Brown wrote:
> On Saturday May 3, assirati@nonada.if.usp.br wrote:
> > Let's try again, this this time with a proper e-mail subject.

> > The problem I reported in
> > http://marc.info/?l=linux-kernel&m=120804001406787&w=2
> > still persists at 2.6.25.1. (sorry for the repeated messages there; that was 
> > my mail client's fault).
> > 
> > In my previous bug repor, I was using raid1; now, I am using raid5, as 
> > follows.
> > 
> > I have three partitions /dev/sda2, /dev/sdb2 and /dev/sdc2 marked as raid 
> > autodetect (FD). They are assembled as a partitionable raid 5 array, and my 
> > root is in /dev/md_d0p1. With a 2.6.24.2 kernel with sata, ext3 and raid5 
> > compiled in (I don't use initrd), the system boots fine. In fact, the raid 
> > array and partitions are detected as show with dmesg:
> > 
> > md: Autodetecting RAID arrays.
> > md: Scanned 3 and added 3 devices.
> > md: autorun ...
> > md: considering sdc2 ...
> > md:  adding sdc2 ...
> > md:  adding sdb2 ...
> > md:  adding sda2 ...
> > md: created md_d0
> > md: bind<sda2>
> > md: bind<sdb2>
> > md: bind<sdc2>
> > md: running: <sdc2><sdb2><sda2>
> > raid5: device sdc2 operational as raid disk 2
> > raid5: device sdb2 operational as raid disk 1
> > raid5: device sda2 operational as raid disk 0
> > raid5: allocated 3226kB for md_d0
> > raid5: raid level 5 set md_d0 active with 3 out of 3 devices, algorithm 2
> > RAID5 conf printout:
> >  --- rd:3 wd:3
> >  disk 0, o:1, dev:sda2
> >  disk 1, o:1, dev:sdb2
> >  disk 2, o:1, dev:sdc2
> > md: ... autorun DONE.
> >  md_d0: p1 p2 p3 p4 < p5 p6 p7 >
> > 
> > The last line shows my raid partitions are detected.
> > 
> > However, when I try kernel 2.6.25.1, again with sata, ext3 and raid5 compiled 
> > in and no initrd, the kernel does not recognize the raid partitions at boot 
> > time, nonetheless the array is dected. The output of dmesg is the same  until:
> > 
> > raid5: allocated 3224kB for md_d0
> > raid5: raid level 5 set md_d0 active with 3 out of 3 devices, algorithm 2
> > RAID5 conf printout:
> >  --- rd:3 wd:3
> >  disk 0, o:1, dev:sda2
> >  disk 1, o:1, dev:sdb2
> >  disk 2, o:1, dev:sdc2
> > md: ... autorun DONE.
> > VFS: Cannot open root device "md_d0p1" or unknown-block(0,0)
> > Please append a coorect "root=" boot option; here are the available partitions:
> > 0800  312571224 sda driver:sd
> >   0801      96358 sda1
> >   0802  312472282 sda2
> > 0810  312571224 sdb driver:sd
> >   0811      96358 sdb1
> >   0812  312472282 sdb2
> > 0820  312571224 sdc driver:sd
> >   0821      96358 sdc1
> >   0822  312472282 sdc2
> > fe00  624944384 md_d0 (driver?)
> > Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0)
> > 
> > Note the absence of the line
> >  md_d0: p1 p2 p3 p4 < p5 p6 p7 >
> > showing partition detection.
> > 
> 
> It appears this regression was introduced by commit
>    edfaa7c36574f1bf09c65ad602412db9da5f96bf
>    Driver core: convert block from raw kobjects to core devices
> 
> Previously, the device name "md_d0p1" would be parsed out as "md_d0"
> and partition 1.
> md_d0 would be found and the device number of the first partition
> could then be deduced even though the partition table hadn't been
> processed at this point, so 'p1' wasn't actually known.
> The kernel would attempt to open 'p1', this would trigger a read of
> the partition table and the open would be successful.
> 
> The new code is 'simpler'.  It doesn't try to parse the device name at
> all.  It just compares the device name against the names of all known
> devices.  As the partitions are not known at this time, md_d0p1 is not
> found.
> 
> There seem to be two ways this could be fixed:
> 1/ restore the old behaviour of parsing out the partition information.
>    This would be least likely to leave other regressions waiting to be
>    found, but might be seen as somewhat ugly.
> 
> 2/ Get md_d0 to read it's partition table earlier.  I've tried this
>    before without much luck.
>    There are three times that the partition table can be parsed.
>    a/ When the device is opened if bd_invalidated is set.
>    b/ When the device is first registered.  register_disk calls
>       blkdev_get which effectively opens the device, thus triggering
>       'a' above.
>    c/ When the BLKRRPART ioctl is made on the device.
> 
>    When an md device is first registered, there are no disks attached
>    to it, so no partition table can be read.  The way md devices get
>    set up, they are registered as empty devices, the component devices
>    are attached, then the array is 'started'.  Only at this point can
>    data, such as the partition table, be read.  But this it too late
>    for case 'b' above.  Case 'a' is the one that usually causes
>    partitions to be read.  'mdadm' explicitly opens devices after
>    creating them to trigger this.
> 
>    We could conceivably put a BLKRRPART call in at the end of
>    autorun_array where the array has just been started, but that would
>    be rather ugly.  We would need to open the device, and doing that
>    inside the kernel is never clean.  The code in 'init/*.c' for that
>    sort of thing creates nodes in /dev in a temporary root filesystem.
>    We cannot do that for autorun_array as it can be call long after
>    boot time (but the RAID_AUTODETECT ioctl) so there may not be 
>    a temporary filesystem to play with.
> 
> So I currently think that restoring the old behaviour of not requiring
> partitions to exist before trying to open them would be best.
> 
> Kay?

Care to test/fix/improve the following. I just booted a normal disk,
didn't test a partitioned md device.

Thanks,
Kay



From: Kay Sievers <kay.sievers@vrfy.org>
Subject: block: do_mounts - accept root=<non-existant partition>

Some devices, like md, may create partitions only at first access,
so allow root= to be set to a valid non-existant partition of an
existing disk. This applies only to non-initramfs root mounting.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---

diff --git a/block/genhd.c b/block/genhd.c
index fda9c7a..129ad93 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -653,7 +653,7 @@ void genhd_media_change_notify(struct gendisk *disk)
 EXPORT_SYMBOL_GPL(genhd_media_change_notify);
 #endif  /*  0  */
 
-dev_t blk_lookup_devt(const char *name)
+dev_t blk_lookup_devt(const char *name, int part)
 {
 	struct device *dev;
 	dev_t devt = MKDEV(0, 0);
@@ -661,7 +661,11 @@ dev_t blk_lookup_devt(const char *name)
 	mutex_lock(&block_class_lock);
 	list_for_each_entry(dev, &block_class.devices, node) {
 		if (strcmp(dev->bus_id, name) == 0) {
-			devt = dev->devt;
+			struct gendisk *disk = dev_to_disk(dev);
+
+			if (part < disk->minors)
+				devt = MKDEV(MAJOR(dev->devt),
+					     MINOR(dev->devt) + part);
 			break;
 		}
 	}
@@ -669,7 +673,6 @@ dev_t blk_lookup_devt(const char *name)
 
 	return devt;
 }
-
 EXPORT_SYMBOL(blk_lookup_devt);
 
 struct gendisk *alloc_disk(int minors)
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index ecd2bf6..612a790 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -524,7 +524,7 @@ struct unixware_disklabel {
 #define ADDPART_FLAG_RAID	1
 #define ADDPART_FLAG_WHOLEDISK	2
 
-extern dev_t blk_lookup_devt(const char *name);
+extern dev_t blk_lookup_devt(const char *name, int part);
 extern char *disk_name (struct gendisk *hd, int part, char *buf);
 
 extern int rescan_partitions(struct gendisk *disk, struct block_device *bdev);
@@ -552,7 +552,7 @@ static inline struct block_device *bdget_disk(struct gendisk *disk, int index)
 
 static inline void printk_all_partitions(void) { }
 
-static inline dev_t blk_lookup_devt(const char *name)
+static inline dev_t blk_lookup_devt(const char *name, int part)
 {
 	dev_t devt = MKDEV(0, 0);
 	return devt;
diff --git a/init/do_mounts.c b/init/do_mounts.c
index 3885e70..660c1e5 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -76,6 +76,7 @@ dev_t name_to_dev_t(char *name)
 	char s[32];
 	char *p;
 	dev_t res = 0;
+	int part;
 
 	if (strncmp(name, "/dev/", 5) != 0) {
 		unsigned maj, min;
@@ -106,7 +107,31 @@ dev_t name_to_dev_t(char *name)
 	for (p = s; *p; p++)
 		if (*p == '/')
 			*p = '!';
-	res = blk_lookup_devt(s);
+	res = blk_lookup_devt(s, 0);
+	if (res)
+		goto done;
+
+	/*
+	 * try non-existant, but valid partition, which may only exist
+	 * after revalidating the disk, like partitioned md devices
+	 */
+	while (p > s && isdigit(p[-1]))
+		p--;
+	if (p == s || !*p || *p == '0')
+		goto fail;
+
+	/* try disk name without <part number> */
+	part = simple_strtoul(p, NULL, 10);
+	*p = '\0';
+	res = blk_lookup_devt(s, part);
+	if (res)
+		goto done;
+
+	/* try disk name without p<part number> */
+	if (p < s + 2 || !isdigit(p[-2]) || p[-1] != 'p')
+		goto fail;
+	p[-1] = '\0';
+	res = blk_lookup_devt(s, part);
 	if (res)
 		goto done;
 


