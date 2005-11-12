From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: questions about ext3, raid-5, small files and wasted disk space
Date: Sat, 12 Nov 2005 13:06:41 +0000
Message-ID: <62b0912f0511120506n7f8c69bfq5217dbb2a639d6ec@mail.gmail.com>
References: <000901c5e6ff$0865deb0$b7df0f3d@kyleont8n3poyo>
	 <17269.54844.139.18467@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17269.54844.139.18467@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday November 12, Neil Brown wrote:
> On Saturday November 12, Kyle Wong wrote:
> > I understand that if I store a 224KB file into the RAID5, the
> > file will be divided into 7 parts x 32KB, plus 32KB parity.
> > (Am I correct in this?)
>
> Sort of ... if the filesystem happens to lay it out like that.
> But this isn't a useful way to think about it.  The filesystem
> writes the data in 4K blocks.  The raid5 layer worries about
> how to create the parity block.

Well, there IS some optimization to be done here that we're all missing out on,
if the filesystem does not take this into account, isn't there?

Is it reasonable to assume that Linux filesystems always start the
'data block area' (whatever) exactly on <x> * <fs block size> kB into
the device they're laid on?  Doesn't seem *entirely* unreasonable that
they'd do that, if not for optimization then just because their
authors happened to think that it would be neat code-wise.  If the
filesystem do that, then an optimization would be to just make sure
that the filesystem block size exactly equals the RAID chunk size.

Things become slightly harder if you start partitioning your RAID
device.  FDISK needs to make sure that partitions are on cylinder
boundaries, but luckily FDISK is rarely used to partition MD RAID
devices - LVM or EVMS is.  Both of those systems are technically free
to move the "partition data area" a few kB back or forth within the
RAID device so that the partition is aligned on a RAID chunk. 
Wouldn't that be great?  It would of course give you nothing, unless
the filesystem also aligns it's blocks (does it do that?).

(Then there's the fakeraid / ataraid people.  They're screwed, as far
as optimizations in this area go.  Maybe they can go and get someone
to make a raid bios that understands MD metadata :-).)
