From: Max Waterman <davidmaxwaterman+gmane@fastmail.co.uk>
Subject: Re: First RAID Setup
Date: Fri, 16 Dec 2005 09:51:10 +0800
Message-ID: <dnt6if$q2o$1@sea.gmane.org>
References: <0481A62A3E95A044AC20A1A45899645C06B02F4B@glc-mail-1.tessco.com> <43A1D642.2010301@wasp.net.au> <43A1E0CE.7090805@medien.uni-weimar.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43A1E0CE.7090805@medien.uni-weimar.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Tobias Hofmann wrote:
> <delurk>
> 
> On 15.12.2005 21:46, Brad Campbell wrote:
> 
>> Callahan, Tom wrote:
>>
>>> It is always wise to build in a spare however, that being said about all
>>> raid levels. In your configuration, if a disk fails in your RAID5, your
>>> array will go down. RAID5 is usually 3+ disks, with a mirror. So you 
>>> should
>>> have 3 disks at minimum, and then a 4th as a spare.
>>
>>
>> /me wonders in the days of reliable RAID-6 why we use RAID-5 + spare?

Just so I am clear on this : while RAID5 consumes a disk's worth of 
space for parity, resulting in n-1 disk's worth of space available for 
storage, RAID6 consumes two disk's worth of space for two parities, 
resulting in n-2 disk's worth of space available for storage.

Is that correct?

> 
> 
> Me too. ;) So, with holidays ahead, two questions (as I might tackle 
> that soon and have not found it mentioned):

I would guess one reason might be that you only have 3 disks - ok 
(minimum) for RAID5, but not for RAID6 (minimum is 4?)?

> 
> - How would one "switch" from the latter to the former? Is there 
> something like "grow_to_RAID_6"?

I'd like to know this too. RAID6 sounds ideal for my array (8 disks - 
currently 6 RAID5 + 2 spares; one is currently at the cleaners) - I 
could even have an extra disk's worth of space, I think.

> - Does RAID6 have disadvantages wrt write speed?

...and what about rebuilding speed? Does it have to read and process 
twice as much parity data?.

Perhaps it is faster for reading (data can be spread across another disk 
[which would be empty in the RAID5+spare config]).

Max.

> 
> TIA for any comments,
> 
> greets, tobi... :)
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

