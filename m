From: berk walker <berk@panix.com>
Subject: Re: Changing chunk size
Date: Sat, 17 Feb 2007 20:51:40 -0500
Message-ID: <45D7B12C.4010109@panix.com>
References: <45D4955C.60008@tmr.com> <17876.60347.983953.748979@notabene.brown> <45D5E05E.4000706@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45D5E05E.4000706@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Neil Brown <neilb@suse.de>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



Bill Davidsen wrote:
> Neil Brown wrote:
>> On Thursday February 15, davidsen@tmr.com wrote:
>>  
>>> I have determined that a large array was created with an 
>>> overly-large chunk size. Best way to resize?
>>>     
>>
>> Dump and restore.
>>
>> in-place reshapes (such as raid5 + 1 disk => raid6 or
>> change-chunk-size) are on my list of 'that might be interesting to
>> implement', but there are plenty of more interesting things.  And it
>> would be very slow.  It would need to copy some number of stripes to a
>> backup somewhere, then copy them back in the new layout, so every
>> block in the array would be written twice.
> I'm sure "slow" is a relative term, compared to backing up TBs of data 
> and trying to restore them. Not to mention the lack of inexpensive TB 
> size backup media. That's totally unavailable at the moment, I'll live 
> with what I have, thanks.


> If you were to be a gambler, Bill - Get 2 disks big enough to store 
> your data, create a RAID5 mising one, and copy over the data.  Re do 
> the original array, and copy back.
Yeah, $0.02 doesn't buy much anymore.  Besides, you'll be needing bigger 
disks for the next machine you build,eh?

b-

