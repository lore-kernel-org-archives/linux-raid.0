From: Jurriaan <thunder7@xs4all.nl>
Subject: Re: Fedora 2.0 - raid1 not working
Date: Tue, 9 Nov 2004 20:22:19 +0100
Message-ID: <20041109192219.GA5822@middle.of.nowhere>
References: <419115A5.4050905@skybuilders.com>
Reply-To: Jurriaan <thunder7@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <419115A5.4050905@skybuilders.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jesse Burkhardt <jesse@skybuilders.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jesse Burkhardt <jesse@skybuilders.com>
Date: Tue, Nov 09, 2004 at 02:08:22PM -0500
> After the installation process, I found that I could boot with both 
> physical drives online and only one of the two physical drives when 
> booting in a single drive (failure simulation) mode.
> 

I take it this is your question? And do I read correctly you mean that
you cannot boot if you disconnect drive A, but can boot if you
disconnect drive B?

In that case, could you please give some more details on 'could boot'.
Is this a problem with your bootloader (lilo, grub or other?) or with
the kernel?

For the record: here's my /boot/grub/menu.lst, which allows me to boot
from both drives of my mirrored raid-1 root partition.

timeout 15
default 0
color white/blue white/red
fallback 1

title  GNU/Linux (Debian working 2.6.9-mm1 kernel /dev/hda (part of raid-1 system))
root (hd0,0)
kernel /boot/vmlinuz-269mm1 root=/dev/md3 video=radeonfb:1600x1200-32@85 softrepeat=1

title  GNU/Linux (Debian working 2.6.9-mm1 kernel /dev/hdb (part of raid-1 system))
root (hd5,0)
kernel /boot/vmlinuz-269mm1 root=/dev/md3 video=radeonfb:1600x1200-32@85 softrepeat=1 floppy=no_acpi

title Memtest86
root (hd0,0)
kernel /boot/memtest86.bin

title Floppy
root (fd0)
chainloader +1

Good luck,
Jurriaan
-- 
"Evayne told you this."
"Evayne," he said softly, "has forced me to bear witness to much in my life."
	Michelle West - Sea of Sorrows
Debian (Unstable) GNU/Linux 2.6.9-mm1 2x6078 bogomips load 0.34
