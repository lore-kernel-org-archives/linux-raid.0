From: Daniel Pittman <daniel@rimspace.net>
Subject: Re: Autodetection using RAID1 on externa USB2-HDs
Date: Wed, 16 Feb 2005 18:14:52 +1100
Message-ID: <87oeelnfgz.fsf@enki.rimspace.net>
References: <1061567322@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 16 Feb 2005, Clemens Eisserer wrote:
> I am trying to use my external USB2.0 hd for raid1 in my laptop,
> however autodetection does not work and I do not really know - but I
> have at least a theory.
>
> What i did till now:
> 1.) set the partition-type of both partitiuons from 83 (Linux) to fd (Linux
> 	Raid Autodetection)
> 2.) mdadm --create /dev/md0 --level=raid1 --reaid-devices=2 /dev/hda2 /dev/sda1
>
> This works great on creation, I can watch with /proc/mdstat the
> syncing process, but if I reboot the autodetection does not work. I
> can see that linux-raid discovers an raid (on /dev/hda2) but something
> returns "-22" (have forgotten what exactly) - it seems that my
> usb-disc (/dev/sda1) is simply not known at raid-discovery-time. Some
> seconds later I can see that the kernel disvcovers my usb-drive - so I
> think my theory could be right?

Yes.  This is exactly the same problem that others have booting from USB
disk devices (or, at least, running the root filesystem on them.)

> Is there a way to tell the kernel after boot where to find raid-arrays
> and howto handle them. Is that maybe possible with only a /boot
> partition and the reast on a mirrored "/" (root) partition.

There is a way to handle this:

Make sure your kernel boots with an initrd, or similar.

Under Debian, at least, you could pretty trivially graft in a custom
script that loads the USB modules, waits until the USB devices have been
discovered[1], then continues to the bit where it uses mdadm to assemble
the root RAID device.

Season to taste for your own distribution, of course, but I bet that
pretty much all of the standard ones have support for this in some shape
or other.

This also has the advantage that you don't need to rely on the kernel to
do autodetection, that you can do more complex things, and that you can
put some recovery tools onto the initrd as well.

Regards,
        Daniel

Footnotes: 
[1]  Make sure you test with it disconnected at some point, though. :)

-- 
If racial discrimination were genetic, why would so many barriers to
intermarriage have been necessary?
        -- Gloria Steinem

