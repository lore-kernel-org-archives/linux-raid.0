From: David Greaves <david@dgreaves.com>
Subject: Re: RAID1 write order fidelity
Date: Fri, 01 Aug 2008 11:08:30 +0100
Message-ID: <4892E09E.3030003@dgreaves.com>
References: <20080731090330.285131sc3ypxzwhu@webmail.ualberta.ca>	<4891ED2F.30301@dgreaves.com> <18578.22600.936623.203944@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18578.22600.936623.203944@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: aristizb@ualberta.ca, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
>> Hence messages like:
>> Filesystem "md0": Disabling barriers, not supported by the underlying device
> 
> A strange message to get as md/RAID1 *does* support barriers when all the
> underlying devices do (since the mid-teens of 2.6 I think).

You specifically mention raid1 - which, granted, is what the OP asked about - is
md raid1 different from other raid levels wrt barriers?

Also the above message comes from XFS on a raid5 on 2.6.18 - Xen :(
I thought I'd seen this on raid5 on 2.6.2[456] too though (no access to check
right now)

David
