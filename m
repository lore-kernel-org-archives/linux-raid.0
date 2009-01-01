From: Luca Berra <bluca@comedia.it>
Subject: Re: 2.6.28: md0: unknown partition table
Date: Thu, 1 Jan 2009 10:26:27 +0100
Message-ID: <20090101092627.GA32138@maude.comedia.it>
References: <alpine.DEB.1.10.0812300610190.11356@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0812300610190.11356@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Dec 30, 2008 at 07:25:08AM -0500, Justin Piszcz wrote:
> Had a question about the new option in 2.6.28:
>
> [    7.655297] usb 6-2: configuration #1 chosen from 1 choice
> [    7.663280] hub 6-2:1.0: USB hub found
> [    7.666533] hub 6-2:1.0: 3 ports detected
> [    7.698008] udev: renamed network interface eth0_rename to eth1
> [    7.824538]  md1:<6> md0: unknown partition table
> [    7.835978] [    7.950237] usb 6-2.1: new full speed USB device using 
> uhci_hcd and address 3
> [    8.081335] usb 6-2.1: configuration #1 chosen from 1 choice
>
> See line:
> [    7.824538]  md1:<6> md0: unknown partition table
>
> This is swap, I do not recall seeing this error in kernels < 2.6.28, should
> the kernel not scan for partitions on a swap-based parititon? [1]

this is probably due to the fact that now /dev/md* are partitionable.

> [2] partitions for mdadm/raid are usually md0_p1 md1_p2 why would it scan for
> partitions on /dev/md0, /dev/md1, /dev/md2 as they are 'block devices' e.g.,
> similar to /dev/sda, /dev/sdb, /dev/sdc
>
> I do have the option checked off:
> [*]     Autodetect RAID arrays during kernel boot
>
> As I compile everything in statically, no modules are used.
>
> If I disable that option, would my system still boot/that would get rid of 
> the error/so it does not try to scan for partitions on swap?
no
if you want to get rid of that you can disable kernel partition
detection, but you have to do it manually in initrd/init scripts/udev
rules then(*)

(*) i still firmly believe that partition detection does not belong to
the kernel any more than raid/lvm.

-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
