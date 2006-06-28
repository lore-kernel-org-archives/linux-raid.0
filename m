From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Ok to go ahead with this setup?
Date: Wed, 28 Jun 2006 06:18:56 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0606280618050.18112@p34.internal.lan>
References: <bb145bd20606221008p131d4daem289a6b9300757c66@mail.gmail.com>  
 <62b0912f0606221104q2f47f574i86441efed5831957@mail.gmail.com>  
 <bb145bd20606221250y147d0a0bk1e371a3078adc09e@mail.gmail.com>
 <62b0912f0606221511p74a78ca5id4b5d3f870258815@mail.gmail.com>
 <Pine.LNX.4.64.0606272241040.26384@router.windsormachine.com>
 <44A2204D.D21130B7@ardistech.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44A2204D.D21130B7@ardistech.com>
Sender: linux-raid-owner@vger.kernel.org
To: "bart@ardistech.com" <bart@ardistech.com>
Cc: Mike Dresser <mdresser_l@windsormachine.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Wed, 28 Jun 2006, bart@ardistech.com wrote:

> Mike Dresser wrote:
>>
>> On Fri, 23 Jun 2006, Molle Bestefich wrote:
>>
>>> Christian Pernegger wrote:
>>>> Anything specific wrong with the Maxtors?
>>>
>>> I'd watch out regarding the Western Digital disks, apparently they
>>> have a bad habit of turning themselves off when used in RAID mode, for
>>> some reason:
>>> http://thread.gmane.org/gmane.linux.kernel.device-mapper.devel/1980/
>>
>> The MaxLine III's (7V300F0) with VA111630/670 firmware currently timeout
>> on a weekly or less basis.. I'm still testing VA111680 on a 15x300 gig
>> array
>>
> We also see similar problem on Maxtor 6V250F0 drives: they 'crash' randomly at
> a weeks timescale. Only way to get them back is by power cycling. Tried both
> SuperMicro SATA card (Marvell chip) and Promise Fastrak, firmware updates from
> Maxtor did not fix it yet. We were already forced to exchange all drives at
> a customer because he does not want to use Maxtor's anymore. Neither do we :(
>
> 	Bart
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

> The MaxLine III's (7V300F0) with VA111630/670 firmware currently timeout
> on a weekly or less basis.. I'm still testing VA111680 on a 15x300 gig
> array

How do you have the 15 drives attached? Did you buy a SATA raid card?  Do 
you have multiple (cheap JBOD SATA cards)?  If so, which did you use? I 
cannot seem to find any PCI-e cards with >= 4-8 slots that support JBOD 
under $700-$900.
