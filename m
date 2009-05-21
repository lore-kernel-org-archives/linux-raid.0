From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: "raid array not clean" messages
Date: Thu, 21 May 2009 14:38:02 -0400
Message-ID: <4A159F8A.5070302@tmr.com>
References: <5817fbed0905202136i1e7e73dfk58dfe375baa06360@mail.gmail.com>	<37d33d830905202149u7759fc36id79cc69757892f95@mail.gmail.com>	<4A43563A-43D5-437D-A916-0DCCB1A61239@gmail.com>	<5817fbed0905202211t6f2b73d3o187906f77383fe5b@mail.gmail.com> <18964.62098.885221.299555@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18964.62098.885221.299555@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: fibre raid <fibreraid@gmail.com>, Christopher Chen <muffaleta@gmail.com>, SandeepKsinha <sandeepksinha@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil Brown wrote:
> On Thursday May 21, fibreraid@gmail.com wrote:
>   
>> I have no problem with this message being written to
>> /var/log/messages, but in our case, we don't want it on the console.
>> We want the console to only be there for kernel crash dumps (if they
>> occur), nothing else.
>>     
>
> I feel you are a bit optimistic...
>
> But I guess what you are really asking is for the message to be
> printed with a lower priority than KERN_ERR - maybe KERN_INFO.
> It is in drivers/md/md.c at the end of analyze_sbs.
>
> You would need to compile a new kernel to achieve that.
>   

Since it is actually informational rather than an error, I would think 
KERN_INFO would be more correct for all users. Then people who want 
stuff like that can play with their syslog configuration to see it if 
they want. I agree that conditions which do not require intervention to 
correct them are not errors, messages about them are for informational 
purposes. Hardware errors and failure in unexpected places don't need to 
bother the operator (for whatever definition of operator you like).

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc

"You are disgraced professional losers. And by the way, give us our money back."
    - Representative Earl Pomeroy,  Democrat of North Dakota
on the A.I.G. executives who were paid bonuses  after a federal bailout.


