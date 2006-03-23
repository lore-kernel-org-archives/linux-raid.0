From: Dan Christensen <jdc@uwo.ca>
Subject: Re: naming of md devices
Date: Wed, 22 Mar 2006 21:43:28 -0500
Message-ID: <87fyl9swxb.fsf@uwo.ca>
References: <87slpav0p6.fsf@uwo.ca> <87ek0uc595.fsf@hades.wkstn.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dan Christensen writes:

> I currently use kernel autodetection of my raid devices.  I'm finding
> that if I use a stock Debian kernel versus a self-compiled kernel
> (2.6.15.6), the arrays md0 and md1 are switched, which creates a
> problem mounting my root filesystem.
> 
> Is there a way to make the names consistent?
>
> I'm happy to get rid of kernel autodetection and instead use
> mdadm.conf.  Is this just a matter of changing the partition types?
> Or a kernel boot parameter?  

To answer myself, the boot parameter raid=noautodetect is supposed
to turn off autodetection.  However, it doesn't seem to have an
effect with Debian's 2.6.16 kernel.  It does disable autodetection
for my self-compiled kernel, but since that kernel has no initrd or
initramfs, it gets stuck at that point.  [If I understand correctly,
you can't use mdadm for building the array without an initrd/ramfs.]

I also tried putting root=LABEL=/ on my boot command line.  Debian's
kernel seemed to understand this but gave:

Begin: Waiting for root filesystem...
Done.
Done.
Begin: Mounting root filesystem
...kernel autodetection of raid seemed to happen here...
ALERT /dev/disk/by_label// does not exist

> Will the Debian kernel/initramfs fall
> back to using mdadm to build the arrays?

dean gaudet <dean@arctic.org> writes:

> On Thu, 23 Mar 2006, Nix wrote:
>
>> Last I heard the Debian initramfs constructs RAID arrays by explicitly
>> specifying the devices that make them up. This is, um, a bad idea:
>> the first time a disk fails or your kernel renumbers them you're
>> in *trouble*.
>
> yaird seems to dtrt ... at least in unstable

I might try this, but I'm still stuck without an easy way to turn
off auto-detection.

> the above is on unstable... i don't use stable (and stable definitely does 
> the wrong thing -- 
> <http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=338200>).

That bug is against initrd-tools, which is a different package I
believe.

For now, I've just put root=/dev/md1 on the Debian kernel boot line,
and root=/dev/md0 on my self-compiled boot line.


BUT, my self-compiled kernel is now failing to bring up the arrays!  I
didn't change anything on the arrays or on this kernel's boot line,
and I have not turned off kernel auto-detection, so I have no idea why
there is a problem.  Unfortunately, I don't have a serial console, and
the kernel panics so I can't scroll back to see the relevant part of
the screen.  My self-compiled kernel has everything needed for
my root filesystem compiled in, so I avoided needing an initramfs.

If I'm able to get my tuner card, etc working with Debian's kernel,
then I won't need my self-compiled kernel anymore, but it's
disconcerting that I now can't boot a kernel that worked fine a few
hours ago...  Any ideas what could have happened?

Thanks for the help so far!

Dan

