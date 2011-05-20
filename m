From: CoolCold <coolthecold@gmail.com>
Subject: Re: Software raid, booting and bios
Date: Fri, 20 May 2011 14:04:48 +0400
Message-ID: <112756953.20110520140448@gmail.com>
References: <9067914580344941270@unknownmsgid> <ir58vs$9qp$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ir58vs$9qp$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Paul van der Vlis <paul@vandervlis.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

=C7=E4=F0=E0=E2=F1=F2=E2=F3=E9=F2=E5, Paul.

=C2=FB =EF=E8=F1=E0=EB=E8 20 =EC=E0=FF 2011 =E3., 12:33:00:

> Op 20-05-11 09:19, Simon Mcnair schreef:
>> I have not come across a pc which does not allow you to boot a
>> secondary drive before... Please can you read  the manual and triple
>> check this ?  The only possible reason I can think this would happen
>> Is that you're using an add on board and you would configure this fr=
om
>> a secondary bios. My Dell, Asus, and all other motherboards I've had
>> over the past 10 years all allow a second device.

> You can select the "boot device priority" where you can choose about
> devices types (DVD, harddisk, USB, network) but you can choose only o=
ne
> SATA disk. Study it, and you will see I am right. I've asked it to my
> rackserver-vendor, they say: "that's always the case".
I've  seen supermicro servers with bios allowing to set several drives
as boot disks and without such option (like in your case).
One      of      those      which      could      do      this     was
http://www.supermicro.com/products/motherboard/Xeon1333/5000P/X7DB3.cfm
if i remember things right.


> But I think I have had systems in the past, what could do it. An
> interesting question is then: how well is it tested?  What when e.g. =
a
> disk boots, and then gives an I/O error? I am looking for a well-test=
ed
> way to solve this, and I am willing to pay for it or choose another
> hardware vendor for it.

> With regards,
> Paul van der Vlis.



>> Cheers
>> Simon
>>=20
>> On 20 May 2011, at 08:15, Paul van der Vlis <paul@vandervlis.nl> wro=
te:
>>=20
>>> Op 20-05-11 09:03, Simon Mcnair schreef:
>>>> Please can you further define what you mean by 'it can become a
>>>> problem to boot' ?
>>>> Generally this is resolved by having a mbr and boot partition on e=
ach
>>>> of your mirrored drives so that whichever you use to boot has the
>>>> pertinent information to boot the kernel and construct the raid ar=
ray.
>>>> If you have raid 5 with 3 disks you'd have a 3 drive mirror partit=
ion
>>>> on each disk and a raid 5 set across all three too.
>>>
>>> In the bios from my machines (Supermicro, Dell) I can select only o=
ne
>>> drive to boot. Wenn the drive fails, no other disk is tried.
>>>
>>> I can go into the bios and change the drive when it fails, or I can
>>> exchange the disks. But I would like it, when the machine would sim=
ple
>>> boot even when the first disk is corrupt.
>>>
>>> With regards,
>>> Paul van der Vlis.
>>>
>>>
>>>> I'm not a guru on this and can't provide much knowledge past the
>>>> theory and high level ;-)
>>>> Simon
>>>>
>>>> On 20 May 2011, at 07:55, Paul van der Vlis <paul@vandervlis.nl> w=
rote:
>>>>
>>>>> Hello,
>>>>>
>>>>> I use software raid (mdadm). The main problem for me is that when=
 the
>>>>> drive with the MBR fails, it can become a problem to boot.
>>>>>
>>>>> When the bios would use another drive to boot when the first driv=
e
>>>>> failes, this problem would be gone. But I don't know rackservers =
who do
>>>>> that. Do you?
>>>>>
>>>>> Or is there maybe some kind of fake-raid card what uses mdadm to =
solve
>>>>> this problem?
>>>>>
>>>>> Another way would be to use e.g. an USB device to boot to solve t=
his
>>>>> problem. Any experiences with that?
>>>>>
>>>>> (hmm, I realize that netboot is an option too).
>>>>>
>>>>> With regards,
>>>>> Paul van der Vlis.
>>>>>
>>>>>
>>>>> --
>>>>> http://www.vandervlis.nl
>>>>>
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-r=
aid" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.htm=
l
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-ra=
id" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>=20


> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--=20
Best regards,
[COOLCOLD-RIPN]

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
