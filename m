From: Paul van der Vlis <paul@vandervlis.nl>
Subject: Re: Good hardware for mdadm
Date: Sat, 30 Aug 2014 10:25:19 +0200
Message-ID: <lts1pf$6gh$1@ger.gmane.org>
References: <ltqnvm$80o$1@ger.gmane.org>	<CAH3kUhH=ZdfRtMw+FiRz4c7qkt8UgbHuoTKiUKyq5Uu9AxHBsQ@mail.gmail.com>	<ltqscm$qp5$1@ger.gmane.org> <CAH_2GhebF9=74XP7y+jj+m0a59EjYx-DgJWBKZyvQtgd4T2G9w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAH_2GhebF9=74XP7y+jj+m0a59EjYx-DgJWBKZyvQtgd4T2G9w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

op 29-08-14 23:52, Adam Talbot schreef:
> I have found placing /boot + MBR on a DOM (Disk on module) to be very
> effective.

Maybe a good DOM is more reliable then a good harddisk. But it's not
redundant.

> Perhaps we should be asking how the MBR got broken in the first place?

I am using mdadm about 12 years, and I've seen many times that a system
did not come up after booting. And when I removed the boot-disk, it did
come up.

I must say it's less then for a few years, maybe I am using better
disks. But I am looking for something what's better.

What helps, is that there is something like IPMI. So when there is a
problem and IPMI is working fine, you can boot by hand from another disk.

With regards,
Paul van der Vlis.


> On Fri, Aug 29, 2014 at 2:47 PM, Paul van der Vlis <paul@vandervlis.nl> wrote:
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 





-- 
Paul van der Vlis Linux systeembeheer, Groningen
http://www.vandervlis.nl/

