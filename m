From: Brent Walsh <blinux_adm@yahoo.com>
Subject: Re: endianness of Linux kernel RAID
Date: Mon, 8 Aug 2005 21:49:03 -0700 (PDT)
Message-ID: <20050809044903.97593.qmail@web35308.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:

>I decided to try it anyway...
>
>The following patch, when applied to
>mdadm-2.0-devel-3 (Recently
>released) should allow:
>
>  mdadm --examine --metadata=0.swap /dev/sda1
>
>which will show the superblock with bytes swapped.
>If that looks right for all devices, then
>
>  mdadm --assemble /dev/mdX
>--update=byteorder /dev/sda1 /dev/sdb1 ...
>
>
>will assemble the array after swapping the byte
>order on all devices. Once it has been assembled
>this way, the superblocks will have the correct
>byte order, and in future the array can be
>assembled in the normal way.

I have a PowerPC based NAS device that was damaged by
a recent a brownout.  The drives in the array are
fine, but the device's firmware was corrupted.  My
first attempt to assemble the array on my x86 system
failed due to the endian differences.  After applying
this patch, the mdadm examine command worked
perfectly.  As of yet, I have not attempted to update
the superblocks.  I would like to leave the original
superblocks intact so that I can reinstall the drives
in my NAS device when it is repaired.  Is it possible
to assemble the array without overwriting the
superblocks?

-Brent



		
____________________________________________________
Start your day with Yahoo! - make it your home page 
http://www.yahoo.com/r/hs 
 
