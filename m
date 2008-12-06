From: Redeeman <redeeman@metanurb.dk>
Subject: Re: 12x performance drop on md/linux+sw raid1 due to barriers [xfs]
Date: Sat, 06 Dec 2008 21:35:40 +0100
Message-ID: <1228595740.16555.105.camel@localhost>
References: <alpine.DEB.1.10.0812060928030.14215@p34.internal.lan>
	 <493A9BE7.3090001@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <493A9BE7.3090001@sandeen.net>
Sender: linux-raid-owner@vger.kernel.org
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org, xfs@oss.sgi.com, Alan Piszcz <ap@solarrain.com>
List-Id: linux-raid.ids

On Sat, 2008-12-06 at 09:36 -0600, Eric Sandeen wrote:
> Justin Piszcz wrote:
> > Someone should write a document with XFS and barrier support, if I recall,
> > in the past, they never worked right on raid1 or raid5 devices, but it
> > appears now they they work on RAID1, which slows down performance ~12 times!!
> 
> What sort of document do you propose?  xfs will enable barriers on any
> block device which will support them, and after:
> 
> deeb5912db12e8b7ccf3f4b1afaad60bc29abed9
> 
> [XFS] Disable queue flag test in barrier check.
> 
> xfs is able to determine, via a test IO, that md raid1 does pass
> barriers through properly even though it doesn't set an ordered flag on
> the queue.
> 
> > l1:~# /usr/bin/time tar xf linux-2.6.27.7.tar 
> > 0.15user 1.54system 0:13.18elapsed 12%CPU (0avgtext+0avgdata 0maxresident)k
> > 0inputs+0outputs (0major+325minor)pagefaults 0swaps
> > l1:~#
> > 
> > l1:~# /usr/bin/time tar xf linux-2.6.27.7.tar
> > 0.14user 1.66system 2:39.68elapsed 1%CPU (0avgtext+0avgdata 0maxresident)k
> > 0inputs+0outputs (0major+324minor)pagefaults 0swaps
> > l1:~#
> > 
> > Before:
> > /dev/md2        /               xfs     defaults,noatime  0       1
> > 
> > After:
> > /dev/md2        /               xfs     defaults,noatime,nobarrier,logbufs=8,logbsize=262144 0 1
> 
> Well, if you're investigating barriers can you do a test with just the
> barrier option change; though I expect you'll still find it to have a
> substantial impact.
> 
> > There is some mention of it here:
> > http://oss.sgi.com/projects/xfs/faq.html#wcache_persistent
> > 
> > But basically I believe it should be noted in the kernel logs, FAQ or somewhere
> > because just through the process of upgrading the kernel, not changing fstab
> > or any other part of the system, performance can drop 12x just because the
> > newer kernels implement barriers.
> 
> Perhaps:
> 
> printk(KERN_ALERT "XFS is now looking after your metadata very
> carefully; if you prefer the old, fast, dangerous way, mount with -o
> nobarrier\n");
> 
> :)
> 
> Really, this just gets xfs on md raid1 in line with how it behaves on
> most other devices.
> 
> But I agree, some documentation/education is probably in order; if you
> choose to disable write caches or you have faith in the battery backup
> of your write cache, turning off barriers would be a good idea.  Justin,
> it might be interesting to do some tests with:
> 
> barrier,   write cache enabled
> nobarrier, write cache enabled
> nobarrier, write cache disabled
> 
> a 12x hit does hurt though...  If you're really motivated, try the same
> scenarios on ext3 and ext4 to see what the barrier hit is on those as well.
I have tested with ext3/xfs, and barriers have considerably more impact
on xfs than ext3. this is ~4 months old test, I do not have any precise
data anymore.


> 
> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

