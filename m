From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Partitioned raid and major number
Date: Fri, 27 Feb 2004 11:21:22 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16446.36226.591283.495194@notabene.cse.unsw.edu.au>
References: <20040225145624.GA1513@cistron.nl>
	<16445.12026.812778.621025@notabene.cse.unsw.edu.au>
	<20040226215144.GC11831@drinkel.cistron.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Miquel van Smoorenburg on Thursday February 26
To: Miquel van Smoorenburg <miquels@cistron.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday February 26, miquels@cistron.nl wrote:
> 
> Hmm, is there anyone who has > 128 MD devices on one system? If not, why not
> use the top 128 majors for, say, 8 MD devices each with 16 partitions ?
> Then the kernel command line option "md=0,/dev/sda,/dev/sdb,part" would create
> a partitionable md0 array. And if you don't add "part" things stay as they
> were with 256 MD majors.

Maybe there is someone with > 128 MD arrays.  There is no way to find
out except to break it and wait about a year or two.

I did consider having some partitionable and some non-partitionable
arrays under the one MAJOR.  It would be technically quite easy, but I
think it is conceptually harder to work with - the mapping from minor
number to device would not be what people have come to expect.

> > With it:
> >   If you put 
> >          raid=partitionable
> >   or just
> >          raid=part
> > as a kernel parameter, then all auto-detected raid arrays will be
> > partitionable, using the dynamically allocated major.
> > 
> > Also, if you use e.g. "md=0,/dev/sda,/dev/sdb" to assemble your arrays
> > at boot time, you can now use:
> >          "md=d0,/dev/sda,/dev/sdb"
> > to assemble as a partitionable array (so it will be /dev/md/d0 instead
> > of /dev/md0.  Hence the 'd').
> 
> I did exactly that on a server with /dev/sda and /dev/sdb (those are 2
> SATA disks through libata). Since /dev/sda contains the currently installed
> system I marked it as failed in /etc/raidtab before creating the array.
> 
> But it doesn't work.
> 
> # cat /proc/cmdline
> auto BOOT_IMAGE=Linux ro root=801 raid=partitionable md=d0,/dev/sda,/dev/sdb
> # ls /sys/block
> md0  sda  sdb
> # ls /sys/block/md0
> dev  range  size  stat
> # dmesg | grep md:
> md: Will configure md0 (super-block) from /dev/sda,/dev/sdb, below.
> md: raid1 personality registered as nr 3
> md: md driver 0.90.0 MAX_MD_DEVS=256, MD_SB_DISKS=27
> md: Autodetecting RAID arrays.
> md: autorun ...
> md: ... autorun DONE.
> md: Loading md_d0: /dev/sda
> md: invalid raid superblock magic on sda
> md: sda has invalid sb, not importing!
> md: md_import_device returned -22
> md: bind<sdb>
> 
> Is it because the first disk is invalid ? That shouldn't happen,
> right?

Right.  I missed a bit in the patch.
(I assume you are still wanting to boot off /dev/sda until you copy
the data into /dev/md/d0p* - then you will use root=/dev/md_d0p1)

NeilBrown



 ----------- Diffstat output ------------
 ./init/do_mounts_md.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff ./init/do_mounts_md.c~current~ ./init/do_mounts_md.c
--- ./init/do_mounts_md.c~current~	2004-02-26 10:15:07.000000000 +1100
+++ ./init/do_mounts_md.c	2004-02-27 11:20:14.000000000 +1100
@@ -134,7 +134,8 @@ static void __init md_setup_drive(void)
 
 		sprintf(name, "/dev/md%s%d", partitioned?"_d":"", minor);
 		sprintf(devfs_name, "/dev/md/%s%d", partitioned?"d":"", minor);
-		create_dev(name, MKDEV(MD_MAJOR, minor), devfs_name);
+		dev = name_to_dev_t(name);
+		create_dev(name, dev, devfs_name);
 		for (i = 0; i < MD_SB_DISKS && devname != 0; i++) {
 			char *p;
 			char comp_name[64];
