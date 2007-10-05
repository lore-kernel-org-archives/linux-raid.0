From: Andrew Clayton <andrew@digital-domain.net>
Subject: Re: RAID 5 performance issue.
Date: Fri, 5 Oct 2007 11:57:19 +0100
Message-ID: <20071005115719.4a71ab89@zeus.pccl.info>
References: <20071003105321.06943824@zeus.pccl.info>
	<Pine.LNX.4.64.0710031243080.8612@p34.internal.lan>
	<20071003211910.439ded54@alpha.digital-domain.net>
	<72dbd3150710031336s331782c3yd0ac7ceda4e81774@mail.gmail.com>
	<20071004150831.6edbf926@zeus.pccl.info>
	<Pine.LNX.4.64.0710041009150.8275@p34.internal.lan>
	<Pine.LNX.4.64.0710041009530.8275@p34.internal.lan>
	<20071004154441.31addcfe@zeus.pccl.info>
	<Pine.LNX.4.64.0710041219240.25506@p34.internal.lan>
	<20071004192653.25eb333b@alpha.digital-domain.net>
	<Pine.LNX.4.64.0710050621350.8433@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0710050621350.8433@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: David Rees <drees76@gmail.com>, Andrew Clayton <andrew@pccl.info>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 5 Oct 2007 06:25:20 -0400 (EDT), Justin Piszcz wrote:


> So you have 3 SATA 1 disks:

Yeah, 3 of them in the array, there is a fourth standalone disk which
contains the root fs from which the system boots..

> http://digital-domain.net/kernel/sw-raid5-issue/mdadm-D
> 
> Do you compile your own kernel or use the distribution's kernel?

Compile my own.
 
> What does cat /proc/interrupts say? This is important to see if your
> disk controller(s) are sharing IRQs with other devices.

$ cat /proc/interrupts 
           CPU0       CPU1       
  0:     132052  249369403   IO-APIC-edge      timer
  1:        202         52   IO-APIC-edge      i8042
  8:          0          1   IO-APIC-edge      rtc
  9:          0          0   IO-APIC-fasteoi   acpi
 14:      11483        172   IO-APIC-edge      ide0
 16:   18041195    4798850   IO-APIC-fasteoi   sata_sil24
 18:   86068930         27   IO-APIC-fasteoi   eth0
 19:   16127662    2138177   IO-APIC-fasteoi   sata_sil, ohci_hcd:usb1, ohci_hcd:usb2
NMI:          0          0 
LOC:  249368914  249368949 
ERR:          0


sata_sil24 contains the raid array, sata_sil the root fs disk

> 
> Also note with only 3 disks in a RAID-5 you will not get stellar 
> performance, but regardless, it should not be 'hanging' as you have 
> mentioned.  Just out of sheer curiosity have you tried the AS
> scheduler? CFQ is supposed to be better for multi-user performance
> but I would be highly interested if you used the AS scheduler-- would
> that change the 'hanging' problem you are noticing?  I would give it
> a shot, also try the deadline and noop.

I did try them briefly. I'll have another go.

> You probably want to keep the nr_requessts to 128, the
> stripe_cache_size to 8mb.  The stripe size of 256k is probably
> optimal.

OK.

> Did you also re-mount the XFS partition with the default mount
> options (or just take the sunit and swidth)?

The /etc/fstab entry for the raid array is currently:

 /dev/md0                /home                   xfs
noatime,logbufs=8 1 2

and mount says

/dev/md0 on /home type xfs (rw,noatime,logbufs=8)

and /proc/mounts

/dev/md0 /home xfs rw,noatime,logbufs=8,sunit=512,swidth=1024 0 0

So I guess mount or the kernel is setting the sunit and swidth values.
 
> Justin.


Andrew
