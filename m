From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Re: Proper partition type for components with V1.x superblocks?
Date: Wed, 11 Jun 2008 13:35:36 +0200
Message-ID: <484FB888.1030205@rabbit.us>
References: <484F9A3E.7020709@rabbit.us> <484FB5E5.8000207@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <484FB5E5.8000207@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Greaves wrote:
> Peter Rabbitson wrote:
>> Hello,
>>
>> The subject pretty much says it all - it obviously is not 0xFD, since
>> there is nothing to autodetect. Is there some best
>> practice/semi-standard way of marking a raid component partition as
>> such? After reading the specs 0xDA (non-fs data) comes to mind, but I
>> figured I'll ask here.
> 
> I recently wondered if there should be a new partition type.
> 
> Partitioning tools look for (and sometimes find!) filesystems on 0x83 partitions
> so 0x83 is out (anyone splitting a mirror should be happy changing the type back)
> 
> I'd rather that rescue disk didn't think 'oh, I'll use that swap partition', so
> 0x82 is out.
> 
> I don't want md trying to autodetect and complaining so, as you say, 0xfd is out.
> 
> I think it would be nice to mark them as 0xFC

Nope. As per [1] (which is linked in [2]): fc VMware Swap partition

What is the process for partition type registration anyway? How did 0xFD come 
around?

Peter

[1] http://www.win.tue.nl/~aeb/partitions/partition_types-1.html
[2] http://en.wikipedia.org/wiki/Partition_(computing)
