From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Fw: Why does one get mismatches?
Date: Mon, 01 Feb 2010 16:18:23 -0500
Message-ID: <4B67451F.8040206@tmr.com>
References: <869541.92104.qm@web51304.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <869541.92104.qm@web51304.mail.re2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon@eHardcastle.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jon Hardcastle wrote:
> --- On Tue, 19/1/10, Jon Hardcastle <jd_hardcastle@yahoo.com> wrote:
>
>   
>> From: Jon Hardcastle <jd_hardcastle@yahoo.com>
>> Subject: Why does one get mismatches?
>> To: linux-raid@vger.kernel.org
>> Date: Tuesday, 19 January, 2010, 10:04
>> Hi,
>>
>> I kicked off a check/repair cycle on my machine after i
>> moved the phyiscal ordering of my drives around and I am now
>> on my second check/repair cycle and it has kept finding
>> mismatches.
>>
>> Is it correct that the mismatch value after a repair was
>> needed should equal the value present after a check? What if
>> it doesn't? What does it mean if another check STILL reveals
>> mismatches?
>>
>> I had something similar after i reshaped from raid 5 to 6 i
>> had to run check/repair/check/repair several times before i
>> got my 0.
>>
>>
>>     
>
> Guys,
>
> Anyone got any suggestions here? I am now on my ~5 check/repair and after a reboot the first check is still returning 8.
>
> All i have done is move the drives around. It is the same controllers/cables/etc 
>
> I really dont like the seeming random nature of what can/does/has caused the mismatches?
>   

If you have an ext[34] filesystem on this array, try mounting it 
data=journal (yes it will slow down, this is a TEST). I did limited 
testing using this, and it appeared to solve the problem, at least for 
eight hours I had to test.

Comment: when there is a three way RAID-1, why doesn't repair *vote* on 
the correct value instead of just making a guess?

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

