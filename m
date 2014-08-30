From: Paul van der Vlis <paul@vandervlis.nl>
Subject: Re: Good hardware for mdadm
Date: Sat, 30 Aug 2014 12:37:16 +0200
Message-ID: <lts9gt$6d3$1@ger.gmane.org>
References: <ltqnvm$80o$1@ger.gmane.org> <CAH3kUhH=ZdfRtMw+FiRz4c7qkt8UgbHuoTKiUKyq5Uu9AxHBsQ@mail.gmail.com> <ltqscm$qp5$1@ger.gmane.org> <CAAMCDedo1N1RybUQ4=fd=R9TDtY=TF-aYomYmxA2d250fmgjbA@mail.gmail.com> <lts2cg$crt$1@ger.gmane.org> <CAAMCDeePxPc3VryFibYBYkstZXU42kxAZQTFcsSbY6e-uzUfLA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAMCDeePxPc3VryFibYBYkstZXU42kxAZQTFcsSbY6e-uzUfLA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

op 30-08-14 11:53, Roger Heflin schreef:
> That means you need an external config tool  (serial, ilo or IMM that
> allows remote console access), I rarely go into the data center that
> all of the hw I run is in, and because of the remote console access
> can fix all but truly broken hw without having hands in the DC).

That's a way to repear something what's broken. Not a more redundant
solution I was looking for. But you are right, it helps a lot. I use
IPMI for remote console. And on some machines a serial console.

What I don't like about IPMI is that the part on the server is -so far I
know- not really open source and I cannot update it for security, so I
can only use it from a secure subnet initiated by another machine.

A serial connection can be done OSS, but you need another machine in the
direct neighborhood, and it's not really nice.

So in both cases you need 2 machines with at least to IP's. Many firms
here have DSL with only one IP.

> For most low end enterprise hw this option adds $200-300 to the price.

It's standard on the machines I buy (Supermicro).

>    If using the simplest (serial) the given mb bios must support
> serial and all add-on bioses must also properly support serial.   I
> have messed with machines that when using serial you cannot see/access
> some of the add on bioses which limits what you can do.   ILO/IMM
> (full graphics console remote type setups) don't have this deficiency
> and can in some cases actually allow one to present a remote boot cd
> to a device and rescue boot it.

Not sure this is possible with OSS applications.

> The MBR did not get broken, it was broken like this as originally
> designed 30 years ago, it was always setup to be only able to deal
> with totally dead drivers (ie drive not showing up at all).

I think you mean the bios. Some bios-es can do fakeraid, and I expect
they can boot from another disk when the first disk is corrupt. But you
cannot use mdadm then, what I would like.

With regards,
Paul van der Vlis.

> On Sat, Aug 30, 2014 at 3:35 AM, Paul van der Vlis <paul@vandervlis.nl> wrote:
>> op 30-08-14 00:38, Roger Heflin schreef:
>>> No bios I have seen automatically handles it unless the disks are
>>> total dead,
>>
>> That's my experience too.
>>
>>> some of the hardware raid controlers may properly deal
>>> with a disk returning an error and go to the other mirror, the low end
>>> quality raid controllers start around $200.
>>
>> Hardware raid controllers have other disadvantages, like using a
>> proprietary format for storing information on disk. And in many cases
>> you have to use tools from the manufacturer. That are reasons for me to
>> like mdadm.
>>
>> Maybe it could be done with a hardware raid controller in JBOD mode.
>>
>> ( And hardware controllers are not perfect too, I've seen simular
>> problems with an HP smart array. First when I've removed the first
>> harddisk the system did boot from the second. )
>>
>>> Outside of the raid controllers I don't believe any of the bioses
>>> themselves will do it, so you are unlikely to find any hardware that
>>> does that.
>>
>> It could be done with a PCIe card too. Some kind of fake-raid adapter
>> what uses mdadm.
>>
>>> Likely he is talking about putting the boot block on multiple disks
>>> and and use the bbr menu or the bios boot disk selection to pick
>>> another disk.
>>
>> Not sure what a "bbr menu" is. But realize that the servers I use are
>> remote.
>>
>> With regards,
>> Paul van der Vlis.
>>
>>> On Fri, Aug 29, 2014 at 4:47 PM, Paul van der Vlis <paul@vandervlis.nl> wrote:
>>>> Hi Roberto,
>>>>
>>>> op 29-08-14 22:44, Roberto Spadim schreef:
>>>>> i use two or more boot disks, if the first raid1 disk don't boot bios
>>>>> go to second boot disk, third, etc etc,
>>>>
>>>> In my opinion this only works when the boot-disk is completely defect or
>>>> removed. Not when the data in the MBR on that boot-disk is corrupt.
>>>>
>>>> Or did you test this, or do you have other reasons to believe that your
>>>> bios will handle this correct?
>>>>
>>>> With the boot-disk I mean the disk what's in the bios the first disk. So
>>>> this could also be the second raid1 disk. Or an USB stick.
>>>>
>>>>> you must write grub to mbr of each disk
>>>>
>>>> Of course.
>>>>
>>>> With regards,
>>>> Paul van der Vlis.
>>>>
>>>>> i'm using dell server r410 if i'm not wrong
>>>>>
>>>>> 2014-08-29 17:31 GMT-03:00 Paul van der Vlis <paul@vandervlis.nl>:
>>>>>> Hello,
>>>>>>
>>>>>> I like mdadm and I am using it many years. But in my opinion it has one
>>>>>> disadvantage: when the MBR of the boot-disk is corrupt, the machine will
>>>>>> not boot.
>>>>>>
>>>>>> A bios could check this. Wait for some kind of signal from Grub or
>>>>>> Linux, and after a timeout boot from another disk. But I don't know
>>>>>> about a bios with that feature.
>>>>>>
>>>>>> A PCIe card could do something like that, but I don't know about such a
>>>>>> PCIe card.
>>>>>>
>>>>>> Is there such hardware?
>>>>>> What do you do to avoid this problem?
>>>>>>
>>>>>> With regards,
>>>>>> Paul van der Vlis.
>>>>>>
>>>>>>
>>>>>>
>>>>>>
>>>>>> --
>>>>>> Paul van der Vlis Linux systeembeheer, Groningen
>>>>>> http://www.vandervlis.nl/
>>>>>>
>>>>>> --
>>>>>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>
>>>>>
>>>>>
>>>>
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
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
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

