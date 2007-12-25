From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Raid over 48 disks
Date: Tue, 25 Dec 2007 16:08:14 -0500
Message-ID: <4771713E.2020303@tmr.com>
References: <00EF99B2-3BCC-4D75-BC75-8F256B0A2476@gmail.com>	<18280.11620.381726.737353@notabene.brown> <18289.16006.856691.862471@base.ty.sabi.co.UK>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18289.16006.856691.862471@base.ty.sabi.co.UK>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg_lxra@lxra.for.sabi.co.UK>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Peter Grandi wrote:
>>>> On Wed, 19 Dec 2007 07:28:20 +1100, Neil Brown
>>>> <neilb@suse.de> said:
>>>>         
>
> [ ... what to do with 48 drive Sun Thumpers ... ]
>
> neilb> I wouldn't create a raid5 or raid6 on all 48 devices.
> neilb> RAID5 only survives a single device failure and with that
> neilb> many devices, the chance of a second failure before you
> neilb> recover becomes appreciable.
>
> That's just one of the many problems, other are:
>
> * If a drive fails, rebuild traffic is going to hit hard, with
>   reading in parallel 47 blocks to compute a new 48th.
>
> * With a parity strip length of 48 it will be that much harder
>   to avoid read-modify before write, as it will be avoidable
>   only for writes of at least 48 blocks aligned on 48 block
>   boundaries. And reading 47 blocks to write one is going to be
>   quite painful.
>
> [ ... ]
>
> neilb> RAID10 would be a good option if you are happy wit 24
> neilb> drives worth of space. [ ... ]
>
> That sounds like the only feasible option (except for the 3
> drive case in most cases). Parity RAID does not scale much
> beyond 3-4 drives.
>
> neilb> Alternately, 8 6drive RAID5s or 6 8raid RAID6s, and use
> neilb> RAID0 to combine them together. This would give you
> neilb> adequate reliability and performance and still a large
> neilb> amount of storage space.
>
> That sounds optimistic to me: the reason to do a RAID50 of
> 8x(5+1) can only be to have a single filesystem, else one could
> have 8 distinct filesystems each with a subtree of the whole.
> With a single filesystem the failure of any one of the 8 RAID5
> components of the RAID0 will cause the loss of the whole lot.
>
> So in the 47+1 case a loss of any two drives would lead to
> complete loss; in the 8x(5+1) case only a loss of two drives in
> the same RAID5 will.
>
> It does not sound like a great improvement to me (especially
> considering the thoroughly inane practice of building arrays out
> of disks of the same make and model taken out of the same box).
>   

Quality control just isn't that good that "same box" make a big 
difference, assuming that you have an appropriate number of hot spares 
online. Note that I said "big difference," is there some clustering of 
failures? Some, but damn little. A few years ago I was working with 
multiple 6TB machines and 20+ 1TB machines, all using small, fast, 
drives in RAID5E. I can't remember a case where a drive failed before 
rebuild was complete, and only one or two where there was a failure to 
degraded mode before the hot spare was replaced.

That said, RAID5E typically can rebuild a lot faster than a typical hot 
spare as a unit drive, at least for any given impact on performance. 
This undoubtedly reduce our exposure time.
> There are also modest improvements in the RMW strip size and in
> the cost of a rebuild after a single drive loss. Probably the
> reduction in the RMW strip size is the best improvement.
>
> Anyhow, let's assume 0.5TB drives; with a 47+1 we get a single
> 23.5TB filesystem, and with 8*(5+1) we get a 20TB filesystem.
> With current filesystem technology either size is worrying, for
> example as to time needed for an 'fsck'.
>   

Given that someone is putting a typical filesystem full of small files 
on a big raid, I agree. But fsck with large files is pretty fast on a 
given filesystem (200GB files on a 6TB ext3, for instance), due to the 
small number of inodes in play. While the bitmap resolution is a factor, 
it's pretty linear, fsck with lots of files gets really slow. And let's 
face it, the objective of raid is to avoid doing that fsck in the first 
place ;-)

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


