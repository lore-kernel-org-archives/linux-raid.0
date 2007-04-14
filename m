From: "Aaron C. de Bruyn" <aaron@darkpixel.com>
Subject: Re: Moron Destroyed RAID6 Array Superblocks
Date: Fri, 13 Apr 2007 23:42:03 -0700
Message-ID: <1176532924.7325.12.camel@localhost.localdomain>
References: <200704081521.l38FLwGU017164@cichlid.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200704081521.l38FLwGU017164@cichlid.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Burgess <aab@cichlid.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If the array consisted of 7 drives, two of them would be parity and I'd
need to leave them out of the array in order to avoid resyncing.

Would I need to specify them as 'missing' so the drives are in the
correct order?

For example
mdadm --raid-devices=7 --level=6 --foo /dev/md0 /dev/sda1 /dev/sdc1
missing /dev/sdb1 /dev/sdg1 missing /dev/sdh1

Or alternatively with the --assume-clean switch, should I specify all 7
drives and see if it mounts?

-A


On Sun, 2007-04-08 at 08:21 -0700, Andrew Burgess wrote:
> >After reading through the linux-raid archives I have been lead to
> >believe that I can recover my array by doing a --create and listing the
> >7 drives in the exact order I originally created them in.  Is this correct?
> 
> >If so, the kernel upgrade managed to shuffle the drive names around...is
> >there any way I can figure out what order they should be in?
> 
> If you know the old order just boot the old kernel and recreate there
> 
> If you are using kernel rpms, you always want to 'install' new kernels
> and not 'upgrade', that keeps both the old and new kernel available.
> 
> Otherwise, if you pick just 5 for the 7 drives from a raid 6 array
> it seems to me you have 5 factorial combinations = 120. You could write
> a script that tries them all and then tests by trying a read-only mount?
> 
> Good luck. I mashed a 3.5 TB array once by rerunning the lvm
> creation which zeros the first chunk of the resulting device. I was
> used to mdadm not hurting user data when creating. Grrr.
> 
> BTW when you test recreate the array make sure you dont start syncing, thats
> another reason to just use 5 drives.
> 
> HTH
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

