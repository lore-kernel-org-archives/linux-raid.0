From: Nix <nix@esperi.org.uk>
Subject: Re: naming of md devices
Date: Sat, 25 Mar 2006 01:52:53 +0000
Message-ID: <87hd5nnvd6.fsf@hades.wkstn.nix>
References: <87slpav0p6.fsf@uwo.ca> <87ek0uc595.fsf@hades.wkstn.nix>
	<87fyl9swxb.fsf@uwo.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87fyl9swxb.fsf@uwo.ca> (Dan Christensen's message of "23 Mar
 2006 02:44:19 -0000")
Sender: linux-raid-owner@vger.kernel.org
To: Dan Christensen <jdc@uwo.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 23 Mar 2006, Dan Christensen moaned:
> To answer myself, the boot parameter raid=noautodetect is supposed
> to turn off autodetection.  However, it doesn't seem to have an
> effect with Debian's 2.6.16 kernel.  It does disable autodetection
> for my self-compiled kernel, but since that kernel has no initrd or
> initramfs, it gets stuck at that point.  [If I understand correctly,
> you can't use mdadm for building the array without an initrd/ramfs.]

That's true if your root filesystem is on RAID.

> I also tried putting root=LABEL=/ on my boot command line.  Debian's
> kernel seemed to understand this but gave:
> 
> Begin: Waiting for root filesystem...
> Done.
> Done.
> Begin: Mounting root filesystem
> ...kernel autodetection of raid seemed to happen here...
> ALERT /dev/disk/by_label// does not exist

Ah, welcome to the udev problems. Look at the Debian kernel-maint list
at lists.debian.org and marvel at the trouble they're having because
they're using udev on their initramfs. I'm glad I used mdev instead :)

>> Will the Debian kernel/initramfs fall
>> back to using mdadm to build the arrays?

`Fall back to'? If autodetection is turned off, it's not a fallback,
it's the common case.

>> the above is on unstable... i don't use stable (and stable definitely does 
>> the wrong thing -- 
>> <http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=338200>).
> 
> That bug is against initrd-tools, which is a different package I
> believe.

Yes, it is unmaintained.

> BUT, my self-compiled kernel is now failing to bring up the arrays!  I
> didn't change anything on the arrays or on this kernel's boot line,
> and I have not turned off kernel auto-detection, so I have no idea why
> there is a problem.  Unfortunately, I don't have a serial console, and
> the kernel panics so I can't scroll back to see the relevant part of
> the screen.  My self-compiled kernel has everything needed for
> my root filesystem compiled in, so I avoided needing an initramfs.

Without boot messages it's very hard to say what's going on. If you have
another machine, you could try booting with the messages going over a
serial console...

-- 
`Come now, you should know that whenever you plan the duration of your
 unplanned downtime, you should add in padding for random management
 freakouts.'
