From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: RAID 10 Repairs
Date: Sat, 08 Jun 2013 22:11:54 -0400
Message-ID: <51B3E46A.2090507@tmr.com>
References: <CAE98Ua_Js7wpfkT7wAZhm79Y46t4Fqtfx3752SUO_+H-3jqqcQ@mail.gmail.com> <51AC260F.8050806@hardwarefreak.com> <51B36B4C.4090101@tmr.com> <51B3BE28.40305@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51B3BE28.40305@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Stan Hoeppner wrote:
> On 6/8/2013 12:35 PM, Bill Davidsen wrote:
>> Stan Hoeppner wrote:
>>> Or just acquire two 2TB drives an mirror them.  20x 250GB drives in
>>> RAID10 is 2.5TB net space.  Surely you don't currently have 20 drives in
>>> this RAID array.  If you're acquiring 250GB drives in 2013 I'd guess
>>> you're not after performance.  So reducing spindle count shouldn't be an
>>> issue, should it?
>>>
>> Actually the only reason to use small drives any more is for
>> performance, fast drives (10k+ rpm) tend to be small. And expensive.
> The WD Velociraptor 250 SATA is the only 250GB drive ever sold with a
> 10K+ spindle.  All others are SAS, and are 73, 146, 300, 450, 600,
> 900GB.  If he has 250GB Raptors and needs the random IOPS performance,
> then it makes sense to maintain the RAID10 array.  If not and he simply
> needs capacity...
Brings back memories, we played with 73G drives in a RAID10 f3 configuration. 
Big, loud, expensive, etc. And HOT!
Those were the days. Late 90's or just after Y2k. All IBM rack mount stuff.
>> I agree that this user probably isn't doing that.
>> I see Newegg has decent TB drives for $59 now, not server grade, but
>> decent stuff.
> then the larger mirror pair makes more sense.
>
Can't disagree.

-- 
Bill Davidsen <davidsen@tmr.com>
   We are not out of the woods yet, but we know the direction and have
taken the first step. The steps are many, but finite in number, and if
we persevere we will reach our destination.  -me, 2010


