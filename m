From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: Mapping physical disk block to logical block to selectively repair w/o forcing rescan
Date: Tue, 15 Apr 2008 23:04:40 -0700
Message-ID: <e9c3a7c20804152304o6e784072pf78b11ed840c6459@mail.gmail.com>
References: <A49AB75A717185448F69082E969E536B03C2647E@34093-EVS1C2.exchange.rackspace.com>
	 <e9c3a7c20804151735n6793339dl764c0d57aedabc57@mail.gmail.com>
	 <e9c3a7c20804151737k44b09572x484c7c41ff90e09d@mail.gmail.com>
	 <A49AB75A717185448F69082E969E536B03C264CC@34093-EVS1C2.exchange.rackspace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A49AB75A717185448F69082E969E536B03C264CC@34093-EVS1C2.exchange.rackspace.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: David Lethe <david@santools.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Apr 15, 2008 at 7:47 PM, David Lethe <david@santools.com> wrote:
> I have the physical disk sector/drive, so I will have to go backwards.
>  That means using compute_blocknr, factoring the chunk size, stripe size,
>  look at the raid5_private_data to get everything else, including whether
>  or not it is in a rebuild, what position the disk has in the stripe,
>  among
>  other things .. and repeat for RAID6.  Still all scriptable .. as long
>  as I keep the block calculations in 64-bits when on 32-bit kernel.
>
>  I can parse mdadm -Q -D  to get health and configuration, or get it from
>  sysfs, haven't decided.
>
>  Now for recovery ... a change was made in 2.6.15 that affects how the
>  /dev/md recalculates & corrects the error, but I don't think I have to
>  worry about it. Just directly read the /dev/md block that corresponds to
>  the faulty physical disk/sector.  This should just repair the bad block
>  w/o enticing the md system to fail over the entire disk.  Exception
>  would be if the disk with bad block can remap due to a catastrophic
>  failure, or lack of spare sectors.
>
>  Even if the bad physical block lands on a parity block in the /dev/md
>  space, it should get rebuilt because it has to read the entire stripe to
>  figure out if there is a parity error, which there will be because one
>  disk will return the sense data indicating an unrecoverable read error,
>  so the md will repair the stripe to keep parity consistent for me.
>

There is no guarantee you can actually cause the bad block to be read
by doing a "dd if=/dev/mdN...".  The kernel will sometimes calculate a
disk without causing a read, although in  most cases it will directly
hit the disk.  For correcting parity disk bad blocks there is no way
to trigger a parity read without doing a resync operation or a write.
That said, it would not be too difficult to add an interface to tell
the kernel to try to read an entire stripe in order to trigger the bad
block recovery code.  Another aspect of the mechanism could be to have
the kernel not fail the disk and instead let userspace update a
badblocks(8) file to tell the filesystem to ignore that part of the
array...

--
Dan
