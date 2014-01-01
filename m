From: Pieter De Wit <pieter@insync.za.net>
Subject: Re: Looking for help how to migrate 2disk RAID1 to 3 disk RAID6
Date: Wed, 01 Jan 2014 23:33:06 +1300
Message-ID: <52C3EEE2.10402@insync.za.net>
References: <1388537511.5058.22.camel@oxygen.netxsys.com>	 <52C36908.2010701@insync.za.net> <1388552041.5058.25.camel@oxygen.netxsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1388552041.5058.25.camel@oxygen.netxsys.com>
Sender: linux-raid-owner@vger.kernel.org
To: Krzysztof Adamski <k-list@adamski.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 1/01/2014 17:54, Krzysztof Adamski wrote:
> On Wed, 2014-01-01 at 14:02 +1300, Pieter De Wit wrote:
>> On 1/01/2014 13:51, Krzysztof Adamski wrote:
>>> <snip>
>> Hi,
>>
>> RAID Level 6 requires a minimum of 4 drives to implement
>>
>> Cheers,
>>
>> Pieter
> I have seen messages by Neil from 2011 that he was planning to remove
> this silly minimum requirement of 4 drive for RAID6.
>
>
IMHO, that "silly minimum requirement" *is* RAID6, 2xDATA, 2xPARITY. If 
you make it 1 DATA, then you might as well have RAID1 with a hot spare 
(not even sure how the calc's will work - for RAID6 like that, RAID1 is 
easy :) )

I would use RAID5 for now, then migrate to RAID6 when you get a forth 
drive. IIRC, you can always upgrade "up", not down (RAID numbers that is)

Cheers,

Pieter
