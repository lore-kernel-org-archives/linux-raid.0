From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: raid10 on three discs - few questions.
Date: Wed, 06 Feb 2008 13:43:45 -0500
Message-ID: <47A9FFE1.5070001@tmr.com>
References: <20080203235043.3dbb6433@szpak> <18342.18975.229866.860765@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18342.18975.229866.860765@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Janek Kozicki <janek_listy@wp.pl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Sunday February 3, janek_listy@wp.pl wrote:
>   
>> Hi,
>>
>> Maybe I'll buy three HDDs to put a raid10 on them. And get the total
>> capacity of 1.5 of a disc. 'man 4 md' indicates that this is possible
>> and should work.
>>
>> I'm wondering - how a single disc failure is handled in such configuration?
>>
>> 1. does the array continue to work in a degraded state?
>>     
>
> Yes.
>
>   
>> 2. after the failure I can disconnect faulty drive, connect a new one,
>>    start the computer, add disc to array and it will sync automatically?
>>
>>     
>
> Yes.
>
>   
>> Question seems a bit obvious, but the configuration is, at least for
>> me, a bit unusual. This is why I'm asking. Anybody here tested such
>> configuration, has some experience?
>>
>>
>> 3. Another thing - would raid10,far=2 work when three drives are used?
>>    Would it increase the read performance?
>>     
>
> Yes.
>
>   
>> 4. Would it be possible to later '--grow' the array to use 4 discs in
>>    raid10 ? Even with far=2 ?
>>
>>     
>
> No.
>
> Well.... if by "later" you mean "in five years", then maybe.  But the
> code doesn't currently exist.
>   

That's a reason to avoid raid10 for certain applications, then, and go 
with a more manual 1+0 or similar.

Can you create a raid10 with one drive "missing" and add it later? I 
know, I should try it when I get a machine free... but I'm being lazy today.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


