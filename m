From: "David Lethe" <david@santools.com>
Subject: RE: RAID1 == two different ARRAY in scan, and Q on read error corrected
Date: Sat, 19 Apr 2008 15:43:14 -0500
Message-ID: <A20315AE59B5C34585629E258D76A97C087DD2@34093-C3-EVS3.exchange.rackspace.com>
References: <27567.1208547359@perkpartners.com> <48091A67.1090906@sauce.co.nz> <A20315AE59B5C34585629E258D76A97C087DAB@34093-C3-EVS3.exchange.rackspace.com> <480963D0.70307@sauce.co.nz> <28126.1208625976@perkpartners.com> <480A4EF2.6060309@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <480A4EF2.6060309@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Yes, that is correct.  Statistically speaking you have a 20% chance that
a disk will fail within 3 months of having this particular error. Since
you already had (22 - 3) reallocated sectors before this happened, then
probability of failure is probably (don't know off top of head) more
like 50%.

Go shopping. Leave now.

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Richard Scobie
Sent: Saturday, April 19, 2008 2:59 PM
To: Linux RAID Mailing List
Subject: Re: RAID1 == two different ARRAY in scan, and Q on read error
corrected

Phil Lobbes wrote:

> Here's the requested count:
> 
>   5 Reallocated_Sector_Ct   0x0033   251   251   063    Pre-fail
Always       -       22

I'm sure David can give a better interpretation, but as I read it, the 
drive has failed and reallocated 22 sectors and there are 3 more 
(Current_Pending_Sector) waiting to be reallocated.

I have seen some drives that have reallocated some sectors in a burst 
and then operated for years without losing any more, but these were the 
minority.

Usually these counts continue to increase over the short term as the 
drive fails. If the data is important, I would replace it.

Regards,

Richard
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


