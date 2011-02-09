From: "Scott E. Armitage" <launchpad@scott.armitage.name>
Subject: Re: SSD - TRIM command
Date: Wed, 9 Feb 2011 10:00:30 -0500
Message-ID: <AANLkTik6D-r1ZbgxEACHZK9760pcUBB+3e7wVX3oqrKP@mail.gmail.com>
References: <AANLkTikfeH_n04iJ=5e=_G4a_GrxiWyZNJ1oCYyiBhNO@mail.gmail.com>
	<4D517F4F.4060003@gmail.com>
	<4D5245DF.4020401@hardwarefreak.com>
	<iiu4rc$9ju$1@dough.gmane.org>
	<AANLkTi=WNk3=3Jwm-YJeujcrdh-OQ4W4mJrq+YJ5Xv4k@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=WNk3=3Jwm-YJeujcrdh-OQ4W4mJrq+YJ5Xv4k@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: David Brown <david@westcontrol.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I reiterate my previous reply that under the current md architecture,
where the complete device is considered to be in use, sending TRIM
commands makes little sense. AFAICT, reading back a trimmed page is
not defined, since the whole idea is that the host doesn't care about
what is on that page any more.

The next time md comes around to corresponding trimmed pages on two
SSDs, their contents may differ, and all of a sudden our array is no
longer consistent.

On Wed, Feb 9, 2011 at 9:39 AM, Roberto Spadim <roberto@spadim.com.br> =
wrote:
> guys...
> if my ssd fail, i buy another...
> let's make software ok, the hardware is another problem
> raid1 should work with floppy disks, hard disks, ssd, nbd... that's t=
he point
> make solutions for hardware mix
> the question is simple, could we send TRIM command to all mirrors (fo=
r
> stripe just disks that should receive it)? if device don't have TRIM
> we should translate it for a similar command, with the same READ
> effect (no problem if it's not atomic)
>
> the point of good read, i sent a email to maurice, and many others
> emails in this raid list, there's a new read balance mode for kernel
> 2.6.37 if you want try to benchmark it please test it:
> www.spadim.com.br/raid1
> for me it's work very well with hd and ssd mixed array, i need more
> test and benchmark to neil accept it as a default feature of md
> the sysfs interface is poor yet, in future it should change
> the time based mode work, but it should have some features implemente=
d
> in futures (queue time estimation)
>
>
> 2011/2/9 David Brown <david@westcontrol.com>:
>> On 09/02/2011 08:44, Stan Hoeppner wrote:
>>>
>>> maurice put forth on 2/8/2011 11:37 AM:
>>>>
>>>> On 2/7/2011 1:07 PM, Roberto Spadim wrote:
>>>>>
>>>>> hi guys, could md send TRIM command to ssd? using ext4 discart
>>>>> mount option? if i mix ssd and hd, could this TRIM be rewrite to
>>>>> non TRIM compatible disks?
>>>>>
>>>> I have read that using md with SSDs is not a great idea: Form the
>>>> Fedora 14 documentation:
>>>
>>> Using any RAID level but pure striping with SSDs is a bad idea, for
>>> the exact reason in that documentation: =A0excessive writes.
>>>
>>> SSD - Solid State Drive
>>>
>>> Note the first two words. =A0Solid state device =3D integrated circ=
uit.
>>> ICs, including those comprised of flash memory transistors, have
>>> totally different failure modes than spinning rust disks, SRDs, or
>>> "plain old mechanical hard drives".
>>>
>>> RAID'ing SSDs with any data duplicative RAID level, any mirroring o=
r
>>> parity RAID levels, _decreases_ the life of all SSDs in the array.
>>> This is the opposite effect of what you want: =A0reliability and
>>> lifespan.
>>>
>>> People have a misconception that SSDs are like hard disks. =A0The o=
nly
>>> thing they have in common is that both store data and they can have=
 a
>>> similar interface (SATA). =A0The similarities end there.
>>>
>>> RAID is not a proper method of extending the life of SSD storage no=
r
>>> protecting the data on SSD devices. =A0If you want to pool all the
>>> capacity of multiple SSDs into a single logical device, use RAID 0 =
or
>>> spanning, _not_ a mirror or parity RAID level. =A0If you want to
>>> protect the data, snap it to a single large SATA drive, or a D2D
>>> backup array, and then to tape.
>>>
>>
>> First off, let me agree with you that backup is important no matter =
what you
>> use as your primary storage.
>>
>> But beyond that, you've got a basic assumption wrong here.
>>
>> Good quality, modern SSDs do not have write-endurance issues. =A0It'=
s a thing
>> of the past. =A0Internally, of course, the flash /does/ have enduran=
ce limits.
>> =A0But these are high (especially with SLC devices rather than MLC d=
evices),
>> and the combination of ECC, wear-levelling and redundant blocks mean=
s that
>> you can write to these devices continuously at high speed for /years=
/ before
>> endurance issues become visible by the host. =A0An additional effect=
 of the
>> extensive ECC is that undetected read errors are much less likely th=
an with
>> hard disks - when a failure /does/ occur, you know it has occurred.
>>
>> Many SSD models suffer from a certain amount of performance degradat=
ion when
>> they have been used for a while. =A0Intel's devices were notorious f=
or this,
>> though apparently they are better now. =A0But that's a speed issue, =
not a
>> reliability or lifetime issue.
>>
>> SSDs (again, I refer to good quality modern devices - earlier models=
 had
>> more problems) are inherently more reliable than HDs, and have longe=
r
>> expected lifetimes. =A0This means that it is often fine to put your =
SSDs in a
>> RAID0 combination - you still have a greater reliability than you wo=
uld with
>> a single HDD.
>>
>> However, SSDs are not infallible - using redundant RAID with SSDs is=
 a
>> perfectly valid setup. =A0Obviously you will have a whole disks wort=
h of extra
>> writes when you set up the RAID, and redundant writes means more wri=
tes, but
>> the SSDs will handle those writes perfectly well.
>>
>>
>> There is plenty of scope for md / SSD optimisation, however. =A0Good=
 TRIM
>> support is just one aspect. =A0Other points include matching stripe =
sizes to
>> fit the geometry of the SSD, and taking advantage of the seek speeds=
 of SSD
>> (this is particularly important if you are mirroring an SSD and an H=
D).
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
>
>
> --
> Roberto Spadim
> Spadim Technology / SPAEmpresarial
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Scott Armitage, B.A.Sc., M.A.Sc. candidate
Space Flight Laboratory
University of Toronto Institute for Aerospace Studies
4925 Dufferin Street, Toronto, Ontario, Canada, M3H 5T6
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
