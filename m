From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Raid1 replaced with raid10?
Date: Mon, 07 May 2007 17:22:34 -0400
Message-ID: <463F989A.8090109@tmr.com>
References: <45FF1BDF.6060304@rabbit.us>	<463B2D15.7020305@rabbit.us>	<463B4C4F.9030504@tmr.com> <17982.42974.461499.127486@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17982.42974.461499.127486@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Peter Rabbitson <rabbit@rabbit.us>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Friday May 4, davidsen@tmr.com wrote:
>   
>> Peter Rabbitson wrote:
>>     
>>> Hi,
>>>
>>> I asked this question back in march but received no answers, so here it
>>> goes again. Is it safe to replace raid1 with raid10 where the amount of
>>> disks is equal to the amount of far/near/offset copies? I understand it
>>> has the downside of not being a bit-by-bit mirror of a plain filesystem.
>>> Are there any other caveats?
>>>   
>>>       
>> Clearly you have reduced capacity, since there's a mirror AND a CRC, 
>> otherwise I don't see any drawbacks. The performance should be much better.
>>     
>
> CRC ??? md/raid10 doesn't have any CRC.
> What CRC are you thinking of?
>   
There is an entire paragraph missing here, no doubt a finger check due 
to trying to post and get out to lunch. I was rambling on about raid6, 
mirroring 1+5, and other things which never made it. The post can be 
scrubbed, I was just rambling on at length about various other solutions 
possible.

Not worth a repost, since I was way over answering his question...
> To answer the original question, I assume you mean "replace" as in
> "backup, create new array, then restore".
> You will get different performance characteristics.  Whether they
> better suit your needs or not will depend largely on your needs.
>
> NeilBrown
>
>   


-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

