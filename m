From: Jim Paris <jim@jtan.com>
Subject: Re: RAID-6: help wanted
Date: Fri, 29 Oct 2004 14:15:14 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20041029181514.GA8346@jim.sh>
References: <20041029114823.GA6431@jim.sh> <200410291256.i9TCuIN13270@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200410291256.i9TCuIN13270@www.watkins-home.com>
To: Guy <bugzilla@watkins-home.com>
Cc: 'Neil Brown' <neilb@cse.unsw.edu.au>, "'H. Peter Anvin'" <hpa@zytor.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> I just posted a similar email, but I could not think of a good example, or a
> bad example. :)

It's hard coming up with specific examples.  The RAID5-on-RAID1 is
probably the best one I can think of.  But there are other cases:
let's say I have a small RAID1 partition used for booting my system,
always mounted read-only, and to back it up, I do a "dd" of the entire
/dev/md0 (since exact block positions matter to boot-loaders).  If
uninitialized areas of the disk change every time I read them, my
scripts might conclude that the backups have changed and need to get
burned to CD when nothing actually changed on the array.

> But it does not require any failures to corrupt data.

Right.  Having uninitialized portions appear to randomly change
violates assumptions that other drivers (like raid5) and applications
(like my fictional backup script) make about a block device.

> If you insist to add this feature, please make it an option that
> defaults to sync everything.

For now, to force RAID6 to sync, start it with n-2 disks and add 1,
rather than starting with n-1 disks:

  mdadm --create /dev/md1 -l 6 -n 6 missing missing /dev/hd[gikm]2
  mdadm --add /dev/md1 /dev/hdo2

> You say RAID6 requires 100% of the stripe to be read to modify the strip.
> Is this due to the math of RAID6, or was it done this way because it was
> easier?

I think they can both be updated with read-modify-write:

P' = P + D_n + D_n'
Q' = Q + g^n * D_n + g^n * D_n'

However, the multiplications by g^n for computing Q' could be killer
on your CPU, so it's a tradeoff.  Since we're updating e.g. 128k at
once for a single value of n, it's possible that it could be done 
in such a way that it's not too intensive (or cache-thrashing).
Or perhaps you have so many disks that it really is worth the time
to do the computation rather than read from all of them.  

-jim
