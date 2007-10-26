From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Time to  deprecate old RAID formats?
Date: Fri, 26 Oct 2007 10:18:42 -0400
Message-ID: <4721F742.1090301@tmr.com>
References: <18200.49267.763509.924873@stoffel.org>	<Pine.LNX.4.64.0710191109000.27246@p34.internal.lan>	<18200.53593.687483.120827@stoffel.org>	<1192810534.1666.68.camel@firewall.xsintricity.com>	<18200.56684.14194.630264@stoffel.org>	<1192813877.1666.79.camel@firewall.xsintricity.com>	<18200.63987.514073.184865@stoffel.org>	<471E7DC6.7050206@tmr.com>	<1193184555.10336.3.camel@firewall.xsintricity.com>	<18207.56169.769976.512617@notabene.brown>	<471FDEB1.8040401@garzik.org>	<47204F45.4010205@dgreaves.com> <18209.34365.375059.602828@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18209.34365.375059.602828@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: David Greaves <david@dgreaves.com>, Jeff Garzik <jeff@garzik.org>, Doug Ledford <dledford@redhat.com>, John Stoffel <john@stoffel.org>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Thursday October 25, david@dgreaves.com wrote:
>   
>> I didn't get a reply to my suggestion of separating the data and location...
>>     
>
> No. Sorry.
>
>   
>> ie not talking about superblock versions 0.9, 1.0, 1.1, 1.2 etc but a data
>> format (0.9 vs 1.0) and a location (end,start,offset4k)?
>>
>> This would certainly make things a lot clearer to new (and old!) users:
>>
>> mdadm --create /dev/md0 --metadata 1.0 --meta-location offset4k
>> or
>> mdadm --create /dev/md0 --metadata 1.0 --meta-location start
>> or
>> mdadm --create /dev/md0 --metadata 1.0 --meta-location end
>>     
>
> I'm happy to support synonyms.  How about
>
>    --metadata 1-end
>    --metadata 1-start
>
> ??
>   
Offset? Do you like "1-offset4k" or maybe "1-start4k" or even 
"1-start+4k" for that? The last is most intuitive but I don't know how 
you feel about the + in there.
>   
>> resulting in:
>> mdadm --detail /dev/md0
>>
>> /dev/md0:
>>         Version : 01.0
>>   Metadata-locn : End-of-device
>>     
>
> It already lists the superblock location as a sector offset, but I
> don't have a problem with reporting:
>
>           Version : 1.0 (metadata at end of device)
> 	  Version : 1.1 (metadata at start of device)
>
> Would that help?
>
>   
Same comments on the reporting, "metadata at block 4k" or something.
>   
>>   Creation Time : Fri Aug  4 23:05:02 2006
>>      Raid Level : raid0
>>
>> You provide rational defaults for mortals and this approach allows people like
>> Doug to do wacky HA things explicitly.
>>
>> I'm not sure you need any changes to the kernel code - probably just the docs
>> and mdadm.
>>     
>
> True.
>
>   
>>>> It is conceivable that I could change the default, though that would
>>>> require a decision as to what the new default would be.  I think it
>>>> would have to be 1.0 or it would cause too much confusion.
>>>>         
>>> A newer default would be nice.
>>>       
>> I also suspect that a *lot* of people will assume that the highest superblock
>> version is the best and should be used for new installs etc.
>>     
>
> Grumble... why can't people expect what I want them to expect?
>
>   
I confess that I thought 1.x was a series of solutions reflecting your 
evolving opinion on what was best, so maybe in retrospect you made a 
non-intuitive choice of nomenclature. Or bluntly, you picked confusing 
names for this and confused people. If 1.0 meant start, 1.1 meant 4k, 
and 1.2 meant end, at least it would be easy to remember for people who 
only create a new array a few times a year, or once in the lifetime of a 
new computer.
>> So if you make 1.0 the default then how many users will try 'the bleeding edge'
>> and use 1.2? So then you have 1.3 which is the same as 1.0? Hmmmm? So to quote
>> from an old Soap: "Confused, you  will be..."
>>     

Perhaps you could have called them 1.start, 1.end, and 1.4k in the 
beginning? Isn't hindsight wonderful?

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

