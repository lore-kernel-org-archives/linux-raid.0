From: Chris Murphy <lists@colorremedies.com>
Subject: Re: recommended way to add ssd cache to mdraid array
Date: Sun, 13 Jan 2013 16:20:43 -0700
Message-ID: <9974543B-24D0-46E9-9852-09DE1C2F6D12@colorremedies.com>
References: <201212212357.19292.thomas@fjellstrom.ca> <201301100349.46794.thomas@fjellstrom.ca> <6FD79D70-01A4-4DC9-9494-157773CD0F11@colorremedies.com> <201301110520.07128.thomas@fjellstrom.ca> <5C8F4DE0-5C1E-476F-BBA8-17A7D695E599@colorremedies.com> <3EE4457C-A185-4223-A84D-5BFBB204A94C@colorremedies.com> <50F0B2B7.1080604@turmel.org> <4424E5BF-CDA7-4888-8C0F-988D20D8C2F7@colorremedies.com> <50F33198.9060302@turmel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50F33198.9060302@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Jan 13, 2013, at 3:13 PM, Phil Turmel <philip@turmel.org> wrote:
>=20
> I haven't examined the code in detail, just watched patches pass on t=
he
> list.  :-)  But as I understand it, the error is returned with the
> request that it belongs to, and the MD does not look at the drive err=
or
> code itself.  So MD know what read it was, for which member devices, =
but
> doesn't care if the error came from the drive itself, or the controll=
er,
> or the driver.

I think it does, but I don't know diddly about the code.

Only the drive knows what LBA's exhibit read and write errors. The linu=
x driver doesn't. And the linux driver times out after 30 seconds by de=
fault, which is an eternity. There isn't just one request pending. Ther=
e are dozens to hundreds of pending commands, representing possibly ten=
s of thousands of LBAs in the drive's own cache. Once the drive goes in=
to sector recovery, I'm pretty sure SATA drives, unlike SAS, basically =
go silent. That's probably when the linux timeout counter starts, in th=
e meantime md is still talking to the linux driver making more requests=
=2E

This is a huge pile of just requests, not even the data it represents. =
Some of those requests made it to the drive, some are with the linux dr=
iver. I think it's much easier/efficient, when linux block device drive=
r timeout arrives, for the linux driver to just nullify all requests, g=
ives the drive the boot (lalala i can't hear you i don't care if you st=
art talking to me again in 60 seconds), and tells md with a single erro=
r that the drive isn't even available. And I'd expect md does the only =
thing it can do if it gets such an error which is the same as a write e=
rror; it flags the device in the array as faulty. I'd be surprised if i=
t tried to reconstruct data at all in such a case, without an explicit =
read error and LBA reported by the drive.

But I don't know the code, so I'm talking out my ass.


>>=20
>>> Any array running with mismatched timeouts will kick a drive on=20
>>> every unrecoverable read error, where it would likely have just=20
>>> fixed it.
>>=20
>> This is the key phrase I was trying to get at.
>>=20
>>> Sadly, many hobbyist arrays are built with desktop drives, and the
>>> timeouts are left mismatched.  When that hobbyist later learns
>>> s/he should be scrubbing, the long-overdue scrub is very likely to
>>> produce UREs on multiple drives (BOOM).
>>=20
>> Or even if they have been scrubbing all along.
>=20
> Yes.  But in that case, they've probably lost arrays without
> understanding why.

Maybe. I don't have data on this. If recovery occurs in less than 30 se=
conds, they effectively get no indication. They'd have to be looking at=
 ECC errors recorded by SMART. And not all drives record that attribute=
=2E

>> If the drive recovers the data inside of 30 seconds, and also doesn'=
t
>> relocated the data to a new sector (? I have no idea when drives do
>> this on their own; I know they will do it on a write failure but I'm
>> unclear when they do it on persistent read "difficulty") the scrub
>> has no means  of even being aware there's a problem to fix!
>=20
> I understand that it varies.  But drives generally only reallocate on=
 a
> write, and only if they are primed to verify the write at that sector=
 by
> a previous URE at that spot.  Those show up in a smartctl report as
> "Pending".

I'm pretty sure that attribute 197, usually called current pending sect=
or, is only due to unrecoverable read error. Not from a sector that ECC=
 detects transient read error and can correct for. The uncorrectable er=
ror, the firmware doesn't want to relocate the data on the sector becau=
se it clearly can't get it correct, so it just leaves it there until th=
e sector is written and if on write there's persistent write failure, i=
t gets remapped to a reserve sector. I don't know off hand if there is =
a read specific remap count, but attribute 5 'reallocated sectors' appe=
ars to be read or write remaps. *shrug*

I have several HDDs that have attribute 197, but not attribute 5. And a=
n SSD with only attribute 5, not 197.


>=20
>> Given the craptastic state of affairs that manufacturers disallow a=20
>> simple setting change to ask the drive to do LESS error correction,=20
>> the recommendation to buy a different drive that can be so=20
>> configured, is the best suggestion.
>=20
> For a while, it was Hitachi Deskstar or enterprise.  Western Digital'=
s
> new "Red" series appears to be an attempt to deal with the backlash.

Yeah I know. :-) But I mean all drives could have this. It's a request =
for LESS, not more. I'm not asking for better ECC, although that would =
be nice, merely a faster time out as a settable option.

>=20
>> And a very distant alternative 2 is to zero or Secure Erase the driv=
e
>> every so often, in hopes of avoiding bad sectors altogether =97 is
>> tedious, as well as implies either putting the drive into a degraded
>> state, or cycling a spare drive.
>=20
> No.  This still isn't safe.  UREs can happen at any time, and are spe=
c'd
> to occur at about every 12TB read.  Even on a freshly wiped drive.
> Spares don't help either, as a rebuild onto a spare stresses the rest=
 of
> the array, and is likely to expose any developing UREs.

Technically the spec statistic is "less than" 1 bit in 10^14 for a cons=
umer disk. So it's not that you will get a URE at 12TB, but that you sh=
ould be able to read at least 11.37TiB without a URE. It's entirely wit=
hin the tolerance if the mean occurrence happens 2 bits shy of 10^15 bi=
ts, or 113TiB. By using "less than" the value is not a mean. It's likel=
y a lot higher than 12TB, or we'd have total mayhem by now. That's only=
 3 reads of a 4TB drive otherwise. It's bad, but not that bad.


>=20
>> And at the point you're going to buy a spare drive for this fiasco,=20
>> you might as well just buy drives suited for the purpose.
>=20
> Options are:
>=20
> A) Buy Enterprise drives.  They have appropriate error timeouts and w=
ork
> properly with MD right out of the box.
>=20
> B) Buy Desktop drives with SCTERC support.  They have inappropriate
> default timeouts, but can be set to an appropriate value.  Udev or bo=
ot
> script assistance is needed to call smartctl to set it.  They do *not=
*
> work properly with MD out of the box.
>=20
> C) Suffer with desktop drives without SCTERC support.  They cannot be
> set to appropriate error timeouts.  Udev or boot script assistance is
> needed to set a 120 second driver timeout in sysfs.  They do *not* wo=
rk
> properly with MD out of the box.
>=20
> D) Lose your data during spare rebuild after your first URE.  (Odds i=
n
> proportion to array size.)

That's a good summary.


>=20
> One last point bears repeating:  MD is *not* a backup system, althoug=
h
> some people leverage it's features for rotating off-site backup disks=
=2E
> Raid arrays are all about *uptime*.  They will not save you from
> accidental deletion or other operator errors.  They will not save you=
 if
> your office burns down.  You need a separate backup system for critic=
al
> files.

Yeah and that's why I'm sorta leery of this RAID 6 setup in the home. I=
 think that people are reading that the odds of an array failure with R=
AID 5 are so high that they are better off adding one more drive for du=
al-parity, and *still* not having a real backup and restore plan. As if=
 the RAID 6 is the faux-backup plan.

Some home NAS's, with BluRay vids, are so big that people just either n=
eed to stop such behavior, or get a used LTO 2 or 3 drive for their gar=
gantuous backups.

Chris--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
