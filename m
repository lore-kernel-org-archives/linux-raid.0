From: Phil Turmel <philip@turmel.org>
Subject: Re: recommended way to add ssd cache to mdraid array
Date: Sun, 13 Jan 2013 19:23:55 -0500
Message-ID: <50F3501B.30002@turmel.org>
References: <201212212357.19292.thomas@fjellstrom.ca> <201301100349.46794.thomas@fjellstrom.ca> <6FD79D70-01A4-4DC9-9494-157773CD0F11@colorremedies.com> <201301110520.07128.thomas@fjellstrom.ca> <5C8F4DE0-5C1E-476F-BBA8-17A7D695E599@colorremedies.com> <3EE4457C-A185-4223-A84D-5BFBB204A94C@colorremedies.com> <50F0B2B7.1080604@turmel.org> <4424E5BF-CDA7-4888-8C0F-988D20D8C2F7@colorremedies.com> <50F33198.9060302@turmel.org> <9974543B-24D0-46E9-9852-09DE1C2F6D12@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <9974543B-24D0-46E9-9852-09DE1C2F6D12@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-raid Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 01/13/2013 06:20 PM, Chris Murphy wrote:
>=20
> On Jan 13, 2013, at 3:13 PM, Phil Turmel <philip@turmel.org> wrote:
>>=20
>> I haven't examined the code in detail, just watched patches pass on
>> the list.  :-)  But as I understand it, the error is returned with
>> the request that it belongs to, and the MD does not look at the
>> drive error code itself.  So MD know what read it was, for which
>> member devices, but doesn't care if the error came from the drive
>> itself, or the controller, or the driver.
>=20
> I think it does, but I don't know diddly about the code.

If you think about this, you'll realize that the driver *must* keep
track of every unique request for the block device.  Otherwise, how
would MD know what data was read and ready to use?  And what data was
written so its buffer could be freed?  Reads are distinct from writes.

> Only the drive knows what LBA's exhibit read and write errors. The
> linux driver doesn't. And the linux driver times out after 30 seconds
> by default, which is an eternity. There isn't just one request
> pending. There are dozens to hundreds of pending commands,
> representing possibly tens of thousands of LBAs in the drive's own
> cache.

But reads are separate from writes, and MD handles them differently.
See the "md" man-page under "Recovery".

> Once the drive goes into sector recovery, I'm pretty sure SATA
> drives, unlike SAS, basically go silent. That's probably when the
> linux timeout counter starts, in the meantime md is still talking to
> the linux driver making more requests.
>=20
> This is a huge pile of just requests, not even the data it
> represents. Some of those requests made it to the drive, some are
> with the linux driver. I think it's much easier/efficient, when linux
> block device driver timeout arrives, for the linux driver to just
> nullify all requests, gives the drive the boot (lalala i can't hear
> you i don't care if you start talking to me again in 60 seconds), and
> tells md with a single error that the drive isn't even available. And
> I'd expect md does the only thing it can do if it gets such an error
> which is the same as a write error; it flags the device in the array
> as faulty. I'd be surprised if it tried to reconstruct data at all in
> such a case, without an explicit read error and LBA reported by the
> drive.

This is just wrong.

> But I don't know the code, so I'm talking out my ass.

:-)

[trim /]

>> Yes.  But in that case, they've probably lost arrays without=20
>> understanding why.
>=20
> Maybe. I don't have data on this. If recovery occurs in less than 30
> seconds, they effectively get no indication. They'd have to be
> looking at ECC errors recorded by SMART. And not all drives record
> that attribute.

See all the assistance requests on this list where the OP says somethin=
g
to the effect of: "I don't understand! The (failed) drive appears to be=
 OK!"

[trim /]

>>> Given the craptastic state of affairs that manufacturers disallow
>>> a simple setting change to ask the drive to do LESS error
>>> correction, the recommendation to buy a different drive that can
>>> be so configured, is the best suggestion.
>>=20
>> For a while, it was Hitachi Deskstar or enterprise.  Western
>> Digital's new "Red" series appears to be an attempt to deal with
>> the backlash.
>=20
> Yeah I know. :-) But I mean all drives could have this. It's a
> request for LESS, not more. I'm not asking for better ECC, although
> that would be nice, merely a faster time out as a settable option.

You don't seem to understand:  The hard drive industry loses revenue
when people set up raid arrays with cheap drives, and then have the
temerity to return good drives that have been (arguably) misapplied.

Manufacturers have a financial interest in selling enterprise drives
instead of desktop drives, and have made desktop drives painful to use
in this application.  The manufacturers have even redefined "RAID".
Supposedly "I" now stands for "Independent" instead of "Inexpensive".

>>> And a very distant alternative 2 is to zero or Secure Erase the
>>> drive every so often, in hopes of avoiding bad sectors altogether
>>> =E2=80=94 is tedious, as well as implies either putting the drive i=
nto a
>>> degraded state, or cycling a spare drive.
>>=20
>> No.  This still isn't safe.  UREs can happen at any time, and are
>> spec'd to occur at about every 12TB read.  Even on a freshly wiped
>> drive. Spares don't help either, as a rebuild onto a spare stresses
>> the rest of the array, and is likely to expose any developing
>> UREs.
>=20
> Technically the spec statistic is "less than" 1 bit in 10^14 for a
> consumer disk. So it's not that you will get a URE at 12TB, but that
> you should be able to read at least 11.37TiB without a URE. It's
> entirely within the tolerance if the mean occurrence happens 2 bits
> shy of 10^15 bits, or 113TiB. By using "less than" the value is not a
> mean. It's likely a lot higher than 12TB, or we'd have total mayhem
> by now. That's only 3 reads of a 4TB drive otherwise. It's bad, but
> not that bad.

That's not really how the statistics work.  The spec just means that if
you run a typically drive for some long time on some workload you'll
average one URE every 10^14 bits.  What the actual shape of the
distribution is varies through the life of the drive.  IIRC, Google's
analysis was that the rate spikes early, then forms a gaussian
distribution for the bulk of the life, then spikes again as mechanical
parts wear out.

>>> And at the point you're going to buy a spare drive for this
>>> fiasco, you might as well just buy drives suited for the
>>> purpose.
>>=20
>> Options are:
>>=20
>> A) Buy Enterprise drives.  They have appropriate error timeouts and
>> work properly with MD right out of the box.
>>=20
>> B) Buy Desktop drives with SCTERC support.  They have
>> inappropriate default timeouts, but can be set to an appropriate
>> value.  Udev or boot script assistance is needed to call smartctl
>> to set it.  They do *not* work properly with MD out of the box.
>>=20
>> C) Suffer with desktop drives without SCTERC support.  They cannot
>> be set to appropriate error timeouts.  Udev or boot script
>> assistance is needed to set a 120 second driver timeout in sysfs.
>> They do *not* work properly with MD out of the box.
>>=20
>> D) Lose your data during spare rebuild after your first URE.  (Odds
>> in proportion to array size.)
>=20
> That's a good summary.

Yeah.  Not enough people hear it though.  If I was more than a very
light user, I'd be on option A.  As it is, option B is best for me.

>> One last point bears repeating:  MD is *not* a backup system,
>> although some people leverage it's features for rotating off-site
>> backup disks. Raid arrays are all about *uptime*.  They will not
>> save you from accidental deletion or other operator errors.  They
>> will not save you if your office burns down.  You need a separate
>> backup system for critical files.
>=20
> Yeah and that's why I'm sorta leery of this RAID 6 setup in the home.
> I think that people are reading that the odds of an array failure
> with RAID 5 are so high that they are better off adding one more
> drive for dual-parity, and *still* not having a real backup and
> restore plan. As if the RAID 6 is the faux-backup plan.
>=20
> Some home NAS's, with BluRay vids, are so big that people just either
> need to stop such behavior, or get a used LTO 2 or 3 drive for their
> gargantuous backups.

Well, for me, such material on hard drives *are* the backups.  I use
"par2" for big backup files, not MD raid.  I also skip backups for my
Hi-Def MythTV recordings.  Just not valuable enough.

Phil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
