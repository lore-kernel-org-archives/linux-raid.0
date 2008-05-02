From: Alex Davis <alex14641@yahoo.com>
Subject: Re: Sharing disks amoung multiple software RAIDs
Date: Fri, 2 May 2008 15:04:55 -0700 (PDT)
Message-ID: <977930.28629.qm@web50212.mail.re2.yahoo.com>
References: <1209764630.7827.15.camel@localhost>
Reply-To: alex14641@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1763973AbYEBWFW@vger.kernel.org>
In-Reply-To: <1209764630.7827.15.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>, Kasper Sandberg <lkml@metanurb.dk>
Cc: David Rees <drees76@gmail.com>, David Lethe <david@santools.com>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

--- On Fri, 5/2/08, Kasper Sandberg <lkml@metanurb.dk> wrote:

> From: Kasper Sandberg <lkml@metanurb.dk>
> Subject: Re: Sharing disks amoung multiple software RAIDs
> To: "David Greaves" <david@dgreaves.com>
> Cc: "David Rees" <drees76@gmail.com>, "David Lethe" <david@santools.c=
om>, alex14641@yahoo.com, "Justin Piszcz" <jpiszcz@lucidpixels.com>, li=
nux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
> Date: Friday, May 2, 2008, 5:43 PM
> On Fri, 2008-05-02 at 09:25 +0100, David Greaves wrote:
> > Kasper Sandberg wrote:
> > > Im not treating it as a backup, what i want, is
> to make sure that if 1
> > > disk dies, the data is still intact and ill
> hopefully be able to run
> > > with 1 disk till the newly ordered one arrives
> > Probably one of the main design objectives behind
> RAID/md
>=20
> Exactly, but once people start saying: "Look how many
> problems people
> post to the thread on
> a weekly basis where people lose their data when md
> rebuilds go bad with
> non-shared disks" i begin to worry..
>=20
> >=20
> > > So my question remains.. Is md raid1 not suited
> for this need? would it
> > > be safer to run in non-raid1 mode and daily(maybe
> hourly) rsync
> > > everything over to the second disk?
> >=20
> > md is 100% guaranteed perfect or your money back...
> > rsync is 100% guaranteed perfect or your money back...
> > your backups are 100% guaranteed perfect or your money
> back...
> > your hard drives are 100% guaranteed perfect or your
> money back...
> > your CPU and RAM are 100% guaranteed perfect or your
> money back...
> > your CPU and PSU fans are 100% guaranteed perfect or
> your money back...
> >=20
> > Clearly if you want to panic over reliability you have
> lots of choices :)
>=20
> I do not wish to panic, i merely wished to know if linux MD
> is believed
> to work in most cases, or believed to do all sorts of weird
> stuff when
> resyncing :)
>=20
> >=20
> > David
> > PS, FWIW md has saved my data* countless times over
> the past 'n' years in
> > exactly the scenario you describe.
>=20
> It has also been useful to people i know, i just wished to
> be sure :)
> and as Keld J=F8rn Simonsen and Helge Hafting's comments
> seems to confirm,
> linux md IS nice and stable :)
>=20
> and as said, what im looking for isnt an in-box backup
> solution, merely
> safety in case one disk burns :)
>=20
> >=20
> > *(or more accurately has saved me from having to
> restore my data)

Just to add another data point, I've been using md in RAID 5 configurat=
ion for ~3 years with dedicated USB and SATA disks=20
(not mixed) and have had disks go bad, and have yet to lose=20
any data. Given the 'quality' of high-capacity disks nowadays,
RAIDing them is the right thing to do.


      _________________________________________________________________=
___________________
Be a better friend, newshound, and=20
know-it-all with Yahoo! Mobile.  Try it now.  http://mobile.yahoo.com/;=
_ylt=3DAhu06i62sR8HDtDypao8Wcj9tAcJ
