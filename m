From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Is it possible to grow a RAID-10 array with mdadm?
Date: Wed, 01 Aug 2007 08:32:46 -0400
Message-ID: <46B07D6E.3060901@tmr.com>
References: <loom.20070727T225545-192@post.gmane.org>	<46ABAC5A.2000103@ziu.info>	<46ABB830.1000204@ziu.info>	<0dc901c7d20b$be23d100$332317ac@Cortex> <18093.42484.733479.935581@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18093.42484.733479.935581@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Tomas France <tomfra@centrum.cz>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Sunday July 29, tomfra@centrum.cz wrote:
>   
>> Hi everyone,
>>
>> Is it possible to add drives to an active RAID-10 array, using the "grow" 
>> switch with mdadm, just like it is possible with a RAID-5 array? Or perhaps 
>> there is another way?
>>
>> I have been looking for this information for a long time but have been 
>> unable to find it anywhere. The man page for mdadm does not mention RAID-10 
>> at all so that didn't help either. Has anyone tried it?
>>     
>
> The man page for mdadm does not mention it because it is not
> supported.
>
> There are several reshape options that I would like to implement
> including
>   - raid5 -> raid6
>   - shrinking raid4/5/6
>   - raid0 -> raid5
>   - changing chunksize/layout of raid4/5/6
>   - raid10 growing and layout change
>   

While changing chunk size is probably the least generally useful, I sure 
would like to have it ;-)

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

