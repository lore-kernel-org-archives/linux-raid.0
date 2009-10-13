From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: recommended 4port SATA controller ?
Date: Tue, 13 Oct 2009 17:19:33 -0400
Message-ID: <4AD4EEE5.8040806@tmr.com>
References: <4AB22135.7030405@kaneda.iguw.tuwien.ac.at> <87f94c370909170549v156f9b23ie19f7204e21819f1@mail.gmail.com> <4AB23978.8090706@grupopie.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AB23978.8090706@grupopie.com>
Sender: linux-raid-owner@vger.kernel.org
To: Rui Santos <rsantos@grupopie.com>
Cc: Greg Freemyer <greg.freemyer@gmail.com>, Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Rui Santos wrote:
> Greg Freemyer wrote:
>   
>> On Thu, Sep 17, 2009 at 7:44 AM, Rainer Fuegenstein
>> <rfu@kaneda.iguw.tuwien.ac.at> wrote:
>>   
>>     
>>> hi,
>>>
>>> I need to move my 4 disk raid5 array from a motherboard with 4 onboard SATA
>>> ports to a mainboard with just 2 ports. therefore I'm looking for a reliable
>>> and inexpensive 4port PCI controller.
>>>     
>>>       
>> Rainer,
>>
>> The support chips are not always available in all flavors of PCI, so
>> you need to specify which flavor PCI slots your mother board has.
>>
>> I don't recall seeing a non-raid 4-port "legacy PCI" controller, but I
>> can't say I've looked very hard.  Hopefully your motherboard has a
>> "PCI express" slot available.
>>
>> If PCI is all you have, I would go with a pair of SiiG controllers.
>> 2-ports each, but they only cost $30 or so.  I have a dozen machines
>> at least with the 2-port SiiG PCI controllers in them and have had no
>> issues with linus drivers, etc.
>>   
>>     
> There is an Addonics PCI card that will do what you want.
> http://www.addonics.com/products/host_controller/adsa3r5-e.asp . I have
> one of those.
>
> Advantages:
> - PCI V2.3 66MHz compliant. It will deploy 2.6Gbits/sec.
>   

??? I don't know what they mean by "deploy," but I know what 133MB/s 
means in the PCI bus standard, and 2.6Gbit isn't it. I suspect that's 
max write speed for an N-way raid, N copies of the same data going to 
each drive fed from memory at bus max, but it certainly doesn't mean 
transfer between storage and memory. Sounds like a spec they put in 
advertising, big meaningless (or nearly so) number. Factual, but not a 
normal use case.

> - Low profile
> - RAID fetature
> - Support PMP
> - Esata
>   

Don't think that's what's desired, could be wrong.
> Disadvantages:
> - Price
> - RAID needs to be set on Windows machine
>
> Check it out...
>   

Agree, my BS detector occasionally gets false positives.

-- 
Bill Davidsen <davidsen@tmr.com>
  Unintended results are the well-earned reward for incompetence.

