From: "Jonathan Baker-Bates" <jonathan@bakerbates.com>
Subject: RE: I have managed to pickle my RAID 1 install after a disk crash
Date: Sun, 19 Sep 2004 15:45:02 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <NDBBJAGHALMCJCFDHBILAELGEOAA.jonathan@bakerbates.com>
References: <414D92CA.2060903@netcetera-solutions.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <414D92CA.2060903@netcetera-solutions.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org
> [mailto:linux-raid-owner@vger.kernel.org]On Behalf Of Dave Dmytriw -
> NetCetera
> Sent: 19 September 2004 15:08
> To: linux-raid@vger.kernel.org
> Subject: I have managed to pickle my RAID 1 install after a disk crash
>
>
> Hi,
>
> I recently had the mis-fortune of a disk failure, luckily the disk was
> part of a RAID1 setup, so nothing was lost - yet...I should mention that
> I am mirroring /boot/, swap and / , and am using mdadm.
>
> I had thought that I had setup grub correctlly to allow booting off of
> either disk, but did not test it - my bad.

Although it's not any help now, when/if you do get back to the right config,
I would use lilo. I tried many times to get grub to work on a RAID 1 config
the same as yours (i.e. with /boot mirrored as well) but could not get it to
boot from only one disk. Lilo did it no problem though.

Jonathan


