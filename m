From: "Eric Wood" <eric@interplas.com>
Subject: Re: Converting a non-RAID RedHat System to run on Software RAID
Date: Thu, 11 Sep 2003 08:21:06 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <022d01c3785f$2d39e120$9100000a@intgrp.com>
References: <E5DA6395B8F9614EB7A784D628184B200D9A56@hdsmsx402.hd.intel.com> <20030910131849.GA5267@ti19>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I may be wrong but simply 'e'diting the boot menu at boot time doesn't write
back anything to the filesystem.  I edit my boot string all the time to try
out all sorts of kernel arguments like "ide=nodma" and upon the next reboot
that modification is gone.  Until you actually put it in
/boot/grub/grub.conf is won't stick or do an "install" from within grub,
then I can't see why grub is altering your /boot filesystem to get the
mirror out of sync.  Sounds like a bug!
-eric wood

Bill Rugolsky Jr. wrote:
> desynchronizes the RAID1 set. [It seems that simply using 'e' to edit
> the kernel args has this effect, though I haven't verified it
> myself.]  We see this corruption in MD5 variation in our nightly
> integrity-verification cron job.
>
> Trivial workaround is to resync the second drive in the rc scripts;
> for the typical 50-100MB /boot partition, this takes only a few
> seconds.
>
> Bill Rugolsky

