From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: mismatch_cnt again
Date: Mon, 09 Nov 2009 13:08:34 -0500
Message-ID: <4AF85AA2.3060300@tmr.com>
References: <4AF4C247.6050303@eyal.emu.id.au> <4AF4D323.6020108@panix.com>	<4AF5268D.60900@eyal.emu.id.au>	<4877c76c0911070008m789507f8h799d419287740ca5@mail.gmail.com>	<87tyx6tpcb.fsf@frosties.localdomain> <4AF58B20.3000409@redhat.com>	<4AF59F19.1080409@lazy.lzy> <87skcpav6d.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87skcpav6d.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, Doug Ledford <dledford@redhat.com>, Michael Evans <mjevans1983@gmail.com>, Eyal Lebedinsky <eyal@eyal.emu.id.au>, linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Goswin von Brederlow wrote:
> Piergiorgio Sartor <piergiorgio.sartor@nexgo.de> writes:
>
>   
>> On 11/07/2009 03:58 PM, Doug Ledford wrote:
>> [...]
>>     
>>> I'm very quickly starting to become dubious of the current mismatch_cnt
>>> implementation.  I think a kernel patch is in order and I may just work
>>> on that today.  Here's the deal: a non-0 mismatch count is worthless if
>>> you don't also tell people *where* the mismatch is so they can
>>> investigate it and correct it.
>>>       
>> You're perfectly right.
>>
>> And this, again, fits in the discussion of RAID-6 error
>> check and, potentially, repair.
>>
>> Ideally the log should tell which (RAID) address has a
>> mismatch and, in case of RAID-6, if a specific device
>> could be faulty at that position.
>>     
>
> Actual in raid6 mode if one parity block is bad but the other is
> correct I would expect that to automatically repair the bad block, at
> least optionally. Same with a 3+ way mirror and one mirror being bad.
>
> In general if a block is bad and the kernel can isolate which block in
> a stripe is bad then it should repair it while checking.
>   

While I agree totally on what the kernel *should* do, AFAIK it does no 
such thing. In fact, I believe that even with a three way mirror the 
mismatch is "fixed" by picking one copy at random and writing it over 
the others, rather than voting.

I haven't looked at this in ages, but that's my memory. Like Dennis 
Miller, "I could be wrong."

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

