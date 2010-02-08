From: Neil Brown <neilb@suse.de>
Subject: Re: Global sparing
Date: Mon, 8 Feb 2010 16:47:50 +1100
Message-ID: <20100208164750.5e917be4@notabene.brown>
References: <8338BD137FF1B64EB341218BD702985E0303DE20@BLR-EC-MBX03.wipro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8338BD137FF1B64EB341218BD702985E0303DE20@BLR-EC-MBX03.wipro.com>
Sender: linux-raid-owner@vger.kernel.org
To: senthilkumar.muthukalai@wipro.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 4 Feb 2010 18:48:16 +0530
<senthilkumar.muthukalai@wipro.com> wrote:

> 
> Hi,
> 
> Can anyone help me to understand the global sharing with the below
> context?
> I have two degraded RAID1s say md0 and md1 with one disk active on each.
> Both the arrays were originally built with 2 disks.
> I am enabling global sharing.
> When I add a disk to md0, it gets rebuilt.
> When I add one more disk to md0, it gets added as a spare.
> The md1, which is also degraded, is not able to grab the global spare
> from md0 which is sitting idle until md0 finishes rebuilding.
> Is this by policy/concept of global sharing that the spare is shared
> after rebuilding?

When an array is recoverying and has extra spares it is not obvious to
userspace which spare is being recovered to, so choosing which one to remove
is not trivial.

I suspect the easiest approach would be to try removing each one and seeing
what works.  A spare that is being actively recovered cannot be removed.

The reason this does not work is simply that I never thought to make it work.


> 
> Also I am trying to change mdadm-2.6.4 to make it shared immediately as
> follows.
> 
> --- mdadm-2.6.4/Monitor.c.orig  2010-02-03 16:58:50.000000000 +0530
> +++ mdadm-2.6.4/Monitor.c       2010-02-03 16:59:47.000000000 +0530
> @@ -469,7 +469,7 @@
>                                 for (st2=statelist ; st2 ;
> st2=st2->next)
>                                         if (st2 != st &&
>                                             st2->spare > 0 &&
> -                                           st2->active == st2->raid &&
> +                                           st2->working >= st2->raid &&
>                                             st2->spare_group != NULL &&
>                                             strcmp(st->spare_group,
> st2->spare_group) == 0) {
>                                                 /* try to remove and add
> */
> 
> Is this change valid and complete?

As this doesn't address the question of choosing the right drive to move I
don't think it is complete.  I would have to look at the code a bit more
deeply to be sure it is valid, but I suspect that it probably is.

NeilBrown


> 
> Thanks,
> Senthil M
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

