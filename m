From: Neil Brown <neilb@suse.de>
Subject: Re: RAID5 resync question BUGREPORT!
Date: Thu, 22 Dec 2005 15:46:07 +1100
Message-ID: <17322.12175.915592.878387@cse.unsw.edu.au>
References: <045901c5f9fa$8f2b7fa0$0400a8c0@dcccs>
	<17300.56329.638969.509384@cse.unsw.edu.au>
	<004201c5f9fe$50cc41a0$0400a8c0@dcccs>
	<17300.58327.193597.248431@cse.unsw.edu.au>
	<035b01c5fc4b$416c98f0$0400a8c0@dcccs>
	<17304.50474.390938.734714@cse.unsw.edu.au>
	<001101c5fc75$a28cb230$0400a8c0@dcccs>
	<17305.3277.821697.223406@cse.unsw.edu.au>
	<000001c5eb50$4e6fada0$a700a8c0@dcccs>
	<17318.1401.296396.667001@cse.unsw.edu.au>
	<005d01c60487$cc198b40$0400a8c0@dcccs>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from JaniD++ on Monday December 19
Sender: linux-raid-owner@vger.kernel.org
To: JaniD++ <djani22@dynamicweb.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday December 19, djani22@dynamicweb.hu wrote:
> ----- Original Message ----- 
> From: "Neil Brown" <neilb@suse.de>
> To: "JaniD++" <djani22@dynamicweb.hu>
> Cc: <linux-raid@vger.kernel.org>
> Sent: Monday, December 19, 2005 1:57 AM
> Subject: Re: RAID5 resync question BUGREPORT!
> >
> > How big is your array?
> 
>      Raid Level : raid5
>      Array Size : 1953583360 (1863.08 GiB 2000.47 GB)
>     Device Size : 195358336 (186.31 GiB 200.05 GB)
> 
> 
> > The default bitmap-chunk-size when the bitmap is in a file is 4K, this
> > makes a very large bitmap on a large array.

Hmmm The bitmap chunks are in the device space rather than the array
space. So 4K chunks in 186GiB is 48million chunks, so 48million bits.
8*4096 bits per page, so 1490 pages, which is a lot, and maybe a
waste, but you should be able to allocate 4.5Meg...

But there is a table which holds pointers to these pages.
4 bytes per pointer (8 on a 64bit machine) so 6K or 12K for the table.
Allocating anything bigger than 4K can be a problem, so that is
presumably the limit you hit.

The max the table size should be is 4K, which is 1024 pages (on a
32bit machine), which is 33 million bits.  So we shouldn't allow more
than 33million (33554432 actually) chunks.
On you array, that would be 5.8K, so 8K chunks should be ok, unless
you have a 64bit machine, then 16K chunks.
Still that is wasting a lot of space.

> 
> Yes, and if i can see correctly, it makes overflow.
> 
> > Try a larger bitmap-chunk size e.g.
> >
> >    mdadm -G --bitmap-chunk=256 --bitmap=/raid.bm /dev/md0
> 
> I think it is still uncompleted!
> 
> [root@st-0001 /]# mdadm -G --bitmap-chunk=256 --bitmap=/raid.bm /dev/md0
> mdadm: Warning - bitmaps created on this kernel are not portable
>   between different architectured.  Consider upgrading the Linux kernel.
> Segmentation fault

Oh dear.... There should have been an 'oops' message in the kernel
logs.  Can you post it.

> [root@st-0001 /]#
> 
> And the raid layer is stopped.
> (The nbd-server stops to serving, and the cat /proc/mdstat is hangs too.
> i try to sync, and
> echo b >/proc/sysrq-trigger
> After reboot, everything is back to normal.)
> 
> This generates one 96000 byte /raid.bm.
That sounds right.

> 
> (Anyway i think the --bitmap-chunk option is neccessary to be automaticaly
> generated.)

Yes... I wonder what the default should be.
Certainly not more than 33million bits.  Maybe a maximum of 8 million
(1 megabyte).

> 
> 
> > > [root@st-0001 root]# mdadm -X /dev/md0
> >
> > This usage is only appropriate for arrays with internal bitmaps (I
> > should get mdadm to check that..).
> 
> Is there a way to check external bitmaps?

mdadm -X /raid.bm

i.e. eXamine the object (device or file) that has the bitmap on it.
Actually, I don't think 'mdadm -X /dev/md0' is right even for
'internal' bitmaps.  It should be 'mdadm -x /dev/sda1' Or whichever
is a component device.

> 
> > >
> > > And now what? :-)
> >
> > Either create an 'internal' bitmap, or choose a --bitmap-chunk size
> > that is larger.
> 
> First you sad, the space to the internal bitmap is only 64K.
> My first bitmap file is ~4MB, and with --bitmap-chunk=256 option still 96000
> Byte.
> 
> I don't think so... :-)

When using an internal bitmap, mdadm will automatically size the
bitmap to fit. In your case I think it will choose 512k as the chunk
size so the bitmap of 48K will fit in the space after the superblock.
> 
> I am affraid to overwrite an existing data.
> 

There is no risk of that.

NeilBrown

(holidays are coming, so I may not be able to reply further for a
couple of weeks)
