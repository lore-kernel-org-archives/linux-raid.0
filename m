From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: RAID5 (mdadm) array hosed after grow operation
Date: Mon, 5 Jan 2009 09:13:56 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0901050913470.3359@p34.internal.lan>
References: <1231144738.2997.1293010001@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1231144738.2997.1293010001@webmail.messagingengine.com>
Sender: linux-raid-owner@vger.kernel.org
To: whollygoat@letterboxes.org
Cc: debian-user@lists.debian.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

cc linux-raid

On Mon, 5 Jan 2009, whollygoat@letterboxes.org wrote:

> I think growing my RAID array after replacing all the
> drives with bigger ones has somehow hosed the array.
>
> The system is Etch with a stock 2.6.18 kernel and
> mdadm v. 2.5.6, running on an Athlon 1700 box.
> The array is 6 disk (5 active, one spare) RAID 5
> that has been humming along quite nicely for
> a few months now.  However, I decided to replace
> all the drives with larger ones.
>
> The RAID reassembled fine at each boot as the drives
> were replaced one by one.  After the last drive was
> partitioned and added to the array, I issued the
> command
>
>   "mdadm -G /dev/md/0 -z max"
>
> to grow the array to the maximum space available
> on the smallest drive.  That appeared to work just
> fine at the time, but booting today the array
> refused to assemble with the following error:
>
>    md: hdg1 has invalid sb, not importing!
>    md: md_import_device returned -22
>
> I tried to force assembly but only two of the remaining
> 4 active drives appeared to be fault free.  dmesg gives
>
>    md: kicking non-fresh hde1 from array!
>    md: unbind<hde1>
>    md: export_rdev(hde1)
>    md: kicking non-fresh hdi1 from array!
>    md: unbind<hdi1>
>    md: export_rdev(hdi1)
>
> I also noticed that "mdadm -X <drive>" shows
> the pre-grow device size for 2 of the devices
> and some discrepancies between event and event cleared
> counts.
>
> One last thing I found curious---from dmesg:
>
>    EXT3-fs error (device hdg1): ext3_check_descriptors: Block
>    bitmap for group 0 not in group (block 2040936682)!
>    EXT3-fs: group descriptors corrupted!
>
> There is not ext3 directly on hdg1.  LVM sits between the
> and the filesystem, so the above message seems suspect.
>
> I hope someone will be able to help me with this.  I feel
> like the info above is pertinent, but I don't know where to
> go from here.
>
> Thanks
> -- 
>
>  whollygoat@letterboxes.org
>
> -- 
> http://www.fastmail.fm - Does exactly what it says on the tin
>
>
> -- 
> To UNSUBSCRIBE, email to debian-user-REQUEST@lists.debian.org
> with a subject of "unsubscribe". Trouble? Contact listmaster@lists.debian.org
>
