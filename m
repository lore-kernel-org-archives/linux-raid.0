From: David Dougall <davidd@et.byu.edu>
Subject: Re: No response?
Date: Thu, 20 Jan 2005 12:49:33 -0700 (MST)
Message-ID: <Pine.LNX.4.58.0501201247540.19586@lewis.et.byu.edu>
References: <Pine.LNX.4.58.0501201052240.19586@lewis.et.byu.edu>
 <Pine.LNX.4.56.0501201805070.12589@lion.drogon.net> <41EFFA53.3030809@mvista.com>
 <Pine.LNX.4.56.0501201933180.12589@lion.drogon.net> <41F00985.3090105@mvista.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41F00985.3090105@mvista.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Bellon <mbellon@mvista.com>
Cc: Gordon Henderson <gordon@drogon.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

It would certainly be easier for me if it were 2.4.26.  The other 2
patches I have to apply have only been released for 2.4.26 and 2.4.25-pre9
or something like that.  If it is better for everyone else to do 2.4.29, I
can just backport it to my kernel.
Thanks
--David Dougall


On Thu, 20 Jan 2005, Mark Bellon wrote:

> Gordon Henderson wrote:
>
> >On Thu, 20 Jan 2005, Mark Bellon wrote:
> >
> >
> >
> >>I've seen this too. The worst case can actually last for over 2 minutes.
> >>
> >>We've been running with a patch to the RAID 1 driver that handles this
> >>so critical applications do not hang for too long. Basically it uses
> >>timers in the RAID 1 driver to force the disk to be treated as actually
> >>having failed if it doesn't respond within a reasonable time (tunable
> >>but usually ~3 seconds). It then handles the I/O requests coming back
> >>async. and does the clean up.
> >>
> >>
> >
> >This is intersting, but make it an option (kernel compile, sysctl,
> >etc.)... I have a small home server/firewall that I run with the disks
> >spun down (noflushd) and spinning up a disk sometimes takes 8 seconds -
> >it's a RAID-1 set and seems to cope OK with the disks spinning down & up
> >again as required...
> >
> >
> The current patch has config options to adjust the
> Non-Responsive-Disk-Timer. A zero specified no timeout and a non-zero
> value is the timeout in seconds.
>
> Let me pull a 2.4.26 kernel source and see how fast I can work up a
> patch. Or would it better to generate it against 2.4.29?
>
> mark
>
> >Gordon
> >
> >
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
