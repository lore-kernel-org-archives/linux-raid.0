From: Rui Santos <rsantos@grupopie.com>
Subject: Re: recommended 4port SATA controller ?
Date: Thu, 17 Sep 2009 14:28:24 +0100
Message-ID: <4AB23978.8090706@grupopie.com>
References: <4AB22135.7030405@kaneda.iguw.tuwien.ac.at> <87f94c370909170549v156f9b23ie19f7204e21819f1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87f94c370909170549v156f9b23ie19f7204e21819f1@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Greg Freemyer wrote:
> On Thu, Sep 17, 2009 at 7:44 AM, Rainer Fuegenstein
> <rfu@kaneda.iguw.tuwien.ac.at> wrote:
>   
>> hi,
>>
>> I need to move my 4 disk raid5 array from a motherboard with 4 onboard SATA
>> ports to a mainboard with just 2 ports. therefore I'm looking for a reliable
>> and inexpensive 4port PCI controller.
>>     
>
> Rainer,
>
> The support chips are not always available in all flavors of PCI, so
> you need to specify which flavor PCI slots your mother board has.
>
> I don't recall seeing a non-raid 4-port "legacy PCI" controller, but I
> can't say I've looked very hard.  Hopefully your motherboard has a
> "PCI express" slot available.
>
> If PCI is all you have, I would go with a pair of SiiG controllers.
> 2-ports each, but they only cost $30 or so.  I have a dozen machines
> at least with the 2-port SiiG PCI controllers in them and have had no
> issues with linus drivers, etc.
>   
There is an Addonics PCI card that will do what you want.
http://www.addonics.com/products/host_controller/adsa3r5-e.asp . I have
one of those.

Advantages:
- PCI V2.3 66MHz compliant. It will deploy 2.6Gbits/sec.
- Low profile
- RAID fetature
- Support PMP
- Esata

Disadvantages:
- Price
- RAID needs to be set on Windows machine

Check it out...

Rui

> Greg
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
>   

-- 

Regards,
Rui Santos


