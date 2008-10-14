From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Distributed spares
Date: Tue, 14 Oct 2008 19:20:04 -0400
Message-ID: <48F52924.7030607@tmr.com>
References: <48F3C2A1.3080607@tmr.com> <alpine.DEB.1.10.0810131810570.16807@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0810131810570.16807@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Neil Brown <neilb@suse.de>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Justin Piszcz wrote:
>
>
> On Mon, 13 Oct 2008, Bill Davidsen wrote:
>
>> Over a year ago I mentioned RAID-5e, a RAID-5 with the spare(s) 
>> distributed over multiple drives. This has come up again, so I 
>> thought I'd just mention why, and what advantages it offers.
>>
>> By spreading the spare over multiple drives the head motion of normal 
>> access is spread over one (or several) more drives. This reduces 
>> seeks, improves performance, etc. The benefit reduces as the number 
>> of drives in the array gets larger, obviously with four drives using 
>> only three for normal operation is slower than four, etc. And by 
>> using all the drives all the time, the chance of a spare being 
>> undetected after going bad is reduced.
>>
>> This becomes important as array drive counts shrink. Lower cost for 
>> drives ($100/TB!), and attempts to drop power use by using fewer 
>> drives, result in an overall drop in drive count, important in 
>> serious applications.
>>
>> All that said, I would really like to bring this up one more time, 
>> even if the answer is "no interest."
>>
>> -- 
>> Bill Davidsen <davidsen@tmr.com>
>> "Woe unto the statesman who makes war without a reason that will still
>> be valid when the war is over..." Otto von Bismark
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> Bill,
>
> Not a bad idea; however, can the same not be acheived (somewhat) by 
> performing daily/smart, weekly/long tests on the drive to validate its 
> health?  I find this to work fairly well on a large scale.

Not really, the performance benefit comes from spreading head motion to 
(at least) one more drive. You can get a check on basic functionality 
with SMART, but it doesn't beat the drive the way real load does. Add to 
that the unfortunate problem that more realistic testing also takes up 
i/o bandwidth for non-productive transfers. Better to be doing actual 
live data transfers to those drives if you can.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


