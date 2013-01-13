From: Phil Turmel <philip@turmel.org>
Subject: Re: recommended way to add ssd cache to mdraid array
Date: Sun, 13 Jan 2013 17:13:44 -0500
Message-ID: <50F33198.9060302@turmel.org>
References: <201212212357.19292.thomas@fjellstrom.ca> <201301100349.46794.thomas@fjellstrom.ca> <6FD79D70-01A4-4DC9-9494-157773CD0F11@colorremedies.com> <201301110520.07128.thomas@fjellstrom.ca> <5C8F4DE0-5C1E-476F-BBA8-17A7D695E599@colorremedies.com> <3EE4457C-A185-4223-A84D-5BFBB204A94C@colorremedies.com> <50F0B2B7.1080604@turmel.org> <4424E5BF-CDA7-4888-8C0F-988D20D8C2F7@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4424E5BF-CDA7-4888-8C0F-988D20D8C2F7@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-raid Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 01/11/2013 10:56 PM, Chris Murphy wrote:
>=20
> On Jan 11, 2013, at 5:47 PM, Phil Turmel <philip@turmel.org> wrote:

[trim /]

>> This isn't quite right.  When the linux driver stack times out, it
>>  passes the error to MD.  MD doesn't care if the drive reported the
>>  error, or if the controller reported the error, it just knows
>> that it couldn't read that block.  It goes to recovery, which
>> typically generates the replacement data in a few milliseconds, and
>> tries to write back to the first disk.  *That* instantly fails,
>> since the controller is resetting the link and the drive is still
>> in la-la land trying to read the data.  MD will tolerate several
>> bad reads before it kicks out a drive, but will immediately kick if
>> a write fails.
>>=20
>> By the time you come to investigate, the drive has completed its=20
>> timeout, the link has reset, and the otherwise good drive is=20
>> sitting idle (failed).
>=20
> I admit I omitted the handling of the error md gets in the case of=20
> linux itself timing out the drive, because I don't know how that's=20
> handled. For example:
>=20
> When you say, "the linux driver stack times out, it passes the error=20
> to MD," what error is passed? Is it the same (I think it's 0x40) read
> error that the drive would have produced, along with affected LBAs?
> Does the driver know the affected LBA's, maybe by inference?=20
> Otherwise md wouldn't know what replacement data to generate. Or is=20
> it a different error, neither a read nor write error, that causes md=20
> to bounce the drive wholesale?

I haven't examined the code in detail, just watched patches pass on the
list.  :-)  But as I understand it, the error is returned with the
request that it belongs to, and the MD does not look at the drive error
code itself.  So MD know what read it was, for which member devices, bu=
t
doesn't care if the error came from the drive itself, or the controller=
,
or the driver.
>=20
>> Any array running with mismatched timeouts will kick a drive on=20
>> every unrecoverable read error, where it would likely have just=20
>> fixed it.
>=20
> This is the key phrase I was trying to get at.
>=20
>> Sadly, many hobbyist arrays are built with desktop drives, and the
>>  timeouts are left mismatched.  When that hobbyist later learns
>> s/he should be scrubbing, the long-overdue scrub is very likely to
>>  produce UREs on multiple drives (BOOM).
>=20
> Or even if they have been scrubbing all along.

Yes.  But in that case, they've probably lost arrays without
understanding why.

> If the drive recovers the data inside of 30 seconds, and also doesn't
> relocated the data to a new sector (? I have no idea when drives do
> this on their own; I know they will do it on a write failure but I'm
> unclear when they do it on persistent read "difficulty") the scrub
> has no means  of even being aware there's a problem to fix!

I understand that it varies.  But drives generally only reallocate on a
write, and only if they are primed to verify the write at that sector b=
y
a previous URE at that spot.  Those show up in a smartctl report as
"Pending".

> Given the craptastic state of affairs that manufacturers disallow a=20
> simple setting change to ask the drive to do LESS error correction,=20
> the recommendation to buy a different drive that can be so=20
> configured, is the best suggestion.

=46or a while, it was Hitachi Deskstar or enterprise.  Western Digital'=
s
new "Red" series appears to be an attempt to deal with the backlash.

> Alternative 1 is to change the linux driver timeout to maybe upwards
>  of two minutes, and then deal with the fall out of that behavior,=20
> which could be worse than a drive being booted out of the array=20
> sooner.

Yes.  Some servers will time out a connection in 90 seconds if a reply
is delayed.  To be safe with desktop drives, a timeout of 120 seconds
seems to be necessary.  I wouldn't be surprised if certain drives neede=
d
more, but I have insufficient experience.

> And a very distant alternative 2 is to zero or Secure Erase the drive
> every so often, in hopes of avoiding bad sectors altogether =E2=80=94=
 is
> tedious, as well as implies either putting the drive into a degraded
> state, or cycling a spare drive.

No.  This still isn't safe.  UREs can happen at any time, and are spec'=
d
to occur at about every 12TB read.  Even on a freshly wiped drive.
Spares don't help either, as a rebuild onto a spare stresses the rest o=
f
the array, and is likely to expose any developing UREs.

> And at the point you're going to buy a spare drive for this fiasco,=20
> you might as well just buy drives suited for the purpose.

Options are:

A) Buy Enterprise drives.  They have appropriate error timeouts and wor=
k
properly with MD right out of the box.

B) Buy Desktop drives with SCTERC support.  They have inappropriate
default timeouts, but can be set to an appropriate value.  Udev or boot
script assistance is needed to call smartctl to set it.  They do *not*
work properly with MD out of the box.

C) Suffer with desktop drives without SCTERC support.  They cannot be
set to appropriate error timeouts.  Udev or boot script assistance is
needed to set a 120 second driver timeout in sysfs.  They do *not* work
properly with MD out of the box.

D) Lose your data during spare rebuild after your first URE.  (Odds in
proportion to array size.)

One last point bears repeating:  MD is *not* a backup system, although
some people leverage it's features for rotating off-site backup disks.
Raid arrays are all about *uptime*.  They will not save you from
accidental deletion or other operator errors.  They will not save you i=
f
your office burns down.  You need a separate backup system for critical
files.

Phil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
