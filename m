From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: RAID HDDs spin up sequence
Date: Mon, 31 Jan 2011 19:35:29 -0200
Message-ID: <AANLkTi=OBPdygcrCoEp1ypwYsdtyw0e-a7_pjPNG3ASL@mail.gmail.com>
References: <20110131201823.GA15704@lazy.lzy>
	<AANLkTinPTaDfVtjMfz7DHUa95cKFF7MZeg=WhuuTnZM8@mail.gmail.com>
	<AANLkTi=Q7E5xhOxXA5KusWgpSb97hnmnbcm0fD1C9N5w@mail.gmail.com>
	<AANLkTikpRciBnYkoMwPFniEfPZinSKF=wiY3zvBRXh2q@mail.gmail.com>
	<AANLkTingP1aKn2a3yrfN6W7zY-KcP8tLHvh+HxfLOGjs@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTingP1aKn2a3yrfN6W7zY-KcP8tLHvh+HxfLOGjs@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

i think yes (hd wake up on write/read command)
check linear and stripe layout
linear is like a lvm (concatenation)
i think raid0 work like stripe, but need to check it and return (raid0
=3D 0 =3D stripe level,  linear!=3Draid0 for linux implementation)

2011/1/31 Mathias Bur=E9n <mathias.buren@gmail.com>:
> On 31 January 2011 21:25, Roberto Spadim <roberto@spadim.com.br> wrot=
e:
>> just if you need information on all disks
>> define your read. are you reading 1 byte or many bytes (on all hds?)
>> the number of bytes read/write is the point
>> if you need another disk to read/write you need to wake up your anot=
her hd
>>
>> check this implementations on mdadm:
>> linear, raid0, 0, stripe
>> maybe one is better for low power than another, but maybe one is
>> faster than another
>>
>> 2011/1/31 Mathias Bur=E9n <mathias.buren@gmail.com>:
>>> On 31 January 2011 21:09, Roberto Spadim <roberto@spadim.com.br> wr=
ote:
>>>> you psu must be dimensioned to work with everythink at full work l=
oad
>>>> (it=B4s a real production NAS right?! not a test)
>>>> your SAS/IDE/SATA controller and HDD manual should be checked
>>>> how hdd wake up? one command (read/write) over sata/sas/ide channe=
l wake it up?
>>>> on linux raid we have a read algorithm and a write algorithm
>>>> if a raid1 write occur all disks will wake up
>>>> if a raid1 (raid0 or another) read occur only the disk will wake u=
p
>>>>
>>>> but check you SATA/IDE/SATA controller, how it wake up your disk, =
and
>>>> how you hdd wake up
>>>>
>>>> 2011/1/31 Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>:
>>>>> Hi all,
>>>>>
>>>>> assuming there is a NAS, with, for example, 10 HDDs
>>>>> in RAID-6. Assuming the HDDs are put in standby, in
>>>>> order to save energy, when the NAS is not used.
>>>>> How is the spin up sequence when the corresponding
>>>>> /dev/mdX device is accessed?
>>>>> Will the system spin up one HDD at time or all together?
>>>>>
>>>>> Obviously, one at time will limit the peak current,
>>>>> thus allowing a better dimensioned PSU, working almost
>>>>> always around the optimal efficiency point.
>>>>>
>>>>> Thanks a lot for any information on the topic,
>>>>>
>>>>> bye,
>>>>>
>>>>> --
>>>>>
>>>>> piergiorgio
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-r=
aid" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.h=
tml
>>>>>
>>>>
>>>>
>>>>
>>>> --
>>>> Roberto Spadim
>>>> Spadim Technology / SPAEmpresarial
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-ra=
id" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.ht=
ml
>>>>
>>>
>>> I would guess, that on a RAID0 setup, any read to that md device wo=
uld
>>> wake every disk up in that setup. No?
>>>
>>> // Mathias
>>>
>>>
>>
>>
>>
>> --
>> Roberto Spadim
>> Spadim Technology / SPAEmpresarial
>>
>
> I meant "default RAID0 setup with mdadm", with a minimum of 2 HDDs,
> and any fs on top of that. (with or without lvm)
>
> Unless the file is very small (smaller than the minimum piece of data
> that's being spread across all devices in the RAID0 setup (btw, that'=
s
> this called in RAID0, is it chunk size? Stripe size?)) or cached,
> you'll wake the HDDs up. Right?
>
> // Mathias
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
