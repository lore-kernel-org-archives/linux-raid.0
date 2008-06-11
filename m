From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Re: Proper partition type for components with V1.x superblocks?
Date: Wed, 11 Jun 2008 14:12:50 +0200
Message-ID: <484FC142.9030600@rabbit.us>
References: <484F9A3E.7020709@rabbit.us> <20080611112319.GB4981@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080611112319.GB4981@skl-net.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Andre Noll wrote:
> On 11:26, Peter Rabbitson wrote:
> 
>> The subject pretty much says it all - it obviously is not 0xFD, since there 
>> is nothing to autodetect. Is there some best practice/semi-standard way of 
>> marking a raid component partition as such?
> 
> Nobody really cares about the partition type these days. I usually
> stick to the default 83 (Linux) for software raid partitions and
> never encountered any problems.

This is a very flawed assumption. You will be surprised how many 
utilities/live CDs are there in existence, which will selently attempt to 
mount/fsck a partition based solely on its type. The implications of a 
commenced mount/fsck on a raid component are not to be uttered here :)
