From: Holger Kiehl <Holger.Kiehl@dwd.de>
Subject: Re: Software RAID 0+1 with mdadm.
Date: Thu, 27 Jan 2005 08:13:05 +0000 (GMT)
Message-ID: <Pine.LNX.4.61.0501270801560.21209@diagnostix.dwd.de>
References: <1106692101.15355.16.camel@serpent> <16888.31891.953961.175508@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16888.31891.953961.175508@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>
>> I have since upgraded to mdadm 1.8 and setup a RAID10. However I need
>> something that is production worthy. Is a RAID10 something I could rely
>> on as well? Also under a RAID10 how do you tell it which drives you want
>> mirrored?
>
> raid10 is 2.6 only, but should be quite stable.
> You cannot tell it which drives to mirror because you shouldn't care.
> You just give it a bunch of identical drives and let it put the data
> where it wants.
>
> If you really want to care (and I cannot imagine why you would - all
> drives in a raid10 are likely to get similar load) then you have to
> build it "by hand" - a raid0 of multiple raid1s.
>
But what about redundancy? The only reason why on some systems I choose
raid 1+0 and not raid10, is that I want the raid 1 always on two different
controllers or channels. So if there is some problem with the SCSI bus
you will only loose one half of your array. I think with raid10 it
can be that you loose your complete array, because a whole raid1 can
sit on a single controller/channel. Is this assumption correct, or
does raid10 have some magic to solve this?

Thanks,
Holger
