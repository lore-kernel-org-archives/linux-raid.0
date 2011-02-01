From: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
Subject: Re: Kernel 2.6.32-5-amd64 fails to boot.
Date: Tue, 01 Feb 2011 21:43:18 +0100
Message-ID: <4D487066.2010703@grumpydevil.homelinux.org>
References: <9A.25.13137.3DB684D4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <9A.25.13137.3DB684D4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Leslie,



On 02/01/2011 09:23 PM, Leslie Rhorer wrote:
> 	I have been attempting to upgrade a Debian "Squeeze" Linux box from
> 2.6.32-3-amd64 to 2.6.32-5-amd64, but the upgrade is a non-starter.  GRUB2
> comes up just fine, but when I select the new kernel version, a number of
> announcements flash by too fast to seen.  I am not 100% certain, but I
> believe the initrd starts to load OK. Some text flies by far too quickly to
> be seen, but then an error pops up concerning an address space collision of
> some PCI device. Then it shows three errors for RAID devices md1. md2, and
> md3, saying they are already in use. Immediately thereafter the system shows
> errors concerning  the RAID targets being already in use, after which point
> the system complains it can't mount / (md2), /dev, /sys, or /proc (in that
> order) because the sources do not exist (if /dev/md2 does not exist, how can
> it be busy?).  Thereafter, of course, it fails to find init, since / is not
> mounted.  It then tries to run BusyBox, but Busybox complains:
>
> /bin/sh: can't access tty; job control turned off
>
> After that, it attempts to put up an initramfs prompt, but of course with no
> tty access, it just hangs completely.  Not surprisingly, recovery mode
> doesn't boot, either.  It gives a bit more detail in the output, but nothing
> illuminating.  The old kernel (2.6.32-3-amd64) boots just fine.
>    

Can you enable serial console and catch the console output that way?

Cheers

Rudy
> Obviously there is a problem in the initramfs, probably with mdadm, but
> what?  What should I try to manipulate in the initrd so I can find out what
> is failing?
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>    

