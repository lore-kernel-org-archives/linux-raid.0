From: Greg KH <gregkh@suse.de>
Subject: Re: libata hotplug and md raid?
Date: Thu, 14 Sep 2006 16:23:04 -0700
Message-ID: <20060914232304.GB2616@suse.de>
References: <c384c5ea0609130311t4005e5aam153251fc6bbbdfb8@mail.gmail.com> <4507E2A9.7070306@emc.com> <4507E641.7090508@gmail.com> <c384c5ea0609140524ofed0dd8v6f1b89a6b4d67f75@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <c384c5ea0609140524ofed0dd8v6f1b89a6b4d67f75@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leon Woestenberg <leon.woestenberg@gmail.com>
Cc: Tejun Heo <htejun@gmail.com>, Ric Wheeler <ric@emc.com>, linux-raid@vger.kernel.org, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Sep 14, 2006 at 02:24:45PM +0200, Leon Woestenberg wrote:
> Hello all,
> 
> On 9/13/06, Tejun Heo <htejun@gmail.com> wrote:
> >Ric Wheeler wrote:
> >> Leon Woestenberg wrote:
> >>> In short, I use ext3 over /dev/md0 over 4 SATA drives /dev/sd[a-d]
> >>> each driven by libata ahci. I unplug then replug the drive that is
> >>> rebuilding in RAID-5.
> >>>
> >>> When I unplug a drive, /dev/sda is removed, hotplug seems to work to
> >>> the point where proc/mdstat shows the drive failed, but not removed.
> >
> >Yeap, that sounds about right.
> >
> >>> Every other notion of the drive (in kernel and udev /dev namespace)
> >>> seems to be gone after unplugging. I cannot manually removed the drive
> >>> using mdadm, because it tells me the drive does not exist.
> >
> >I see.  That's a problem.  Can you use /dev/.static/dev/sda instead?  If
> >you can't find those static nodes, just create one w/ 'mknod
> >my-static-sda b 8 0' and use it.
> >
> 
> I did further testing of the ideas set out in this thread.
> 
> Although I can use (1) static device nodes, or (2) persistent naming
> with the proper udev rules, each has its own kind of problems with md.
> 
> As long as the kernel announces drives as disappeared but md still
> holds a lock, replugging drives will map to other major:minor number
> no matter what I try in userspace.
> 
> Static device nodes will therefore not help me select the drive that
> was unplugged/plugged per se.
> 
> Persistent naming using udev works OK (I used /dev/bay0 through
> /dev/bay3 to pinpoint the drive bays) but these disappear upon
> unplugging, while md keeps a lock to the major:minor, so replugging
> will move it to different major:minor numbers.
> 
> So the question remains: How will hotplug and md work together?
> 
> How does md and hotplug work together for current hotplug devices?

The answer to both of these questions is, "not very well."  Me and Kay
have been talking with Neil Brown about this and he agrees that it needs
to be fixed up.  That md device needs to have proper lifetime rules and
go away proper.  Hopefully it gets fixed soon.

thanks,

greg k-h
