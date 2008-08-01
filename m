From: Holger Kiehl <Holger.Kiehl@dwd.de>
Subject: Re: RAID1 write order fidelity
Date: Fri, 1 Aug 2008 11:15:24 +0000 (GMT)
Message-ID: <Pine.LNX.4.64.0808011051590.14520@diagnostix.dwd.de>
References: <20080731090330.285131sc3ypxzwhu@webmail.ualberta.ca>
 <4891ED2F.30301@dgreaves.com> <18578.22600.936623.203944@notabene.brown>
 <4892E09E.3030003@dgreaves.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4892E09E.3030003@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: Neil Brown <neilb@suse.de>, aristizb@ualberta.ca, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, 1 Aug 2008, David Greaves wrote:

> Neil Brown wrote:
>>> Hence messages like:
>>> Filesystem "md0": Disabling barriers, not supported by the underlying device
>>
>> A strange message to get as md/RAID1 *does* support barriers when all the
>> underlying devices do (since the mid-teens of 2.6 I think).
>
> You specifically mention raid1 - which, granted, is what the OP asked about - is
> md raid1 different from other raid levels wrt barriers?
>
> Also the above message comes from XFS on a raid5 on 2.6.18 - Xen :(
> I thought I'd seen this on raid5 on 2.6.2[456] too though (no access to check
> right now)
>
I get this message:

    JBD: barrier-based sync failed on md7 - disabling barriers

That is with 2.6.26 and ext4. But this is with RAID1+0 and md7 is the
RAID0 part.

Holger

