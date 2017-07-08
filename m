From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: My MD is too big to resize ext4.
Date: Sat, 8 Jul 2017 08:50:40 +0200
Message-ID: <20170708065040.GA3682@metamorpher.de>
References: <6c827d07-19d8-017b-ca95-5e6f84b7821a@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <6c827d07-19d8-017b-ca95-5e6f84b7821a@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ram Ramesh <rramesh2400@gmail.com>
Cc: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Jul 07, 2017 at 07:41:13PM -0500, Ram Ramesh wrote:
> On the web, I only found one solution that required upgrading kernel to 
> some very recent one (not in my distro) and getting the bleeding edge 
> resize2fs. This makes me nervous. Is there a solution that avoids this.

Well, if that works nowadays, then just go for it (LiveCD). 
For details you should ask the ext4 mailing list I guess.

You can assemble your RAID in read-only mode and then use 
overlays for a non-destructive test run. To make really extra sure 
you could even export it via NBD/KVM to see if the old kernel 
is able to mount it.

IIRC, btrfs also has a migration path (ext4 to btrfs converter) 
and then you could grow that. But then you're stuck with btrfs.

> My filesystem is on md0 drive so I guess partitioning and making into 2x 
> 12TB ext4 will not work. I am not even sure if we can partition md like 
> any other disk.

Adding a partition table or LVM header would shift the start position.
So it would involve moving/shifting all your data in-place or using 
a conversion to LVM. (We just had that in the thread above yours, 
subject "linear device of two arrays")

If your RAID has a large enough data offset, you could shift that 
to add some extra space at the start of the RAID, but it has to 
be done with great care (must be aligned to whatever your RAID 
layout is so data will be intact and not garbled).

All in-place operations are kind of hackish/dangerous.

I actually prefer using several smaller filesystems over one gigantic one.
It's all great until your one and only filesystem goes corrupt.

Regards
Andreas Klauer
