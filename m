From: Tim Small <tim@buttersideup.com>
Subject: Re: Q: RAID-1 w/2x160GB, ReiserFS, Debian "woody", homebrew 2.4.25
 kernel
Date: Wed, 04 Aug 2004 13:32:18 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4110D752.80506@buttersideup.com>
References: <Pine.LNX.4.44.0408041423480.7382-100000@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0408041423480.7382-100000@uplift.swm.pp.se>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mikael Abrahamsson wrote:

> I have never tried to boot off of a 3ware raid, but to Linux it looks 
> like
>
>a scsi drive so I would imagine that it should work well. Someone else who 
>has actually done this for real is probably better suited to answer.
>  
>
Yes, this works.

>I never use software raid for the partitions that need to be present at 
>boot, since I have had total nightmares with root mirroring on other OSes 
>(Solaris and DEC OSF), and I feel that backups of those partitions are 
>better than the problems one might run into with software root mirroring.
>  
>
I've had success with booting Linux from software RAID (including with 
drive failures), and if for some reason the boot loader gets in a knot, 
you can always use a grub floppy (since Linux software mirror partitions 
look like normal Linux partitions to the boot loader)...

Tim.

