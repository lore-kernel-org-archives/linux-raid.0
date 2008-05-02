From: Kasper Sandberg <lkml@metanurb.dk>
Subject: Re: Sharing disks amoung multiple software RAIDs
Date: Fri, 02 May 2008 23:43:50 +0200
Message-ID: <1209764630.7827.15.camel@localhost>
References: <1209692359.16523.2.camel@localhost>
	 <73000.21239.qm@web50212.mail.re2.yahoo.com>
	 <A20315AE59B5C34585629E258D76A97C335477@34093-C3-EVS3.exchange.rackspace.com>
	 <1209696179.16523.13.camel@localhost>
	 <72dbd3150805020006p7f976a04o487389840f03b4a2@mail.gmail.com>
	 <1209715763.7827.2.camel@localhost>  <481AD006.6050708@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <481AD006.6050708@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: David Rees <drees76@gmail.com>, David Lethe <david@santools.com>, alex14641@yahoo.com, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 2008-05-02 at 09:25 +0100, David Greaves wrote:
> Kasper Sandberg wrote:
> > Im not treating it as a backup, what i want, is to make sure that i=
f 1
> > disk dies, the data is still intact and ill hopefully be able to ru=
n
> > with 1 disk till the newly ordered one arrives
> Probably one of the main design objectives behind RAID/md

Exactly, but once people start saying: "Look how many problems people
post to the thread on
a weekly basis where people lose their data when md rebuilds go bad wit=
h
non-shared disks" i begin to worry..

>=20
> > So my question remains.. Is md raid1 not suited for this need? woul=
d it
> > be safer to run in non-raid1 mode and daily(maybe hourly) rsync
> > everything over to the second disk?
>=20
> md is 100% guaranteed perfect or your money back...
> rsync is 100% guaranteed perfect or your money back...
> your backups are 100% guaranteed perfect or your money back...
> your hard drives are 100% guaranteed perfect or your money back...
> your CPU and RAM are 100% guaranteed perfect or your money back...
> your CPU and PSU fans are 100% guaranteed perfect or your money back.=
=2E.
>=20
> Clearly if you want to panic over reliability you have lots of choice=
s :)

I do not wish to panic, i merely wished to know if linux MD is believed
to work in most cases, or believed to do all sorts of weird stuff when
resyncing :)

>=20
> David
> PS, FWIW md has saved my data* countless times over the past 'n' year=
s in
> exactly the scenario you describe.

It has also been useful to people i know, i just wished to be sure :)
and as Keld J=F8rn Simonsen and Helge Hafting's comments seems to confi=
rm,
linux md IS nice and stable :)

and as said, what im looking for isnt an in-box backup solution, merely
safety in case one disk burns :)

>=20
> *(or more accurately has saved me from having to restore my data)

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
