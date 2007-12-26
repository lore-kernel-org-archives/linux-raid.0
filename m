From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: raid10 performance question
Date: Wed, 26 Dec 2007 15:59:37 -0500
Message-ID: <4772C0B9.4080809@tmr.com>
References: <cccedfc60712230626t2db70cfcl5b0b49390cd6e609@mail.gmail.com>	<18289.21791.151719.625145@base.ty.sabi.co.UK> <18289.30588.549513.84222@base.ty.sabi.co.UK>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18289.30588.549513.84222@base.ty.sabi.co.UK>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg_lxra@lxra.for.sabi.co.UK>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Peter Grandi wrote:
>>>> On Tue, 25 Dec 2007 19:08:15 +0000,
>>>> pg_lxra@lxra.for.sabi.co.UK (Peter Grandi) said:
>>>>         
>
> [ ... ]
>
>   
>>> It's the raid10,f2 *read* performance in degraded mode that is
>>> strange - I get almost exactly 50% of the non-degraded mode
>>> read performance. Why is that?
>>>       
>
>   
>> [ ... ] the mirror blocks have to be read from the inner
>> cylinders of the next disk, which are usually a lot slower
>> than the outer ones. [ ... ]
>>     
>
> Just to be complete there is of course the other issue that
> affect sustained writes too, which is extra seeks. If disk B
> fails the situation becomes:
>
>     DISK
>    A X C D
>
>    1 X 3 4
>    . . . .
>    . . . .
>    . . . .
>    -------
>    4 X 2 3       
>    . . . .
>    . . . .
>    . . . .
>
> Not only must block 2 be read from an inner cylinder, but to
> read block 3 there must be a seek to an outer cylinder on the
> same disk. Which is the same well known issue when doing
> sustained writes with RAID10 'f2'.

I have often wondered why the elevator code doesn't do better on this 
sustained load, grouping the writes at the drive extremities so there 
would be lots of writes to nearby cylinders then a big seek and lots of 
writes near the next position. I tried bumping the stripe_cache, 
changing to alternate elevators, and just increasing the physical 
memory, and never saw any serious improvement beyond the speed with 
default settings.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


