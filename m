From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: RAID1 == two different ARRAY in scan, and Q on read error corrected
Date: Sun, 20 Apr 2008 07:58:42 +1200
Message-ID: <480A4EF2.6060309@sauce.co.nz>
References: <27567.1208547359@perkpartners.com> <48091A67.1090906@sauce.co.nz> <A20315AE59B5C34585629E258D76A97C087DAB@34093-C3-EVS3.exchange.rackspace.com> <480963D0.70307@sauce.co.nz> <28126.1208625976@perkpartners.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <28126.1208625976@perkpartners.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Phil Lobbes wrote:

> Here's the requested count:
> 
>   5 Reallocated_Sector_Ct   0x0033   251   251   063    Pre-fail  Always       -       22

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
