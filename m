From: Andrew Burgess <aab@cichlid.com>
Subject: Re: Moron Destroyed RAID6 Array Superblocks
Date: Sun, 8 Apr 2007 08:21:58 -0700
Message-ID: <200704081521.l38FLwGU017164@cichlid.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: aaron@darkpixel.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>After reading through the linux-raid archives I have been lead to
>believe that I can recover my array by doing a --create and listing the
>7 drives in the exact order I originally created them in.  Is this correct?

>If so, the kernel upgrade managed to shuffle the drive names around...is
>there any way I can figure out what order they should be in?

If you know the old order just boot the old kernel and recreate there

If you are using kernel rpms, you always want to 'install' new kernels
and not 'upgrade', that keeps both the old and new kernel available.

Otherwise, if you pick just 5 for the 7 drives from a raid 6 array
it seems to me you have 5 factorial combinations = 120. You could write
a script that tries them all and then tests by trying a read-only mount?

Good luck. I mashed a 3.5 TB array once by rerunning the lvm
creation which zeros the first chunk of the resulting device. I was
used to mdadm not hurting user data when creating. Grrr.

BTW when you test recreate the array make sure you dont start syncing, thats
another reason to just use 5 drives.

HTH

