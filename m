From: Paul van der Vlis <paul@vandervlis.nl>
Subject: Re: Good hardware for mdadm
Date: Sat, 30 Aug 2014 10:45:11 +0200
Message-ID: <lts2un$j2o$1@ger.gmane.org>
References: <ltqnvm$80o$1@ger.gmane.org>	<CAH3kUhH=ZdfRtMw+FiRz4c7qkt8UgbHuoTKiUKyq5Uu9AxHBsQ@mail.gmail.com>	<ltqscm$qp5$1@ger.gmane.org> <CAH3kUhE1veLpy1k4=SvQO4vwNkkUevLUaaZ=B5Q3RB5rDWRV_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAH3kUhE1veLpy1k4=SvQO4vwNkkUevLUaaZ=B5Q3RB5rDWRV_Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

op 30-08-14 02:44, Roberto Spadim schreef:
> i'm considering that you are using x86, x86_64 hardware, what's your
> application?

I am a sysadmin and I administrate many machines: webservers and
mailservers located in a datacenter, fileservers located at firms, etc.

> there's no bios test (must check if the newer version of this server
> have uefi and work differente), it just don't boot the disk and go to
> next boot
> but for your question: yes... maybe with 'lucky' it can't boot, a
> "bad" (crashed) grub could stop server startup
> 
> maybe others questions that you could check before solving this boot
> problem is why use a "bad" disk?

I would replace it when I would know it's bad.

> why shutdown a server?

Kernel updates.

> why remote startup a server?

Because it's work to go to such a location.

> why use a 'bad' disk?

I would replace it when I would know it's bad.

> if it's a ha system, 

Not really. Maybe.

> include a human to check monthly, or something
> like it, if the server is ok clean,something like it, 

You can't check that way if a MBR boots.

> since ha
> probably include a real time application or a security or risk
> application, or anything like it

I don't know about such an application. But maybe it would be possible
to read the MBR and check it with a copy. I was looking for a redundant
solution, maybe I must forget that.

> probably you must check others solutions at hardware level, some
> computers have dual bios (yes if one bios is lost you have the other
> to boot the computer), 

That's not the problem. I did not see often problems with a bad bios on
a good-running system.

> maybe an openbios could help

It's difficult to buy hardware for coreboot. And I don't think coreboot
can check the booting process.

>, or a uefi bios, must check what's better

Do you know about UEFI bios-es who can check the process?

With regards,
Paul van der Vlis.

> 
> 
> 2014-08-29 18:47 GMT-03:00 Paul van der Vlis <paul@vandervlis.nl>:
>> Hi Roberto,
>>
>> op 29-08-14 22:44, Roberto Spadim schreef:
>>> i use two or more boot disks, if the first raid1 disk don't boot bios
>>> go to second boot disk, third, etc etc,
>>
>> In my opinion this only works when the boot-disk is completely defect or
>> removed. Not when the data in the MBR on that boot-disk is corrupt.
>>
>> Or did you test this, or do you have other reasons to believe that your
>> bios will handle this correct?
>>
>> With the boot-disk I mean the disk what's in the bios the first disk. So
>> this could also be the second raid1 disk. Or an USB stick.
>>
>>> you must write grub to mbr of each disk
>>
>> Of course.
>>
>> With regards,
>> Paul van der Vlis.
>>
>>> i'm using dell server r410 if i'm not wrong
>>>
>>> 2014-08-29 17:31 GMT-03:00 Paul van der Vlis <paul@vandervlis.nl>:
>>>> Hello,
>>>>
>>>> I like mdadm and I am using it many years. But in my opinion it has one
>>>> disadvantage: when the MBR of the boot-disk is corrupt, the machine will
>>>> not boot.
>>>>
>>>> A bios could check this. Wait for some kind of signal from Grub or
>>>> Linux, and after a timeout boot from another disk. But I don't know
>>>> about a bios with that feature.
>>>>
>>>> A PCIe card could do something like that, but I don't know about such a
>>>> PCIe card.
>>>>
>>>> Is there such hardware?
>>>> What do you do to avoid this problem?
>>>>
>>>> With regards,
>>>> Paul van der Vlis.
>>>>
>>>>
>>>>
>>>>
>>>> --
>>>> Paul van der Vlis Linux systeembeheer, Groningen
>>>> http://www.vandervlis.nl/
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>>
>>>
>>
>>
>>
>>
>>
>> --
>> Paul van der Vlis Linux systeembeheer, Groningen
>> http://www.vandervlis.nl/
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 





-- 
Paul van der Vlis Linux systeembeheer, Groningen
http://www.vandervlis.nl/

