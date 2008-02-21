From: Norman Elton <normelton@gmail.com>
Subject: Re: How many drives are bad?
Date: Thu, 21 Feb 2008 13:12:30 -0500
Message-ID: <9348A68C-6747-481A-96C0-13691F7863EF@gmail.com>
References: <6b3a7f010802190923v6b600fedy2a68ad6797449c6e@mail.gmail.com> <alpine.DEB.1.00.0802191231100.25959@p34.internal.lan> <21289113-077C-4082-8EE1-C7AA11D4FE69@gmail.com> <alpine.DEB.1.00.0802191332390.25959@p34.internal.lan> <6b3a7f010802191038y377999e0v46dcd7132ab3bc97@mail.gmail.com> <alpine.DEB.1.00.0802191413060.26058@p34.internal.lan> <6b3a7f010802191125q3905d1abw2372ed5c7ab1eaf0@mail.gmail.com> <18363.54503.132788.594068@tree.ty.sabi.co.UK>
Mime-Version: 1.0 (Apple Message framework v919.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18363.54503.132788.594068@tree.ty.sabi.co.UK>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> Pure genius! I wonder how many Thumpers have been configured in
> this well thought out way :-).

I'm sorry I missed your contributions to the discussion a few weeks ago.

As I said up front, this is a test system. We're still trying a number  
of different configurations, and are learning how best to recover from  
a fault. Guy Watkins proposed one a few weeks ago that we haven't yet  
tried, but given our current situation... it may be a good time to  
give it a shot.

I'm still not convinced we were running a degraded array before this.  
One drive mysteriously dropped from the array, showing up as "removed"  
but not failed. We did not receive the notification that we did when  
the second actually failed. I'm still thinking its just one drive that  
actually failed.

Assuming we go with Guy's layout of 8 arrays of 6 drives (picking one  
from each controller), how would you setup the LVM VolGroups over top  
of these already distributed arrays?

Thanks again,

Norman



On Feb 20, 2008, at 2:21 AM, Peter Grandi wrote:

>>>> On Tue, 19 Feb 2008 14:25:28 -0500, "Norman Elton"
>>>> <normelton@gmail.com> said:
>
> [ ... ]
>
> normelton> The box presents 48 drives, split across 6 SATA
> normelton> controllers. So disks sda-sdh are on one controller,
> normelton> etc. In our configuration, I run a RAID5 MD array for
> normelton> each controller, then run LVM on top of these to form
> normelton> one large VolGroup.
>
> Pure genius! I wonder how many Thumpers have been configured in
> this well thought out way :-).
>
> BTW, just to be sure -- you are running LVM in default linear
> mode over those 6 RAID5s aren't you?
>
> normelton> I found that it was easiest to setup ext3 with a max
> normelton> of 2TB partitions. So running on top of the massive
> normelton> LVM VolGroup are a handful of ext3 partitions, each
> normelton> mounted in the filesystem.
>
> Uhm, assuming 500GB drives each RAID set has a capacity of
> 3.5TB, and odds are that a bit over half of those 2TB volumes
> will straddle array boundaries. Such attention to detail is
> quite remarkable :-).
>
> normelton> This less than ideal (ZFS would allow us one large
> normelton> partition),
>
> That would be another stroke of genius! (especially if you were
> still using a set of underlying RAID5s instead of letting ZFS do
> its RAIDZ thing). :-)
>
> normelton> but we're rewriting some software to utilize the
> normelton> multi-partition scheme.
>
> Good luck!
> -
> To unsubscribe from this list: send the line "unsubscribe linux- 
> raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

