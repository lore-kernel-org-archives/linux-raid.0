From: "James Lee" <james.lee@cantab.net>
Subject: Re: Proposal: non-striping RAID4
Date: Thu, 15 Nov 2007 00:24:54 +0000
Message-ID: <ef2613f30711141624v6279e79cg91afbe8ad32c7b68@mail.gmail.com>
References: <ef2613f30711091657q48e57b63if47a3653a92b28a6@mail.gmail.com>
	 <4737AC62.8000308@tmr.com>
	 <ef2613f30711131548l2ecacd3p9994fdc6ebb6042a@mail.gmail.com>
	 <ef2613f30711131706g31b7b7adm61add82fef3ff94a@mail.gmail.com>
	 <473B81BE.8070309@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <473B81BE.8070309@tmr.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

But creating a 3-drive RAID5 with a missing device for the final two
drives wouldn't give me what I'm looking for, as that array would no
longer be fault-tolerant.  So I think what we'd have on an array of n
differently-sized drives is:
- One n drive RAID5 array.
- One (n-1) drive RAID5 array.
...
- One 2 drive RAID5 array.
- One non-RAIDed single partition.

All of these except for the non-RAIDed partition would then be used as
elements in a linear array (which would tolerate the failure of any
single drive, as each of its constituent arrays does).  This would
leave a single non-RAIDed partition which can be used for anything
else.

Thinking back over it, I think one potential issue might be how resync
works.  If all of the RAID5 arrays become in need of resync at the
same time (which is perfectly likely - e.g. if the system is powered
down abruptly, a drive is replaced, ...) will the md driver attempt to
resync each of the arrays sequentially or in parallel?  If the latter,
this is likely to be extremely slow, as it'll be trying to resync
multiple arrays on the same drives (and therefore doing huge amounts
of seeking, etc.).

The other issue is that it looks like (correct me if I'm wrong here),
mdadm doesn't support growing a linear array by increasing the size of
it's constituent parts (which is what would be required here to be
able to expand the entire array when adding a new drive).  I don't
know how hard this would be to implement (I don't know how data gets
arranged in a linear array - does it start with all of the first
drive, then the second, and so on or does it write bits to each?).

Neil: any comments on whether this would be desirable / useful / feasible?

James

PS: and as you say, all of the above could also be done with RAID6
arrays instead of RAID5.

On 14/11/2007, Bill Davidsen <davidsen@tmr.com> wrote:
> James Lee wrote:
> > >From a quick search through this mailing list, it looks like I can
> > answer my own question regarding RAID1 --> RAID5 conversion.  Instead
> > of creating a RAID1 array for the partitions on the two biggest
> > drives, it should just create a 2-drive RAID5 (which is identical, but
> > can be expanded as with any other RAID5 array).
> >
> > So it looks like this should work I guess.
>
> I believe what you want to create might be a three drive raid-5 with one
> failed drive. That way you can just add a drive when you want.
>
>   mdadm -C -c32 -l5 -n3 -amd /dev/md7 /dev/loop[12] missing
>
> Then you can add another drive:
>
>   mdadm --add /dev/md7 /dev/loop3
>
> The output are at the end of this message.
>
> But in general think it would be really great to be able to have a
> format which would do raid-5 or raid-6 over all the available parts of
> multiple drives, and since there's some similar logic for raid-10 over a
> selection of drives it is clearly possible. But in terms of the benefit
> to be gained, unless it fails out of the code and someone feels the
> desire to do it, I can't see much joy to ever having such a thing.
>
> The feature I would really like to have is raid5e, distributed spare so
> head motion is spread over all drives. Don't have time to look at that
> one, either, but it really helps performance under load with small arrays.
>
> --
> bill davidsen <davidsen@tmr.com>
>   CTO TMR Associates, Inc
>   Doing interesting things with small computers since 1979
>
>
