From: Matt Thrailkill <xwred1@modestolan.com>
Subject: Re: which is better: promise fasttrak-lite 100 or linux software
	raid?
Date: Tue, 17 Feb 2004 08:37:05 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1077035825.25157.5.camel@stoneburner.xwredwing.net>
References: <LAW11-F70YgChqj8Euz00052987@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <LAW11-F70YgChqj8Euz00052987@hotmail.com>
To: Jeff Gray <jeffgray@hotmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Linux software raid could be faster in some cases.  The raid drivers for
most of those card's in Linux (and even Windows) are less than ideal, in
which case Linux software raid would be more reliable.  And its
certainly more flexible.

Here's a quote from the page of a Gentoo developer regarding cards like
yours:

"What is the difference between a Hardware and Software raid controller?
A Hardware raid controller is always an add-on card, it never comes
distributed on a motherboard. It has a bios which you can enter before
booting into any OS and usually supports 0,1,1+0,and 5 at a minimum. It
has a full CPU onboard that does all raid calculations and I/O, and
displays itself to the OS as configured by the raid controller (i.e. if
you configure a single raid 5, from 3 drives, it will show up by the OS
as one big drive). A Hardware RAID will always be faster than a software
raid, and consumes MUCH less CPU time. A hardware RAID controller can
come optionally with DIMM slots for caching, and possibly a battery
backup for that cache. Hardware raid also limits the possible complexity
of a OS driver because the raid functionality is performed exclusively
in hardware. 

A Software raid controller can be found in both add-on cards, and is
distributed on many motherboards. A software controller may or may not
have a BIOS, but the actual raid functionality is actually implemented
by the driver in the OS. For this reason, you will NEVER find a software
raid controller that can support a bootable RAID5. The OS will be able
to see each drive as a standard hard drive, as it is not
masked/transformed by the controller in any way. On 2.4 kernels, there
was a module that could read many of the SATA controller's BIOSes, set
up a linux software raid as specified by that bios, and create a psuedo
device was accessible just like a hardware raid would be presented. This
'ataraid' module has not been ported to 2.6, and the 2.4 version does
not support SATA controllers, only old PATA software raid controllers.
To put it bluntly, a Software RAID controller is nothing more than a
standard SATA/PATA controller with possibly a bios to store
configuration information, this makes them extremely cheap to
manufacture and is why you see them included on many motherboards."

On Tue, 2004-02-17 at 06:46, Jeff Gray wrote:
> Greetings all. I have been trying to absorb as much information regarding 
> Linux RAID as possible
> in the last couple of days. A couple nights ago I came across a mailing list 
> post which claimed
> that the Promise Fasttrak-lite 100 onboard adapter actually does software 
> RAID and not
> hardware. Is that true? If so then my next question is would it be more 
> beneficial to rely on
> Linux' software RAID implementation instead of the onboard adapter? If 
> anyone here has
> experience with that adapter and Linux RAID could you please shed some light 
> on this and
> perhaps if you've done a comparison then let everyone know just what the 
> performance
> difference is like between the two? Thank you so much.
> 
> Sincerely,
> Jeff Gray
> 
> _________________________________________________________________
> Get a FREE online computer virus scan from McAfee when you click here. 
> http://clinic.mcafee.com/clinic/ibuy/campaign.asp?cid=3963
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

