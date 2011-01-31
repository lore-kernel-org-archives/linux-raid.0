From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: RAID HDDs spin up sequence
Date: Mon, 31 Jan 2011 21:29:29 +0000
Message-ID: <AANLkTingP1aKn2a3yrfN6W7zY-KcP8tLHvh+HxfLOGjs@mail.gmail.com>
References: <20110131201823.GA15704@lazy.lzy>
	<AANLkTinPTaDfVtjMfz7DHUa95cKFF7MZeg=WhuuTnZM8@mail.gmail.com>
	<AANLkTi=Q7E5xhOxXA5KusWgpSb97hnmnbcm0fD1C9N5w@mail.gmail.com>
	<AANLkTikpRciBnYkoMwPFniEfPZinSKF=wiY3zvBRXh2q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTikpRciBnYkoMwPFniEfPZinSKF=wiY3zvBRXh2q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 31 January 2011 21:25, Roberto Spadim <roberto@spadim.com.br> wrote:
> just if you need information on all disks
> define your read. are you reading 1 byte or many bytes (on all hds?)
> the number of bytes read/write is the point
> if you need another disk to read/write you need to wake up your anoth=
er hd
>
> check this implementations on mdadm:
> linear, raid0, 0, stripe
> maybe one is better for low power than another, but maybe one is
> faster than another
>
> 2011/1/31 Mathias Bur=C3=A9n <mathias.buren@gmail.com>:
>> On 31 January 2011 21:09, Roberto Spadim <roberto@spadim.com.br> wro=
te:
>>> you psu must be dimensioned to work with everythink at full work lo=
ad
>>> (it=C2=B4s a real production NAS right?! not a test)
>>> your SAS/IDE/SATA controller and HDD manual should be checked
>>> how hdd wake up? one command (read/write) over sata/sas/ide channel=
 wake it up?
>>> on linux raid we have a read algorithm and a write algorithm
>>> if a raid1 write occur all disks will wake up
>>> if a raid1 (raid0 or another) read occur only the disk will wake up
>>>
>>> but check you SATA/IDE/SATA controller, how it wake up your disk, a=
nd
>>> how you hdd wake up
>>>
>>> 2011/1/31 Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>:
>>>> Hi all,
>>>>
>>>> assuming there is a NAS, with, for example, 10 HDDs
>>>> in RAID-6. Assuming the HDDs are put in standby, in
>>>> order to save energy, when the NAS is not used.
>>>> How is the spin up sequence when the corresponding
>>>> /dev/mdX device is accessed?
>>>> Will the system spin up one HDD at time or all together?
>>>>
>>>> Obviously, one at time will limit the peak current,
>>>> thus allowing a better dimensioned PSU, working almost
>>>> always around the optimal efficiency point.
>>>>
>>>> Thanks a lot for any information on the topic,
>>>>
>>>> bye,
>>>>
>>>> --
>>>>
>>>> piergiorgio
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-ra=
id" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info=
=2Ehtml
>>>>
>>>
>>>
>>>
>>> --
>>> Roberto Spadim
>>> Spadim Technology / SPAEmpresarial
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.=
html
>>>
>>
>> I would guess, that on a RAID0 setup, any read to that md device wou=
ld
>> wake every disk up in that setup. No?
>>
>> // Mathias
>>
>>
>
>
>
> --
> Roberto Spadim
> Spadim Technology / SPAEmpresarial
>

I meant "default RAID0 setup with mdadm", with a minimum of 2 HDDs,
and any fs on top of that. (with or without lvm)

Unless the file is very small (smaller than the minimum piece of data
that's being spread across all devices in the RAID0 setup (btw, that's
this called in RAID0, is it chunk size? Stripe size?)) or cached,
you'll wake the HDDs up. Right?

// Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
