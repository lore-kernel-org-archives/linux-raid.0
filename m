From: Fredrik Pettersson <freppe@deimos.nu>
Subject: Re: Draft Mirrored Linux Mini How-to
Date: Fri, 7 Aug 2009 10:10:39 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0908070949540.21358@deimos.nu>
References: <4A78292A.5000607@in.ibm.com>  <1249421223.18245.36.camel@pasglop>
 <4A794E26.8080207@in.ibm.com>  <1249465934.18245.54.camel@pasglop>
 <4A7ADBB1.3050906@in.ibm.com> <1249595469.24311.5.camel@pasglop>
 <4A7B708F.4050406@uga.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A7B708F.4050406@uga.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Harold Pritchett <harold@uga.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Thu, 6 Aug 2009, Harold Pritchett wrote:

...

> In the event of a disk failure, follow the below procedure.
>
> 1.  Shutdown the system and remove the failed drive.
>
> 2.  If the second (non boot) drive is the failing drive, skip to step 9 
> below.
>
> 3.  Move the second (non boot) drive to the boot drive position.
>
> 4.  Boot from the linux rescue CD/DVD and start the system, no network.
>
> 5.  Use the "chroot /mnt/sysimage" command to mount the system.
>
> 6.  Run the command "/sbin/grub-install /dev/sda" or whatever your drive is
>     to write a boot image into the MBR of the new boot drive.

I think you may be making things a bit more complicated then they need to 
be.

Would it not make sense to just install grub on both drives right from the 
start (so on both /dev/sda and /dev/sdb)? If you then configure the bios 
to boot from sda first and if that fails boot from sdb then the system 
should be able to keep on rebooting etc. even if one drive has failed. It 
also means there is no need to move disks around or boot from a rescue CD 
to recover from a failed drive, just shut down, replace drive, reboot, 
partition, mdadm --add and finally install grub on the newly replaced 
drive.

In fact I'm pretty sure I've seen it described like that in other howtos, 
a quick google found this guy (using lilo but the teory is the same):
http://www.willert.dk/geek/raid.html

This one is a bit old, but the theory is the same there as well and it is 
using grub:
http://www.somedec.com/downloads/howto-bootable-linux-raid1.html

Other than that I don't see any obvious problems with your description of 
the process.

BR,

/Fredrk Pettersson
