From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Large single raid and XFS or two small ones and EXT3?
Date: Sun, 25 Jun 2006 20:06:51 -0400
Message-ID: <449F251B.1090805@tmr.com>
References: <449AEB7C.6040108@cjx.com> <op.tblclqd3cigqcu@apollo13> <fd8d0180606230226w10b1982ay2916805d9aa0e3bb@mail.gmail.com> <449BE381.6070000@cjx.com> <fd8d0180606230630x3f6b1ab7g444716cf8d5ab2c2@mail.gmail.com> <68c491a60606230746m5c1f0301g8e00fdd4f0e0739b@mail.gmail.com> <449C0505.8000601@tmr.com> <fd8d0180606230834t18427168jd776d33980f516b2@mail.gmail.com> <17564.52087.651968.635043@cse.unsw.edu.au> <Pine.LNX.4.64.0606240840100.10312@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0606240840100.10312@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Neil Brown <neilb@suse.de>, Francois Barre <francois.barre@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Justin Piszcz wrote:

>
> On Sat, 24 Jun 2006, Neil Brown wrote:
>
>> On Friday June 23, francois.barre@gmail.com wrote:
>>
>>>> The problem is that there is no cost effective backup available.
>>>
>>>
>>> One-liner questions :
>>> - How does Google make backups ?
>>
>>
>> No, Google ARE the backups :-)
>>
>>> - Aren't tapes dead yet ?
>>
>>
>> LTO-3 does 300Gig, and LTO-4 is planned.
>> They may not cope with tera-byte arrays in one hit, but they still
>> have real value.
>>
>>> - What about a NUMA principle applied to storage ?
>>
>>
>> You mean an Hierarchical Storage Manager?  Yep, they exist.  I'm sure
>> SGI, EMC and assorted other TLAs could sell you one.
>>
>
> LTO3 is 400GB native and we've seen very good compression, so 
> 800GB-1TB per tape. 

The problem is in small business use, LTO3 is costly in the 1-10TB 
range, and takes a lot of media changes as well. A TB of RAID-5 is 
~$500, and at that small size the cost of drives and media is 
disproportionally high. Using more drives is cost effective, but they 
are not good for long term off site storage, because they're large and 
fragile.

No obvious solutions in that price and application range that I see.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

