From: Miquel van Smoorenburg <miquels@cistron.nl>
Subject: Re: Partitioned raid and major number
Date: Thu, 26 Feb 2004 22:51:44 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040226215144.GC11831@drinkel.cistron.nl>
References: <20040225145624.GA1513@cistron.nl> <16445.12026.812778.621025@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <16445.12026.812778.621025@notabene.cse.unsw.edu.au> (from neilb@cse.unsw.edu.au on Thu, Feb 26, 2004 at 00:25:46 +0100)
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Miquel van Smoorenburg <miquels@cistron.nl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 26 Feb 2004 00:25:46, Neil Brown wrote:
> On Wednesday February 25, miquels@cistron.nl wrote:
> > Hello,
> > 
> > 	I see that Linus merged partitioned raid into bitkeeper.
> > The major number of partitioned raid devices is allocated dynamically.
> > 
> > I want to set up a server with 2 disks in RAID1 mode, partitioned.
> > To be able to boot from it, the RAID1 device needs to have a fixed
> > major number (I don't want to be forced to use an initrd). Is it
> > planned to ask LANANA for a fixed major number? If not, would a
> > patch to pass the major number on the kernel command line be accepted ?
> 
> The lack of a statically allocate device number is not the problem.
> You can have a kernel parameter that says
>        root=/dev/md_d0p1
> and it should manage to find the device thanks to sysfs.
> The bit that you cannot do yet is assemble the array as a
> partitionable array rather than a non-partitionable array.

Hmm, is there anyone who has > 128 MD devices on one system? If not, why not
use the top 128 majors for, say, 8 MD devices each with 16 partitions ?
Then the kernel command line option "md=0,/dev/sda,/dev/sdb,part" would create
a partitionable md0 array. And if you don't add "part" things stay as they
were with 256 MD majors.

That's just a suggestion. Feel free to completely ignore it (as you
probably will since dynamically allocated majors, initrd and udev are the
future some people say ..)

> Would you be willing to try the following patch?

Sure.

> With it:
>   If you put 
>          raid=partitionable
>   or just
>          raid=part
> as a kernel parameter, then all auto-detected raid arrays will be
> partitionable, using the dynamically allocated major.
> 
> Also, if you use e.g. "md=0,/dev/sda,/dev/sdb" to assemble your arrays
> at boot time, you can now use:
>          "md=d0,/dev/sda,/dev/sdb"
> to assemble as a partitionable array (so it will be /dev/md/d0 instead
> of /dev/md0.  Hence the 'd').

I did exactly that on a server with /dev/sda and /dev/sdb (those are 2
SATA disks through libata). Since /dev/sda contains the currently installed
system I marked it as failed in /etc/raidtab before creating the array.

But it doesn't work.

# cat /proc/cmdline
auto BOOT_IMAGE=Linux ro root=801 raid=partitionable md=d0,/dev/sda,/dev/sdb
# ls /sys/block
md0  sda  sdb
# ls /sys/block/md0
dev  range  size  stat
# dmesg | grep md:
md: Will configure md0 (super-block) from /dev/sda,/dev/sdb, below.
md: raid1 personality registered as nr 3
md: md driver 0.90.0 MAX_MD_DEVS=256, MD_SB_DISKS=27
md: Autodetecting RAID arrays.
md: autorun ...
md: ... autorun DONE.
md: Loading md_d0: /dev/sda
md: invalid raid superblock magic on sda
md: sda has invalid sb, not importing!
md: md_import_device returned -22
md: bind<sdb>

Is it because the first disk is invalid ? That shouldn't happen, right?

Thanks,

Mike.
