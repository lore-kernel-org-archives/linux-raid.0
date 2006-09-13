From: "Leon Woestenberg" <leon.woestenberg@gmail.com>
Subject: Re: libata hotplug and md raid?
Date: Wed, 13 Sep 2006 13:45:05 +0200
Message-ID: <c384c5ea0609130445sfe3bea9w91294c5789b99f65@mail.gmail.com>
References: <c384c5ea0609130311t4005e5aam153251fc6bbbdfb8@mail.gmail.com>
	 <4507E2A9.7070306@emc.com> <4507E641.7090508@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4507E641.7090508@gmail.com>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Ric Wheeler <ric@emc.com>, linux-raid@vger.kernel.org, Greg KH <gregkh@suse.de>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
List-Id: linux-raid.ids

Hello Tejun et al,

On 9/13/06, Tejun Heo <htejun@gmail.com> wrote:
> Ric Wheeler wrote:
> > (Adding Tejun & Greg KH to this thread)
> Adding linux-ide to this thread.
> >
> > Leon Woestenberg wrote:
> [--snip--]
> >> In short, I use ext3 over /dev/md0 over 4 SATA drives /dev/sd[a-d]
> >> each driven by libata ahci. I unplug then replug the drive that is
> >> rebuilding in RAID-5.
> >>
> >> When I unplug a drive, /dev/sda is removed, hotplug seems to work to
> >> the point where proc/mdstat shows the drive failed, but not removed.
>
> Yeap, that sounds about right.
>
I suppose this is 'right', but only if we think of a hot unplugged
device as a failing device.

As in most cases we cannot tell if the hot unplug was intentional or
not (because we see a device disappearing from the phy and we have no
other sensory data available), assuming the drive 'fails' seems
reasonable.

> >> Every other notion of the drive (in kernel and udev /dev namespace)
> >> seems to be gone after unplugging. I cannot manually removed the drive
> >> using mdadm, because it tells me the drive does not exist.
>
> I see.  That's a problem.  Can you use /dev/.static/dev/sda instead?  If
> you can't find those static nodes, just create one w/ 'mknod
> my-static-sda b 8 0' and use it.
>
Yes, that works.

Also, replugging brings back the device as /dev/sda, indicating md is
no longer holding the internal lock.

> Apart from persistent naming Ric mentioned above, the reason why you
> don't get sda back is md is holding the internal device.  It's removed
> from all visible name spaces but md still holds a reference, so the
> device cannot be destroyed.
>
To me, this seems a bug, as the kernel already told everyone else
(userland) that it thinks the device is no longer there.

This contradicts the fact that the kernel itself has dangling references to it.

> So, when a new device comes along, sda is
> occupied by the dead device, and the new one gets the next available
> slot, which happens to be sde in your case.
>
> >> What is the intended behaviour of md in this case?
> >>
> >> Should some user-space application fail-remove a drive as a pre-action
> >> of the unplug event from udev, or should md fully remove the drive
> >> within kernel space??
>
> I'm curious too.  Would it be better for md to listen to hotplug events
> and auto-remove dead devices or is it something which belongs to userland?
>
...also considering race conditions between userland and kernel in that case...

My first thoughts would be that a unplugged device should be handled
differently than a device that failed in other senses, or at least
this should be considered by the kernel developers.

Thanks for the response so far, regards,
-- 
Leon
