From: Dan Christensen <jdc@uwo.ca>
Subject: Re: recovery from mkswap on mounted raid1 ext3 filesystem?
Date: Mon, 15 May 2006 23:22:03 -0400
Message-ID: <87d5eeu010.fsf@uwo.ca>
References: <87hd3qu2xu.fsf@uwo.ca>
	<17513.15336.921542.232057@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Adrian Bunk <bunk@stusta.de>
List-Id: linux-raid.ids

Neil Brown <neilb@suse.de> writes:

> On Monday May 15, jdc@uwo.ca wrote:
>> I accidentally ran mkswap on an md raid1 device which had a mounted
>> ext3 filesystem on it.  I also did a swapon, but I don't think
>> anything was written to swap before I noticed the mistake.  How much
>> of the partition is toast, and is it something e2fsck might fix?
>
> I think (and an strace seems to confirm) that mkswap only writes in
> the first 4k of the device.  This will have held the superblock, but
> there is always at least one backup - I think it is as block 8193.
> But 'fsck -n' should help you out, though you might need
> 'fsck.ext2 -n' as 'fsck' might think it is a swap device...

Thanks for the quick response!  I tried e2fsck, and it found the
backup superblock on its own.  I answered yes to dozens of questions,
and the filesystem is now intact.

> Ofcourse, if the filesystem is mounted, then unmounting the filesystem
> should write the superblock, which might fix any corruption you
> caused..

I decided to do a Alt-Sysrq-u Alt-Sysrq-b reboot to minimize what
was written to disk when things were already messed up.

> Adrian:  You seem to be the MAINTAINER of mkswap.. any chance of 
> opening for O_EXCL as well as O_RDWR.  That would make it a lot safer.

That would have saved me lots of worry!

Thanks again,

Dan

