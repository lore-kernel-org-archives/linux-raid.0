From: Mike Hardy <mhardy@h3c.com>
Subject: Re: Is there any way to delay reconstruction
Date: Wed, 25 May 2005 08:12:09 -0700
Message-ID: <429495C9.3090208@h3c.com>
References: <Pine.LNX.4.61.0505250811520.16854@desktop.agenda.si> <Pine.LNX.4.62.0505250925360.6360@webhosting.rdsbv.ro> <Pine.LNX.4.61.0505251019280.16854@desktop.agenda.si>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0505251019280.16854@desktop.agenda.si>
Sender: linux-raid-owner@vger.kernel.org
To: danci@agenda.si
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I've had this problem. I turned the raid speed limit max to 0, slept for
a second (just because), did my hdparm commands, slept another second
(again, just because - may not be necessary), then turned the raid speed
limit back to something that was good for background reconstruction.

That got rid of my dropped interrupts

-Mike

danci@agenda.si wrote:
> On Wed, 25 May 2005, Catalin(ux aka Dino) BOIE wrote:
> 
> 
>>>So I need to know if there is any way (kernel parameter would be 
>>>ideal) to delay reconstruction for X seconds/minutes?
>>>
>>>Any other suggestions to deal with the problem?
>>
>>You can hot-remove the previous failed disk (anyway, it just started to
>>resync). Then, activate DMA, then hot-add the disk to array.
>>
>>Hope it helps.
> 
> 
> Thanks for the suggestion - this may be the last resort (I'd like to keep 
> the init-scripts as clean as possible).
> 
> I forgot to mention that I'm using 2.4 kernels (2.4.27 at the moment, 
> 2.4.30 on the test machine - but it does the same thing).
> 
> There is a module 'piix.o' that needs to be loaded before I can use DMA at 
> all. It's loaded via init scripts - I will try putting it in the initrd.
> 
>  D.
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
