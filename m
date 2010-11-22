From: Neil Brown <neilb@suse.de>
Subject: Re: Boot from degraded MD array
Date: Mon, 22 Nov 2010 15:13:11 +1100
Message-ID: <20101122151311.3070d27f@notabene.brown>
References: <9181E99F41C081478B455A70FC1D01CB0A4C3E6B@inbmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <9181E99F41C081478B455A70FC1D01CB0A4C3E6B@inbmail01.lsi.com>
Sender: linux-raid-owner@vger.kernel.org
To: "G, Sushma" <Sushma.G@lsi.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 18 Nov 2010 20:55:38 +0530
"G, Sushma" <Sushma.G@lsi.com> wrote:

> Hi,
> 
> I wanted to know if there is a way to activate a degraded array be default.

Yes, degraded arrays are activated by default, except for RAID5/RAID6 if it
is also dirty.


> 
>  In a scenario where OS is installed on a MD R1 array, with no spares configured, if a physical drive fails is there a way to still boot in to OS, without having to configure a hot spare?

That depends.
 The bios needs to read a boot sector from somewhere.  If it can try one
 device and on failure try the next, then it might work when the first device
 is failing.  

 Once your bios has loaded the boot block, the boot loaded needs to find the
 kernel.  This might be lilo or grub.  I think they will try to read from the
 same device that the bios read from, but I am far from certain.
 But if the bios succeeds in reading the boot sector, but the boot loader
 doesn't manage to read the kernel, I really don't know if it will try the
 other device.  This really depends on grub/lilo so you need to look into the
 documentation and configuration of those.

 Once the kernel is running, md will have no trouble starting a degraded /.

> Also, is R5 different in any way, in the same scenario mentioned above ( R5 in degraded mode)?"
> 

You cannot use RAID5 for /boot unless your bios understands it.  Some intel
mother boards can boot off 'imsm' raid5, which mdadm is able to work with.

If /boot is a RAID1, and / is RAID5, then they will be no trouble assembling
the RAID5 as long as it is not both dirty and degraded.


> Setup: 
> Create a R1 using 2 sata disks, using mdadm with SLES 11 SP1 Operating system.
> Once OS is installed, shut down the system and fail a drive.  now try to boot up the OS.
> 
> OS boot fails because the RAID is inactive as the VD is degraded.

What exactly fails?  Maybe a photo of the monitor show where it stops
working...

And what exactly do you mean byb "fail a drive"?? Do you mean that you
unplug it?

NeilBrown


> 
> 
> Regards,
> 
> Sushma Govind
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

