From: Jon Lewis <jlewis@lewis.org>
Subject: Re: md: could not bd_claim hde1
Date: Sun, 11 Oct 2009 08:55:17 -0400 (EDT)
Message-ID: <Pine.LNX.4.61.0910110816130.22812@soloth.lewis.org>
References: <Pine.LNX.4.61.0910102326250.22812@soloth.lewis.org>
 <738ae0e0ab81ff72cc23b359d0011d1c.squirrel@neil.brown.name>
 <Pine.LNX.4.61.0910110051270.22812@soloth.lewis.org> <4AD198E8.2070707@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AD198E8.2070707@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 11 Oct 2009, Michael Tokarev wrote:

>> # cat /proc/mounts
>> rootfs / rootfs rw 0 0
>> /dev/root / ext3 rw 0 0
>
> That's what you get for using rh and their nash ;)
>
> What IS /dev/root?  How does your root device
> is specified in initramfs -- by uuid/label?

lrwxrwxrwx  1 root root 8 Oct  9 23:52 /dev/root -> /dev/md0

title CentOS (2.6.9-34.ELsmp)
         root (hd0,0)
         kernel /boot/vmlinuz-2.6.9-34.ELsmp ro root=/dev/md0
         initrd /boot/initrd-2.6.9-34.ELsmp.img

Pulling apart the initrd, the end of init does these commands

raidautorun /dev/md0
raidautorun /dev/md1
echo Creating root device
mkrootdev /dev/root
umount /sys
echo Mounting root filesystem
mount -o defaults --ro -t ext3 /dev/root /sysroot
mount -t tmpfs --bind /dev /sysroot/dev
echo Switching to new root
switchroot /sysroot
umount /initrd/dev

So, mkrootdev (nash) should be using /dev/md0 as the root fs device.

I finally figured this out though.  The drives are on a Promise fast track 
controller, but we don't use its softraid feature...we only use it as 
additional PATA ports.  Apparently dmraid decided otherwise and had 
activated the devices.  I was able to unload dm_raid, but dm_mod was "in 
use" I suspect by the two devices.  dmraid -a n fixed that, and the 
devices were free again and are going back into sync.

----------------------------------------------------------------------
  Jon Lewis                   |  I route
  Senior Network Engineer     |  therefore you are
  Atlantic Net                |
_________ http://www.lewis.org/~jlewis/pgp for PGP public key_________
