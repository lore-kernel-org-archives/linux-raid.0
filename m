From: Chris Murphy <lists@colorremedies.com>
Subject: Re: recommended way to add ssd cache to mdraid array
Date: Fri, 11 Jan 2013 20:56:19 -0700
Message-ID: <4424E5BF-CDA7-4888-8C0F-988D20D8C2F7@colorremedies.com>
References: <201212212357.19292.thomas@fjellstrom.ca> <201301100349.46794.thomas@fjellstrom.ca> <6FD79D70-01A4-4DC9-9494-157773CD0F11@colorremedies.com> <201301110520.07128.thomas@fjellstrom.ca> <5C8F4DE0-5C1E-476F-BBA8-17A7D695E599@colorremedies.com> <3EE4457C-A185-4223-A84D-5BFBB204A94C@colorremedies.com> <50F0B2B7.1080604@turmel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50F0B2B7.1080604@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Jan 11, 2013, at 5:47 PM, Phil Turmel <philip@turmel.org> wrote:

> On 01/11/2013 12:46 PM, Chris Murphy wrote:
>>=20
>> On Jan 11, 2013, at 10:39 AM, Chris Murphy <lists@colorremedies.com>
>> wrote:
>>>=20
>>> They probably have a high ERC time out as all consumer disks do so
>>> you should also check /sys/block/sdX/device/timeout and make sure
>>> it's not significantly less than the drive. It may be possible for
>>> smartctl or hdparm to figure out what the drive ERC timeout is.
>>>=20
>>> http://cgi.csc.liv.ac.uk/~greg/projects/erc/
>>=20
>> Actually what I wrote is misleading to the point it's wrong. You wan=
t
>> the linux device time out to be greater than the device timeout. The
>> device needs to be allowed to give up, and report back a read error
>> to linux/md, so that md knows it should reconstruct the missing data
>> from parity, and overwrite the (obviously) bad blocks causing the
>> read error.
>>=20
>> If the linux device time out is even a little bit less than the
>> drive's timeout, md never gets the sector read error, doesn't repair
>> it, since linux boots the whole drive. Now instead of repairing a fe=
w
>> sectors, you have a degraded array on your hands. Usual consumer
>> drive time outs are quite high, they can be up to a couple minutes
>> long. Linux device time out is 30 seconds.
>=20
> This isn't quite right.  When the linux driver stack times out, it
> passes the error to MD.  MD doesn't care if the drive reported the
> error, or if the controller reported the error, it just knows that it
> couldn't read that block.  It goes to recovery, which typically
> generates the replacement data in a few milliseconds, and tries to wr=
ite
> back to the first disk.  *That* instantly fails, since the controller=
 is
> resetting the link and the drive is still in la-la land trying to rea=
d
> the data.  MD will tolerate several bad reads before it kicks out a
> drive, but will immediately kick if a write fails.
>=20
> By the time you come to investigate, the drive has completed its
> timeout, the link has reset, and the otherwise good drive is sitting
> idle (failed).

I admit I omitted the handling of the error md gets in the case of linu=
x itself timing out the drive, because I don't know how that's handled.=
 For example:=20

When you say, "the linux driver stack times out, it passes the error to=
 MD," what error is passed? Is it the same (I think it's 0x40) read err=
or that the drive would have produced, along with affected LBAs? Does t=
he driver know the affected LBA's, maybe by inference? Otherwise md wou=
ldn't know what replacement data to generate. Or is it a different erro=
r, neither a read nor write error, that causes md to bounce the drive w=
holesale?

>=20
> Any array running with mismatched timeouts will kick a drive on every
> unrecoverable read error, where it would likely have just fixed it.

This is the key phrase I was trying to get at.=20

> Sadly, many hobbyist arrays are built with desktop drives, and the
> timeouts are left mismatched.  When that hobbyist later learns s/he
> should be scrubbing, the long-overdue scrub is very likely to produce
> UREs on multiple drives (BOOM).

Or even if they have been scrubbing all along. If the drive recovers th=
e data inside of 30 seconds, and also doesn't relocated the data to a n=
ew sector (? I have no idea when drives do this on their own; I know th=
ey will do it on a write failure but I'm unclear when they do it on per=
sistent read "difficulty") the scrub has no means  of even being aware =
there's a problem to fix!

Given the craptastic state of affairs that manufacturers disallow a sim=
ple setting change to ask the drive to do LESS error correction, the re=
commendation to buy a different drive that can be so configured, is the=
 best suggestion. Alternative 1 is to change the linux driver timeout t=
o maybe upwards of two minutes, and then deal with the fall out of that=
 behavior, which could be worse than a drive being booted out of the ar=
ray sooner. And a very distant alternative 2 is to zero or Secure Erase=
 the drive every so often, in hopes of avoiding bad sectors altogether =
=97 is tedious, as well as implies either putting the drive into a degr=
aded state, or cycling a spare drive. And at the point you're going to =
buy a spare drive for this fiasco, you might as well just buy drives su=
ited for the purpose.

How's that?


Chris Murphy--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
