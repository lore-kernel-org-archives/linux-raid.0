From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: Good hardware for mdadm
Date: Fri, 29 Aug 2014 17:38:30 -0500
Message-ID: <CAAMCDedo1N1RybUQ4=fd=R9TDtY=TF-aYomYmxA2d250fmgjbA@mail.gmail.com>
References: <ltqnvm$80o$1@ger.gmane.org> <CAH3kUhH=ZdfRtMw+FiRz4c7qkt8UgbHuoTKiUKyq5Uu9AxHBsQ@mail.gmail.com>
 <ltqscm$qp5$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ltqscm$qp5$1@ger.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Paul van der Vlis <paul@vandervlis.nl>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

No bios I have seen automatically handles it unless the disks are
total dead, some of the hardware raid controlers may properly deal
with a disk returning an error and go to the other mirror, the low end
quality raid controllers start around $200.

Outside of the raid controllers I don't believe any of the bioses
themselves will do it, so you are unlikely to find any hardware that
does that.

Likely he is talking about putting the boot block on multiple disks
and and use the bbr menu or the bios boot disk selection to pick
another disk.

On Fri, Aug 29, 2014 at 4:47 PM, Paul van der Vlis <paul@vandervlis.nl> wrote:
> Hi Roberto,
>
> op 29-08-14 22:44, Roberto Spadim schreef:
>> i use two or more boot disks, if the first raid1 disk don't boot bios
>> go to second boot disk, third, etc etc,
>
> In my opinion this only works when the boot-disk is completely defect or
> removed. Not when the data in the MBR on that boot-disk is corrupt.
>
> Or did you test this, or do you have other reasons to believe that your
> bios will handle this correct?
>
> With the boot-disk I mean the disk what's in the bios the first disk. So
> this could also be the second raid1 disk. Or an USB stick.
>
>> you must write grub to mbr of each disk
>
> Of course.
>
> With regards,
> Paul van der Vlis.
>
>> i'm using dell server r410 if i'm not wrong
>>
>> 2014-08-29 17:31 GMT-03:00 Paul van der Vlis <paul@vandervlis.nl>:
>>> Hello,
>>>
>>> I like mdadm and I am using it many years. But in my opinion it has one
>>> disadvantage: when the MBR of the boot-disk is corrupt, the machine will
>>> not boot.
>>>
>>> A bios could check this. Wait for some kind of signal from Grub or
>>> Linux, and after a timeout boot from another disk. But I don't know
>>> about a bios with that feature.
>>>
>>> A PCIe card could do something like that, but I don't know about such a
>>> PCIe card.
>>>
>>> Is there such hardware?
>>> What do you do to avoid this problem?
>>>
>>> With regards,
>>> Paul van der Vlis.
>>>
>>>
>>>
>>>
>>> --
>>> Paul van der Vlis Linux systeembeheer, Groningen
>>> http://www.vandervlis.nl/
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>>
>
>
>
>
>
> --
> Paul van der Vlis Linux systeembeheer, Groningen
> http://www.vandervlis.nl/
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
