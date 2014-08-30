From: Roberto Spadim <rspadim@gmail.com>
Subject: Re: Good hardware for mdadm
Date: Fri, 29 Aug 2014 21:44:35 -0300
Message-ID: <CAH3kUhE1veLpy1k4=SvQO4vwNkkUevLUaaZ=B5Q3RB5rDWRV_Q@mail.gmail.com>
References: <ltqnvm$80o$1@ger.gmane.org>
	<CAH3kUhH=ZdfRtMw+FiRz4c7qkt8UgbHuoTKiUKyq5Uu9AxHBsQ@mail.gmail.com>
	<ltqscm$qp5$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ltqscm$qp5$1@ger.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Paul van der Vlis <paul@vandervlis.nl>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

i'm considering that you are using x86, x86_64 hardware, what's your
application?
there's no bios test (must check if the newer version of this server
have uefi and work differente), it just don't boot the disk and go to
next boot
but for your question: yes... maybe with 'lucky' it can't boot, a
"bad" (crashed) grub could stop server startup

maybe others questions that you could check before solving this boot
problem is why use a "bad" disk?
why shutdown a server?
why remote startup a server?
why use a 'bad' disk?
if it's a ha system, include a human to check monthly, or something
like it, if the server is ok clean,something like it, since ha
probably include a real time application or a security or risk
application, or anything like it

probably you must check others solutions at hardware level, some
computers have dual bios (yes if one bios is lost you have the other
to boot the computer), maybe an openbios could help, or a uefi bios,
must check what's better


2014-08-29 18:47 GMT-03:00 Paul van der Vlis <paul@vandervlis.nl>:
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



-- 
Roberto Spadim
