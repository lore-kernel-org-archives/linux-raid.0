From: Nix <nix@esperi.org.uk>
Subject: Re: naming of md devices
Date: Thu, 23 Mar 2006 01:35:34 +0000
Message-ID: <87ek0uc595.fsf@hades.wkstn.nix>
References: <87slpav0p6.fsf@uwo.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87slpav0p6.fsf@uwo.ca> (Dan Christensen's message of "22 Mar
 2006 17:41:11 -0000")
Sender: linux-raid-owner@vger.kernel.org
To: Dan Christensen <jdc@uwo.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 22 Mar 2006, Dan Christensen prattled cheerily:
> I currently use kernel autodetection of my raid devices.  I'm finding
> that if I use a stock Debian kernel versus a self-compiled kernel
> (2.6.15.6), the arrays md0 and md1 are switched, which creates a
> problem mounting my root filesystem.
> 
> Is there a way to make the names consistent?

Well, you could stack LVM atop it ;)

but yes, there is. THis is my mdadm.conf:

DEVICE partitions
ARRAY /dev/md0 UUID=3a51b74f:8a759fe7:8520304c:3adbceb1
ARRAY /dev/md1 UUID=a5a6cad4:2c7fdc07:88a409b9:192ed3bf
ARRAY /dev/md2 UUID=fe44916d:a1098576:8007fb81:2ee33b5a

In fact I don't care what's mounted where because all of these that are
necessary for booting are an LVM volume group, and vgscan takes care
of everything: but if you arrange to use the mdadm.conf, you're safe.

(You can use the RAID array name, as well, but if you don't have
a name I'm not sure if you can assign a new one, while every array
always has a UUID.)

I'm not sure if there's a way to specify this on the kernel command line
when using kernel autodetection: I've never used it. (Neil? Anyone?)

> I'm happy to get rid of kernel autodetection and instead use
> mdadm.conf.  Is this just a matter of changing the partition types?
> Or a kernel boot parameter?  Will the Debian kernel/initramfs fall
> back to using mdadm to build the arrays?

Last I heard the Debian initramfs constructs RAID arrays by explicitly
specifying the devices that make them up. This is, um, a bad idea:
the first time a disk fails or your kernel renumbers them you're
in *trouble*.

-- 
`Come now, you should know that whenever you plan the duration of your
 unplanned downtime, you should add in padding for random management
 freakouts.'
